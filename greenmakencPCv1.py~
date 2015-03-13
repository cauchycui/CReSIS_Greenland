#!/usr/bin/python

'''NetCDF creation script for Greenland March 2009
Authors: Tim Bocek, Jesse Johnson, Brian Hand
 University of Montana'''
from pylab import *
import glimcdf
import pycdf
import numpy
from pycdf import NC
from pyproj import *
import scipy.interpolate as sp
import scipy 
from scipy.io.numpyio import fwrite, fread
import scipy.ndimage as spi
from matplotlib.mlab import griddata



regridFactor = 1.0
version = 0.91


#Use Bueler's topg with bathymetry, and basal heat flux from netCDF
ncInput = pycdf.CDF('data/ncfiles/green5km_Bueler.nc')
bed = ncInput.var('topg')
bed = bed.get()
bheatflx = ncInput.var('bheatflx')
bheatflx = bheatflx.get()


#bheatflx = -bheatflx

ncInput = pycdf.CDF('data/ncfiles/Greenland_5km_v7.1.nc')
balvel = ncInput.var('balvelmag')[:]

burgess_precip = glimcdf.file_reader("data/burgessprecipGland5km.txt")
csatho_precip = glimcdf.file_reader("data/csathoprecipGland5km.txt")

# Read in the data in the text files
srf = glimcdf.file_reader("data/GlandSurface5km.txt")
thk = glimcdf.file_reader("data/GlandThk5km.txt")
lat = glimcdf.file_reader("data/GlandLat5km.txt")
lon = glimcdf.file_reader("data/GlandLon5km.txt")
surfvel = glimcdf.file_reader("data/surfvel5kmGlandFinal.txt")





# Read in the data for the time series and split the arrays into times and data
temp_time_series = glimcdf.file_reader("data/GRIP125kyr_temps.txt", 2, 1251,header = False)
temp_times = temp_time_series.data[:,0]
temp_data = temp_time_series.data[:,1]

sealevel_time_series = glimcdf.file_reader("data/specmap125.txt",2,126,header = False)
sealevel_times = sealevel_time_series.data[:,0]
sealevel_data = sealevel_time_series.data[:,1]

oisotopes_time_series = glimcdf.file_reader("data/GRIP125kyr_oisotopes.txt",2,1251,header = False)
oisotopes_times = oisotopes_time_series.data[:,0]
oisotopes_data = oisotopes_time_series.data[:,1]




ncols2 = 301
nrows2 = 561


#Output grid
oncols = int(301/regridFactor) 
onrows = int(561/regridFactor)
oxllcorner = -800000.
oyllcorner = -3400000.
ogridSpacing2 = 5000.
ogridSpacing = 5000 * regridFactor











[xGridOutput, yGridOutput] = numpy.mgrid[ oxllcorner:(oxllcorner + ogridSpacing * oncols):\
           ogridSpacing, oyllcorner:oyllcorner + ogridSpacing * onrows:ogridSpacing]
[xGridInput, yGridInput] = numpy.mgrid[ oxllcorner:(oxllcorner + ogridSpacing * ncols2):\
           ogridSpacing2, oyllcorner:oyllcorner + ogridSpacing2 * nrows2:ogridSpacing2]

balvel = balvel.reshape(nrows2,ncols2)
balvel = numpy.asarray(balvel, dtype ='float32')

#For scaling
bed = glimcdf.regridData(bed, oxllcorner, oyllcorner, oxllcorner, oyllcorner, ncols2, nrows2, ogridSpacing2, regridFactor)
thk.data = glimcdf.regridData(thk.data, thk.xllcorner, thk.yllcorner, oxllcorner, oyllcorner, ncols2, nrows2, ogridSpacing2, regridFactor)
lat.data = glimcdf.regridData(lat.data, lat.xllcorner, lat.yllcorner, oxllcorner, oyllcorner, ncols2, nrows2, ogridSpacing2, regridFactor )
srf.data = glimcdf.regridData(srf.data, srf.xllcorner, srf.yllcorner, oxllcorner, oyllcorner, ncols2, nrows2, ogridSpacing2, regridFactor)
lon.data = glimcdf.regridData(lon.data, lon.xllcorner, lon.yllcorner, oxllcorner, oyllcorner, ncols2, nrows2, ogridSpacing2, regridFactor)
surfvel.data = glimcdf.regridData(surfvel.data, surfvel.xllcorner, surfvel.yllcorner, oxllcorner, oyllcorner, ncols2, nrows2, ogridSpacing2, regridFactor)
bheatflx = glimcdf.regridData(bheatflx,oxllcorner,oyllcorner,oxllcorner,oyllcorner,ncols2,nrows2,ogridSpacing2,regridFactor)
balvel = glimcdf.regridData(balvel, oxllcorner, oyllcorner, oxllcorner, oyllcorner, ncols2, nrows2, ogridSpacing2, regridFactor)
burgess_precip.data = glimcdf.regridData(burgess_precip.data,oxllcorner,oyllcorner,oxllcorner,oyllcorner,ncols2,nrows2,ogridSpacing2,regridFactor)
csatho_precip.data = glimcdf.regridData(csatho_precip.data,oxllcorner,oyllcorner,oxllcorner,oyllcorner,ncols2,nrows2,ogridSpacing2,regridFactor)




thk.data[thk.data<=1.0] = 0.0



srf.data[srf.data==-0.1] = 0.0

presartm = numpy.zeros((onrows,oncols))

for i in range(onrows):
    for j in range(oncols):
        presartm[i,j] = 41.83 + -6.309*(srf.data[i,j]/1000) + -0.7189 * lat.data[i,j] + 0.0672 *( -lon.data[i,j]) 

        
presartm = numpy.asarray(presartm, dtype ='float32')            


presprcp = burgess_precip.data
for i in range(onrows):
    for j in range(oncols):
        if presprcp[i,j] <= 10e-2:
            presprcp[i,j] = csatho_precip.data[i,j]


presprcp = glimcdf.regridData(presprcp,oxllcorner,oyllcorner,oxllcorner,oyllcorner,ncols2,nrows2,ogridSpacing2,regridFactor)







#Our projection of choice, the Greenland master file set projection based on Bamber
params2 = {}
params2['proj']    = 'stere'  # Stereographic project
params2['lon_0']   =  -39.0       # Central meridian
params2['lat_0']   =  90       # Central meridian
params2['lat_ts']  = 71     # Latitude of true scale
params2['ellps']   = 'WGS84'  # The ellipsoid used. 
params2['x0']      = 0.0   # Offset to x lower left corner.
params2['y0']      = 0.0   # Offset to y lower left corner.

psp2 = Proj(params2)












file = "greenland_" + str(5 * int(regridFactor)) + "km_v" + str(version) +".nc"
#Set up the Output netCDF file
nc = pycdf.CDF(file, NC.WRITE | NC.CREATE | NC.TRUNC)
nc.automode()


# Set up the projected grid XY coordinates
glimcdf.setup_dimensions(nc, xGridOutput, yGridOutput, temps = temp_times, sealevel = sealevel_times, oisotopes = oisotopes_times )

# Setup the variables to be written to the netCDF file.
mapping = nc.def_var("mapping",NC.CHAR)
glimcdf.set_variable_attribute(nc,mapping, "grid_mapping_name","polar_stereographic")
glimcdf.set_variable_attribute(nc,mapping, "false_easting",0.0,NC.DOUBLE)
glimcdf.set_variable_attribute(nc,mapping, "false_northing",0.0,NC.DOUBLE)
glimcdf.set_variable_attribute(nc,mapping, "latitude_of_projection_origin",90.0,NC.DOUBLE)
glimcdf.set_variable_attribute(nc,mapping, "straight_vertical_longitude_from_pole",-39.0,NC.DOUBLE)
glimcdf.set_variable_attribute(nc,mapping, "standard_parallel",71.,NC.DOUBLE)

lon_var = glimcdf.setup_variable(nc, "lon")
glimcdf.set_variable_attribute(nc,lon_var, "long_name","longitude")
glimcdf.set_variable_attribute(nc,lon_var, "standard_name","longitude")
glimcdf.set_variable_attribute(nc,lon_var, "units","degreeE")
glimcdf.set_variable_attribute(nc,lon_var, "grid_mapping","mapping")

lat_var = glimcdf.setup_variable(nc, "lat")
glimcdf.set_variable_attribute(nc,lat_var, "long_name","latitude")
glimcdf.set_variable_attribute(nc,lat_var, "standard_name","latitude")
glimcdf.set_variable_attribute(nc,lat_var, "units","degreeN")
glimcdf.set_variable_attribute(nc,lat_var, "grid_mapping","mapping")

bed_var = glimcdf.setup_variable(nc, "topg")
glimcdf.set_variable_attribute(nc,bed_var, "long_name","bedrock topography")
glimcdf.set_variable_attribute(nc,bed_var, "standard_name","bedrock_altitude")
glimcdf.set_variable_attribute(nc,bed_var, "units","meter")
glimcdf.set_variable_attribute(nc,bed_var, "Source","Topography -Bamber, J.L., R.L. Layberry, S.P. Gogenini. 2001."
                                           "A new ice thickness and bed data set for the Greenland ice sheet 1:" 
                                           "Measurement, data reduction, and errors. Journal of Geophysical" 
                                           "Research 106 (D24): 33773-33780.," 
                                           "Bamber, J.L., R.L. Layberry, S.P. Gogenini. 2001." 
                                           "A new ice thickness and bed data set for the Greenland ice sheet 2:"
                                           "Relationship between dynamics and basal topography. Journal of" 
                                           "Geophysical Research 106 (D24): 33781-33788. "
                                           "Bathymetry - www.ibcao.org Jakobsson, M., Macnab, R., Mayer, L., "
                                           "Anderson, R., Edwards, M., Hatzky, J., Schenke, H-W., and Johnson, "
                                           "P., 2008, An improved bathymetric portrayal of the Arctic Ocean: "
                                           "Implications for ocean modeling and geological, geophysical and "
                                           "oceanographic analyses, v. 35, L07602, Geophysical Research Letters, "
                                           "doi:10.1029/2008GL033520")
#glimcdf.set_variable_attribute(nc,bed_var, "coordinates","lon lat")
glimcdf.set_variable_attribute(nc,bed_var, "grid_mapping","mapping")
    
thk_var = glimcdf.setup_variable(nc, "thk")
glimcdf.set_variable_attribute(nc,thk_var, "long_name","ice thickness")
glimcdf.set_variable_attribute(nc,thk_var, "standard_name","land_ice_thickness")
glimcdf.set_variable_attribute(nc,thk_var, "units","meter")
glimcdf.set_variable_attribute(nc,thk_var, "Source","Bamber, J.L., R.L. Layberry, S.P. Gogenini. 2001."
                                           "A new ice thickness and bed data set for the Greenland ice sheet 1:" 
                                           "Measurement, data reduction, and errors. Journal of Geophysical" 
                                           "Research 106 (D24): 33773-33780.," 
                                           "Bamber, J.L., R.L. Layberry, S.P. Gogenini. 2001." 
                                           "A new ice thickness and bed data set for the Greenland ice sheet 2:"
                                           "Relationship between dynamics and basal topography. Journal of" 
                                           "Geophysical Research 106 (D24): 33781-33788.")
#glimcdf.set_variable_attribute(nc,thk_var, "coordinates","lon lat")
glimcdf.set_variable_attribute(nc,thk_var, "grid_mapping","mapping")

srf_var = glimcdf.setup_variable(nc, "usrf")
glimcdf.set_variable_attribute(nc,srf_var, "long_name","ice upper surface elevation")
glimcdf.set_variable_attribute(nc,srf_var, "standard_name","surface_altitude")
glimcdf.set_variable_attribute(nc,srf_var, "units","meter")
glimcdf.set_variable_attribute(nc,srf_var, "Source","Bamber, J.L., R.L. Layberry, S.P. Gogenini. 2001."
                                           "A new ice thickness and bed data set for the Greenland ice sheet 1:" 
                                           "Measurement, data reduction, and errors. Journal of Geophysical" 
                                           "Research 106 (D24): 33773-33780.," 
                                           "Bamber, J.L., R.L. Layberry, S.P. Gogenini. 2001." 
                                           "A new ice thickness and bed data set for the Greenland ice sheet 2:"
                                           "Relationship between dynamics and basal topography. Journal of" 
                                           "Geophysical Research 106 (D24): 33781-33788.")
glimcdf.set_variable_attribute(nc,srf_var, "grid_mapping","mapping")

#Bea's new precip data
presprcp_var = glimcdf.setup_variable(nc, "presprcp")
glimcdf.set_variable_attribute(nc,presprcp_var, "long_name","present precipitation")
glimcdf.set_variable_attribute(nc,presprcp_var, "units","meter/year")
glimcdf.set_variable_attribute(nc,presprcp_var, "Sources","Burgess, E. W.; Forster, R. R.; Box, J. W.; "
                                           "Smith, L. C.; Bromwich, D. H., 2008, A Spatially "
                                           "Calibrated Model of Annual Accumulation Rate on the "
                                           "Greenland Ice Sheet (1958-2007) In Review "
                                           "van der Veen, C. J., D. H. Bromwich, B. Csatho, and C. Kim, 2001. Trend analysis of Greenland"
                                           " precipitation. J. Geophys. Res., 106(D24), 33,909-33,918 (2001JD900156). " 
                                           "Box, J.E., and K. Steffen, 2001. Sublimation on the Greenland ice sheet from "
                                           "automated weather station observations. J. Geophys. Res. 106(D24), 33,965-33,981.")
glimcdf.set_variable_attribute(nc,presprcp_var, "grid_mapping","mapping")


presartm_var = glimcdf.setup_variable(nc, "presartm")
glimcdf.set_variable_attribute(nc,presartm_var, "long_name","annual mean air temperature")
glimcdf.set_variable_attribute(nc,presartm_var, "standard_name","surface_temperature")
glimcdf.set_variable_attribute(nc,presartm_var, "units","degree_Celsius")
glimcdf.set_variable_attribute(nc,presartm_var, "Source", "Fausto, R. S., Ahlstrom A. P., Van As Dirk, Boggild C.E., Johnsen S. J., 2009.  A new "
                                                "present-day temperature parameterization for Greenland.  Journal of Glaciology, 55:95-105,189  ")
glimcdf.set_variable_attribute(nc,presartm_var, "grid_mapping","mapping")

bheatflx_var = glimcdf.setup_variable(nc, "bheatflx")
glimcdf.set_variable_attribute(nc,bheatflx_var, "long_name","basal heat flux")
glimcdf.set_variable_attribute(nc,bheatflx_var, "standard_name","basal_heat_flux")
glimcdf.set_variable_attribute(nc,bheatflx_var, "units","watts/meter2")
glimcdf.set_variable_attribute(nc,bheatflx_var, "Source", "http://ciei.colorado.edu/~nshapiro/MODEL/ASC_VERSION/ "
                                                "Shapiro, N. M. and Ritzwoller, M. H. (2004). Inferring surface heat flux "
                                                "distributions guided by a global seismic model: particular application to "
                                                "Antarctica. Earth and Planetary Science letters, 223: 213-224.")                                                
glimcdf.set_variable_attribute(nc,bheatflx_var, "grid_mapping","mapping")

balvel_var = glimcdf.setup_variable(nc, "balvelmag")
glimcdf.set_variable_attribute(nc,balvel_var, "long_name","balance_velocity_magnitude")
glimcdf.set_variable_attribute(nc,balvel_var, "units","meter/yr")
glimcdf.set_variable_attribute(nc,balvel_var, "Source", "Created by Jesse Johnson at the "
                                                        "University of Montana, July-09, "
                                                        "created from presprcp (van der "
                                                        "Veen, C. J., D. H. Bromwich, B. "
                                                        "Csatho, and C. Kim, 2001.) and the "
                                                        "thickness field (Bamber, J.L., R.L. "
                                                        "Layberry, S.P. Gogenini. 2001.)"
                                                        "using the Glimmer/CISM model")
glimcdf.set_variable_attribute(nc,balvel_var, "grid_mapping","mapping")

surfvel_var = glimcdf.setup_variable(nc, "surfvelmag")
glimcdf.set_variable_attribute(nc,surfvel_var, "long_name","surface_velocity_magnitude")
glimcdf.set_variable_attribute(nc,surfvel_var, "units","meters/yr")
glimcdf.set_variable_attribute(nc,surfvel_var, "Source", "Joughin, Smith, Howat, and Scambos, in prep")
glimcdf.set_variable_attribute(nc,surfvel_var, "grid_mapping","mapping")




#Set up the time and sea level series here, create the var here instead of in glimcdf
tempseries_var = glimcdf.setup_variable(nc,"temp_time_series", other= "temp")
glimcdf.set_variable_attribute(nc,tempseries_var, "long_name","temperature_time_series")
glimcdf.set_variable_attribute(nc,tempseries_var, "units","degree_Celsius")
glimcdf.set_variable_attribute(nc,tempseries_var, "Source", "Johnsen, S.J., H.B. Clausen, W. Dansgaard, N.S. Gundestrup, C.U. Hammer, U. "
                                                  "Andersen, K.K. Andersen, C.S. Hvidberg, D. Dahl-Jensen, J.P. Steffensen, H. "
                                                  "Shoji, A.E. Sveinbj-rnsdUttir, J.W.C. White, J. Jouzel, and D. Fisher. "
                                                  "1997. The d18O record along the Greenland Ice Core Pproject deep ice core "
                                                  "and the problem of possible Eemian climatic instability. Journal of "
                                                  "Geophysical Research 102:26397-26410. "
                                                  "Dansgaard, W., S.J. Johnsen, H.B. Clausen, D. Dahl-Jensen, N.S. Gundestrup, "
                                                  "C.U. Hammer, C.S. Hvidberg, J.P. Steffensen, A.E. Sveinbj-rnsdUttir , J. "
                                                  "Jouzel, and G.C. Bond. 1993. Evidence for general instability of past "
                                                  "climate from a 250 kyr ice-core record. Nature 264:218-220. "
                                                  "GRIP Members. 1993. Climate instability during the last interglacial period "
                                                  "recorded in the GRIP ice core. Nature 364:203-207. "
                                                  "Grootes, P.M., M. Stuiver, J.W.C. White, S.J. Johnsen, and J. Jouzel. 1993. "
                                                  "Comparison of oxygen isotope records from the GISP2 and GRIP Greenland ice "
                                                  "cores. Nature 366:552-554. "
                                                  "Dansgaard, W., J.W.C. White, and S.J. Johnsen. 1989. The abrupt termination "
                                                  "of the Younger Dryas climate event. Nature 339:532-533. ")

oisotopesseries_var = glimcdf.setup_variable(nc,"oisotopes_time_series", other= "oisotopes")
glimcdf.set_variable_attribute(nc,oisotopesseries_var, "long_name","oisotopes_time_series")
glimcdf.set_variable_attribute(nc,oisotopesseries_var, "units","per/mil")
glimcdf.set_variable_attribute(nc,oisotopesseries_var, "Source", "Johnsen, S.J., H.B. Clausen, W. Dansgaard, N.S. Gundestrup, C.U. Hammer, U. "
                                                  "Andersen, K.K. Andersen, C.S. Hvidberg, D. Dahl-Jensen, J.P. Steffensen, H. "
                                                  "Shoji, A.E. Sveinbj-rnsdUttir, J.W.C. White, J. Jouzel, and D. Fisher. "
                                                  "1997. The d18O record along the Greenland Ice Core Pproject deep ice core "
                                                  "and the problem of possible Eemian climatic instability. Journal of "
                                                  "Geophysical Research 102:26397-26410. "
                                                  "Dansgaard, W., S.J. Johnsen, H.B. Clausen, D. Dahl-Jensen, N.S. Gundestrup, "
                                                  "C.U. Hammer, C.S. Hvidberg, J.P. Steffensen, A.E. Sveinbj-rnsdUttir , J. "
                                                  "Jouzel, and G.C. Bond. 1993. Evidence for general instability of past "
                                                  "climate from a 250 kyr ice-core record. Nature 264:218-220. "
                                                  "GRIP Members. 1993. Climate instability during the last interglacial period "
                                                  "recorded in the GRIP ice core. Nature 364:203-207. "
                                                  "Grootes, P.M., M. Stuiver, J.W.C. White, S.J. Johnsen, and J. Jouzel. 1993. "
                                                  "Comparison of oxygen isotope records from the GISP2 and GRIP Greenland ice "
                                                  "cores. Nature 366:552-554. "
                                                  "Dansgaard, W., J.W.C. White, and S.J. Johnsen. 1989. The abrupt termination "
                                                  "of the Younger Dryas climate event. Nature 339:532-533. ")

sealevelseries_var = glimcdf.setup_variable(nc,"sealevel_time_series", other = "sealevel")
glimcdf.set_variable_attribute(nc,sealevelseries_var, "long_name","sealevel_time_series")
glimcdf.set_variable_attribute(nc,sealevelseries_var, "units","meters")
glimcdf.set_variable_attribute(nc,sealevelseries_var, "Source", "Imbrie, John D; McIntyre, A (2006): SPECMAP time scale developed "
                                                "by Imbrie et al., 1984 based on normalized planktonic records (normalized O-18 "
                                                "vs time, specmap.017), doi:10.1594/PANGAEA.441706")




# Set global attributes for the data
glimcdf.set_global_attribute(nc,"Conventions","CF-1.3")
glimcdf.set_global_attribute(nc,"Title","Greenland")
glimcdf.set_global_attribute(nc,"Creators","Jesse Johnson, Brian Hand, Tim Bocek - University of Montana")
glimcdf.set_global_attribute(nc,"Sources","Bamber(Thickness, Bed, Surface), PARCA, Bromwich et al 2001(precip)")
glimcdf.set_global_attribute(nc,"History","Created Feb 2009")
glimcdf.set_global_attribute(nc,"References","")
glimcdf.set_global_attribute(nc,"Comments","Greenland master data set")

print "WRITING DATA"



bed_var[:,:,:] = bed.reshape(1,onrows,oncols)
presprcp_var[:,:,:] = presprcp.reshape(1,onrows,oncols)
#thk_var[:,:,:] = thk.data.reshape(1,onrows,oncols)
srf_var[:,:,:] = srf.data.reshape(1,onrows,oncols)
thk_var[:,:,:]= srf_var[:,:,:]-bed_var[:,:,:]
lon_var[:,:,:] = lon.data.reshape(1,onrows,oncols)
lat_var[:,:,:] = lat.data.reshape(1,onrows,oncols)
presartm_var[:,:,:] = presartm.reshape(1,onrows,oncols)
bheatflx_var[:,:,:] = bheatflx.reshape(1,onrows,oncols)
balvel_var[:,:,:] = balvel.reshape(1,onrows,oncols)
surfvel_var[:,:,:] = surfvel.data.reshape(1,onrows,oncols)
tempseries_var[:] = temp_data
sealevelseries_var[:] = sealevel_data
oisotopesseries_var[:] = oisotopes_data
nc.close()
