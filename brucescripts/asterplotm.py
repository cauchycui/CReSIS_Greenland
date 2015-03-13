# -*- coding: utf-8 -*-
import os, sys, pdb
import time
import gdal, ogr
from optparse import OptionParser
import struct

import matplotlib; matplotlib.use('Agg')
from pylab import *
from matplotlib import colors
from scipy import interpolate

from grid_cluster import pnts2mat_cluster, griddict2mat
from fileutil import myloadtxt, mysavetxt
from variopy import vario
from varioutil import pond_along_track_cnt
from projutil import angle_branch, utm_transform, tm_transform
from imageutil import load_aster, subset_img, imresize

t = time.time()

var_targets_dict = {'peakdiff':r'$\Delta peak (\mu s)$',
                    'pond':r'$pond$',
		    'ppond':r'$ppond$',
                    'sigmas':r'$\sigma_1, \sigma_2 (\mu s)$',
                    'elev':r'$elev (m)$',
                    'slope':r'$slope$',
                    'gain':r'$gain$'}
# Options
op = OptionParser()
op.add_option('--glas-file', dest='glas_filename',
              help='Glas file (12 var ascii format)', metavar='FILE')
op.add_option('--par-file', dest='par_filename',
              help='Glas derived parameters file', metavar='FILE')
op.add_option('--ppar-file', dest='ppar_filename',
              help='Trying to put in wiggle data but not sure how', metavar='FILE')
op.add_option('-d', '--debug', dest='debug', action='store_true', default=False,
              help='Use low res aster and be verbose.')
op.add_option('-z', '--zoom', dest='zoom', type='int', default=1,
              help='Set zoom level from 1-3.')
op.add_option('-v', '--vars', dest='var_targets', type='string',
              help='Choose one or two variables to plot.  Any of: %s' % ', '.join(var_targets_dict.keys()))
op.add_option('--printdateandfilename', dest='printmeta', default=False, action='store_true',
              help='Print date and filename on plot.')
op.add_option('--residual',dest='residual', default=False, action='store_true',
              help='Use residual variogram for pond etc...')
op.add_option('--aster-res',dest='aster_res', type='float',
              help='Set resolution as fraction of full aster image (0.0-1.0)')
op.add_option('--plot-dir', dest='plot_dir', default='',
              help='Directory for saving plot.')
op.add_option('--contoursurf', dest='contoursurf', default=False, action='store_true',
              help='Add contour lines for 3C 1.4k dem')
op.add_option('--contourbed', dest='contourbed', default=False, action='store_true',
              help='Add contour lines for Bamber-bed5k')
op.add_option('--contourthick', dest='contourthick', default=False, action='store_true',
              help='Add contour lines for CRESIS Sheet Thickness')
op.add_option('--orbits', dest='orbits', default=False, action='store_true',
              help='Add reference tracks for IceSAT orbits')
(options, args) = op.parse_args()

var_targets = options.var_targets.split(',') if options.var_targets is not None else []
glas_filename = options.glas_filename
if len(set(var_targets).intersection(set(var_targets_dict.keys()))) != len(var_targets):
    sys.stderr.write('Did not understand variables: %s\n' % options.var_targets)
    sys.exit(1)
if len(var_targets) > 2:
    sys.stderr.write('Can plot up to 2 variables only: %s\n' % options.var_targets)
    sys.exit(1)
if options.residual:
    var_targets_dict['pond'] = '$pond_{res}$'
    
# Consts/init
to_utm = tm_transform(meridian=-51.0)
if glas_filename is not None:
    glas_info = glas_filename.split('.')[0].split('_')
    glas_lbl = glas_info[-1]
    glas_date = glas_info[1][2:4]+'/'+'20'+glas_info[1][:2]
OFFSET = {1:1000,2:600,3:400, 4:200}
#WIN = {1:200,2:150,3:100, 4:100}
WIN = {1:150,2:100,3:50, 4:50}
RES = {1:.3,2:.4,3:.5,4:.6}
if options.aster_res is None:
    options.aster_res = RES[options.zoom]
if options.debug:
    options.aster_res = .1

##### Load ASTER
sys.stderr.write('%f: Loading aster \n' % (time.time()-t))
#aster_filename = '/5hundy/backup/dudetron/agu09/data/ast_l11jak.hdf'
aster_filename = '/data/wallinb/jak/aster/ast_l11jak.hdf'
hdf = gdal.Open(aster_filename)
hdf_sub = gdal.Open(hdf.GetMetadata('SUBDATASETS')['SUBDATASET_3_NAME'])
ast_bounds = {'llclat' : float(hdf_sub.GetMetadata()['SOUTHBOUNDINGCOORDINATE']),
              'llclon' : float(hdf_sub.GetMetadata()['WESTBOUNDINGCOORDINATE']),
              'urclat' : float(hdf_sub.GetMetadata()['NORTHBOUNDINGCOORDINATE']),
              'urclon' : float(hdf_sub.GetMetadata()['EASTBOUNDINGCOORDINATE'])}
img = load_aster(aster_filename, options.aster_res)

if options.zoom == 1: # Bounds for aster scene
    plot_bounds = ast_bounds
if options.zoom == 2:
    plot_bounds = {'llclat' : 69.0, 'llclon' : -50.2,
                    'urclat' : 69.4, 'urclon' : -48.8}
if options.zoom == 3:
    plot_bounds = {'llclat' : 69.0, 'llclon' : -49.9,
                    'urclat' : 69.2, 'urclon' : -49.2}
if options.zoom == 4:
    plot_bounds = {'llclat' : 69.08, 'llclon' : -49.63,
                    'urclat' : 69.16, 'urclon' : -49.35}

lon_pad = (plot_bounds['urclon']-plot_bounds['llclon'])*.1
lat_pad = (plot_bounds['urclat']-plot_bounds['llclat'])*.1
llc_utm = list(to_utm(plot_bounds['llclon'], plot_bounds['llclat']))
urc_utm = list(to_utm(plot_bounds['urclon'], plot_bounds['urclat']))

##### Load GLAS
if glas_filename:
    sys.stderr.write('%f: Loading glas \n' % (time.time()-t))

    glas_data = array(myloadtxt(open(glas_filename, 'r'),
                                line_filter=lambda x:
                    ast_bounds['llclat']<angle_branch(x[0])<ast_bounds['urclat'] and
                    ast_bounds['llclon']<angle_branch(x[1])<ast_bounds['urclon'] and
                    len(set([x[2], x[6], x[7], x[10], x[11]]).intersection(set([2.0**n-1 for n in range(32)])))==0))

if options.par_filename is not None:
    par_data = array(myloadtxt(open(options.par_filename, 'r'),
                               line_filter=lambda x:  llc_utm[0]<x[0]<urc_utm[0] and llc_utm[1]<x[1]<urc_utm[1]))

if options.ppar_filename is not None:
    ppar_data = array(myloadtxt(open(options.ppar_filename, 'r'),
                               line_filter=lambda x:  llc_utm[0]<x[0]<urc_utm[0] and llc_utm[1]<x[1]<urc_utm[1]))

##### Load DEM
if options.contoursurf:
    dtm = array(myloadtxt(open('/data/wallinb/jak/dem/GLA06_428_L3C.dat.utm.dtm')))
    dtm_llc = [min(dtm[:,0]), min(dtm[:,1])]
    dtm_urc = [max(dtm[:,0]), max(dtm[:,1])]
    dtm_mat = dtm[:,2].reshape((71,71))[::-1]
    x = linspace(dtm_llc[0], dtm_urc[0], dtm_mat.shape[0])
    y = linspace(dtm_llc[1], dtm_urc[1], dtm_mat.shape[1])
    dtm_X, dtm_Y = meshgrid(x,y)
    contours = 10
    
elif options.contourbed:
    dtm_data = array([[float(el) for el in line.strip().split(',')] for line in
                      open('/data/wallinb/jak/dem/cresis/jakobshavn_bedmap_pts.txt','r').read().strip().split('\n')[1:]])
    x,y = to_utm(dtm_data[:,0], dtm_data[:,1])
    dtm_X = x.reshape(481, 1340)
    dtm_Y = y.reshape(481, 1340)
    dtm_mat = dtm_data[:,2].reshape(481, 1340)
    dtm_X = dtm_X[::3, ::3]
    dtm_Y = dtm_Y[::3, ::3]
    dtm_mat = dtm_mat[::3, ::3]
    contours = range(-1500, 500, 300)

elif options.contourthick:
    dtm_data = array([[float(el) for el in line.strip().split(',')] for line in
                      open('/data/wallinb/jak/dem/cresis/greenland_thickness_elevation.txt','r').read().strip().split('\n')[1:]])
    dtm_data = array(filter(lambda x: plot_bounds['llclat']-.5<x[1]<plot_bounds['urclat']+.5 and
                                      plot_bounds['llclon']-.5<x[2]<plot_bounds['urclon']+.5, dtm_data))
    x,y = to_utm(dtm_data[:,2], dtm_data[:,1])
    rbf_interp = interpolate.Rbf(x, y, dtm_data[:,3], function='cubic')
    
    x = linspace(llc_utm[0], urc_utm[0], (urc_utm[0]-llc_utm[0])/2000.0)
    y = linspace(llc_utm[1], urc_utm[1], (urc_utm[1]-llc_utm[1])/2000.0)
    dtm_X, dtm_Y = meshgrid(x,y)
    dtm_mat = rbf_interp(dtm_X, dtm_Y)
    contours = range(0, 2000, 100)
    
##### Lets plot
sys.stderr.write('%f: Plot init \n' % (time.time()-t))

# Init
rcParams['font.size'] = 10
fig = figure(figsize=(8,6), dpi=150)
fig.figurePatch.set_alpha(0.0)
cb_w, cb_h = .02, .6
ax = fig.add_axes([.1, .1, .55, .8])
cax1 = fig.add_axes([.70,        (1-cb_h)/2.0, cb_w, cb_h])
cax2 = fig.add_axes([.70+cb_w*7, (1-cb_h)/2.0, cb_w, cb_h])
caxes = [cax1, cax2]
for i in range(2-len(var_targets)):
    caxes[1-i].set(visible=False)

if options.zoom == 1:  llc_utm[1] = llc_utm[1]+3000; urc_utm[1] = urc_utm[1]-3000;
if options.zoom == 2:  llc_utm[1] = llc_utm[1]+2000; urc_utm[1] = urc_utm[1]-2000;
if options.zoom == 3:  llc_utm[1] = llc_utm[1]+1000; urc_utm[1] = urc_utm[1]-1000;

# Color stuff
cb_kwargs = dict(orientation='vertical', extend='both', format='%g')
cmap1, cmap2 = cm.jet, cm.hot
sig_norm = colors.Normalize(vmin=0, vmax=4.5)
peak_norm = colors.Normalize(vmin=0, vmax=16)
pond_norm = colors.Normalize(vmin=0, vmax=10000)
pondres_norm = colors.Normalize(vmin=0, vmax=600)
gain_norm = colors.Normalize(vmin=0, vmax=250)
slope_norm = colors.Normalize(vmin=0, vmax=.002)

# Other plots
sys.stderr.write('%f: Plot secondary \n' % (time.time()-t))
offset = -OFFSET[options.zoom]
for i in range(len(var_targets)):
    # sigmas
    if var_targets[i] == 'sigmas':
        x,y = to_utm(glas_data[:,1], glas_data[:,0])
        x = array(list(x+offset)+list(x+offset+OFFSET[options.zoom]))
        y = array(list(y)+list(y))
        z = array(list(glas_data[:, 7])+list(glas_data[:, 11]))/1000.0

        grid_dict = pnts2mat_cluster(zip(x,y,z), WIN[options.zoom])
        track_mat = griddict2mat(grid_dict)
        x = linspace(grid_dict['x_min'], grid_dict['x_max'], grid_dict['x_len'])
        y = linspace(grid_dict['y_min'], grid_dict['y_max'], grid_dict['y_len'])
        X,Y = meshgrid(x,y)
        im = ax.pcolor(X,Y,transpose(track_mat), cmap=cmap1, norm=sig_norm, zorder=3)

        colorbar(im, cax=caxes[i], **cb_kwargs).set_label(var_targets_dict[var_targets[i]])
        offset += 2*OFFSET[options.zoom]
        
    # peakdiff
    if var_targets[i] == 'peakdiff':
        x,y = to_utm(glas_data[:,1], glas_data[:,0])
        x = x+offset
        z = [abs(el[6]-el[10])/1000.0 for el in glas_data]

        grid_dict = pnts2mat_cluster(zip(x,y,z), WIN[options.zoom])
        track_mat = griddict2mat(grid_dict)
        x = linspace(grid_dict['x_min'], grid_dict['x_max'], grid_dict['x_len'])
        y = linspace(grid_dict['y_min'], grid_dict['y_max'], grid_dict['y_len'])
        X,Y = meshgrid(x,y)
        im = ax.pcolor(X,Y,transpose(track_mat), cmap=cmap2, norm=peak_norm, zorder=3)

        colorbar(im, cax=caxes[i], **cb_kwargs).set_label(var_targets_dict[var_targets[i]])
        offset += OFFSET[options.zoom]
        
    if var_targets[i] == 'elev':
        x,y = to_utm(glas_data[:,1], glas_data[:,0])
        z = glas_data[:,2]
        x = x+offset

        grid_dict = pnts2mat_cluster(zip(x,y,z), WIN[options.zoom])
        track_mat = griddict2mat(grid_dict)
        x = linspace(grid_dict['x_min'], grid_dict['x_max'], grid_dict['x_len'])
        y = linspace(grid_dict['y_min'], grid_dict['y_max'], grid_dict['y_len'])
        X,Y = meshgrid(x,y)
        im = ax.pcolor(X,Y,transpose(track_mat), cmap=cmap1, zorder=3)

        colorbar(im, cax=caxes[i], **cb_kwargs).set_label(var_targets_dict[var_targets[i]])
        offset += OFFSET[options.zoom]

    #ppond 
    if var_targets[i] == 'ppond':
        x,y,z = ppar_data[:,0], ppar_data[:,1], ppar_data[:,2]
	x = x-offset
        cutdist=20*(sqrt(pow(x[2]-x[1],2) + pow(y[2]-y[1],2))+sqrt(pow(x[3]-x[2],2) + pow(y[3]-y[2],2)) + sqrt(pow(x[4]-x[3],2) + pow(y[4]-y[3],2)) + sqrt(pow(x[5]-x[4],2) + pow(y[5]-y[4],2)))
        for k in range(len(x)-1):
          if sqrt(pow(x[k+1]-x[k],2) + pow(y[k+1]-y[k],2))<cutdist:
            ax.plot([x[k],x[k+1]],[y[k],y[k+1]],'r-')
        caxes[1].set(visible=False)

    # Pond
    if var_targets[i] == 'pond':
        if options.par_filename is not None:
            x,y,z = par_data[:,0], par_data[:,1], par_data[:,2]
        else:
            x,y = to_utm(glas_data[:,1], glas_data[:,0])
            utm_data = array(zip(x,y, glas_data[:,2]))
            pond = array(pond_along_track_cnt(utm_data, win=11, step=1, var_step=173, var_nres=20, residual=options.residual))
            x,y,z = pond[:,0], pond[:,1], pond[:,2]

        #x = x+offset

        grid_dict = pnts2mat_cluster(zip(x,y,z), WIN[options.zoom])
        track_mat = griddict2mat(grid_dict)
        x = linspace(grid_dict['x_min'], grid_dict['x_max'], grid_dict['x_len'])
        y = linspace(grid_dict['y_min'], grid_dict['y_max'], grid_dict['y_len'])
        X,Y = meshgrid(x,y)
        im = ax.pcolor(X,Y,transpose(track_mat), cmap=cmap1, zorder=3, norm=(pondres_norm if options.residual else pond_norm))

        colorbar(im, cax=caxes[i], **cb_kwargs).set_label(var_targets_dict[var_targets[i]])
        offset += OFFSET[options.zoom]
        
    # Slope
    if var_targets[i] == 'slope':
        x,y = to_utm(glas_data[:,1], glas_data[:,0])
        z = [abs((glas_data[j+1][2]-glas_data[j][2])/((x[j+1]-x[j])**2+(y[j+1]-y[j])**2)) for j in range(len(glas_data)-1)]
        x = x+offset

        grid_dict = pnts2mat_cluster(zip(x,y,z), WIN[options.zoom])
        track_mat = griddict2mat(grid_dict)
        x = linspace(grid_dict['x_min'], grid_dict['x_max'], grid_dict['x_len'])
        y = linspace(grid_dict['y_min'], grid_dict['y_max'], grid_dict['y_len'])
        X,Y = meshgrid(x,y)
        im = ax.pcolor(X,Y,transpose(track_mat), cmap=cmap1, zorder=3, norm=slope_norm)
        
        colorbar(im, cax=caxes[i], **cb_kwargs).set_label(var_targets_dict[var_targets[i]])
        offset += OFFSET[options.zoom]

    # Gain
    if var_targets[i] == 'gain':
        x,y = to_utm(glas_data[:,1], glas_data[:,0])
        z = glas_data[:,3]
        x = x+offset

        grid_dict = pnts2mat_cluster(zip(x,y,z), WIN[options.zoom])
        track_mat = griddict2mat(grid_dict)
        x = linspace(grid_dict['x_min'], grid_dict['x_max'], grid_dict['x_len'])
        y = linspace(grid_dict['y_min'], grid_dict['y_max'], grid_dict['y_len'])
        X,Y = meshgrid(x,y)
        im = ax.pcolor(X,Y,transpose(track_mat), cmap=cmap1, zorder=3, norm=gain_norm)

        colorbar(im, cax=caxes[i], **cb_kwargs).set_label(var_targets_dict[var_targets[i]])
        offset += OFFSET[options.zoom]
    #Wf Number
    if var_targets[i] == 'wfn':
      
# Plot aster
sys.stderr.write('%f: Plot aster \n' % (time.time()-t))
x,y = (linspace(ast_bounds['llclon'], ast_bounds['urclon'], img.shape[0]),
       linspace(ast_bounds['llclat'], ast_bounds['urclat'], img.shape[1]))
x, y, img = subset_img(x, y, img,
                       [plot_bounds['llclon'], plot_bounds['urclon']],
                       [plot_bounds['llclat'], plot_bounds['urclat']])
X,Y = meshgrid(x, y)
sh = img.shape
X,Y = [ar.reshape((sh[1],sh[0])) for ar in to_utm(X.ravel(),Y.ravel())]
cmap = cm.Blues_r; cmap.set_under('black')
ax.pcolormesh(X, Y, transpose(img), cmap=cmap, norm=colors.Normalize(vmin=20, vmax=256), zorder=1, antialiased=True)

# Plot contour
if options.contourbed:
    contour = ax.contour(dtm_X, dtm_Y, dtm_mat, contours, zorder=2, linewidths=.5)
    if len(var_targets) == 1:
        caxes[1].set(visible=True)
        colorbar(contour, cax=caxes[1], **cb_kwargs).set_label('bed elev(m)')
elif options.contoursurf or options.contourthick:
    contour = ax.contour(dtm_X, dtm_Y, dtm_mat, contours, zorder=2, colors='k', linewidths=.5)
    cl = clabel(contour, fontsize=8, inline=True, fmt='%d')

# Plot orbit tracks
if options.orbits:
    file = open('/data/wallinb/icesat/t91p.reforb', 'r')
    ref_track = zip(angle_branch(struct.unpack('>5801f', file.read(23204))[:-1]),
                    angle_branch(struct.unpack('>5801f', file.read(23204))[:-1]))
    for i in range(1354):
        data = array(filter(lambda x: ast_bounds['llclat']<angle_branch(x[0])<ast_bounds['urclat'] and
                                      ast_bounds['llclon']<angle_branch(x[1])<ast_bounds['urclon'],
                            map(lambda x: [x[0],x[1]+i*360.0/1354.0], ref_track)))
        if len(data) > 0:
            x,y = to_utm(data[:,1], data[:,0])
            line1 = ax.plot(x, y, 'r-')

    file = open('/data/wallinb/icesat/t8p.reforb', 'r')
    ref_track = zip(angle_branch(struct.unpack('>5801f', file.read(23204))[:-1]),
                    angle_branch(struct.unpack('>5801f', file.read(23204))[:-1]))
    for i in range(119):
        data = array(filter(lambda x: ast_bounds['llclat']<angle_branch(x[0])<ast_bounds['urclat'] and
                                      ast_bounds['llclon']<angle_branch(x[1])<ast_bounds['urclon'],
                            map(lambda x: [x[0],x[1]+i*360.0/119.0], ref_track)))
        if len(data) > 0:
            x,y = to_utm(data[:,1], data[:,0])
            line2 = ax.plot(x, y, 'g-')

    ax.legend((line1, line2), ('91-Day Track', '8-Day Track'))

        
# Finish up
save_name = os.path.join(options.plot_dir, 'jak')
if options.glas_filename is not None:
    save_name += 'GLAS%s_'%glas_lbl + ''.join(var_targets) + ('res' if options.residual else '')
if options.orbits:
    save_name += '_orbits'
save_name += '_zoom%d'%options.zoom
save_name += ('_c' if options.contoursurf else '') + \
             ('_b' if options.contourbed else '') + \
             ('_t' if options.contourthick else '')+ '.png'

fig_lbl = ''
if options.glas_filename:
    fig_lbl += '\\noindent GLAS %s %s '%(glas_lbl, glas_date)+('left to right' if len(var_targets)>1 else '')+':  ' + \
              ', '.join([var_targets_dict[el] for el in var_targets])

fig_lbl += ' \\ASTER 3B 05-2003 Background'
fig_lbl += (' with 1.5 km GLAS 3C DEM' if options.contoursurf else
           (' with CRESIS Bed contours' if options.contourbed else
           (' with CRESIS Thickness contours' if options.contourthick else '')))

ax.text(.5, -.22, fig_lbl, horizontalalignment='center', transform=ax.transAxes, fontsize=10)

meta_lbl = save_name+' '+'-'.join([str(el) for el in time.localtime()[:3]])
if options.printmeta:
    ax.text(0.5, 0, meta_lbl, fontsize=8, horizontalalignment='center', transform=fig.transFigure)
    
ax.set_xlim(llc_utm[0], urc_utm[0])
ax.set_ylim(llc_utm[1], urc_utm[1])
ax.set_aspect('equal')
ax.grid()
for label in ax.get_xticklabels()+ax.get_yticklabels():
    label.set_size(8)
ax.set_xlabel('Easting (m)', fontsize=8)
ax.set_ylabel('Northing (m)', fontsize=8)

sys.stderr.write('%f: Saving fig to %s \n' % (time.time()-t, save_name))
savefig(save_name, dpi=(220 if not options.debug else 120))
sys.stderr.write('Took: %d seconds\n' % (time.time()-t))

