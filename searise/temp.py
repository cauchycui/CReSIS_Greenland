import os

#import matplotlib
#matplotlib.use('qtagg')
#from pylab import *
import numpy

from optparse import OptionParser

from fileutil import parse_txt2num
 
 
usage = "usage: % prog [options] DATAFILE"
op = OptionParser(usage=usage)
op.add_option('-d', dest='save_dir', default="plots",
                help='Directory will be saved in')            
(options, args) = op.parse_args()

file = args[0]

print "loading data"
data = list(parse_txt2num(open(file, 'r')))
print "done"
print "filtering data"
#f_data = filter(lambda x: not x[3] == 2147483647, data)
#figure()
#f_data = array(f_data)
#scatter(f_data[:,2], f_data[:,1], c=f_data[:,3], faceted=False)    
#colorbar()
#show()            
#quit

#box 1  (69350000, 68850000, 49900000, 48900000)
#box 2   

zoom = filter(lambda x: x[0] < 69200000, data)
zoom = filter(lambda x: x[0] > 69040000, zoom)
zoom = filter(lambda x: (360000000 - x[1]) < 49600000 , zoom)
zoom = filter(lambda x: (360000000 - x[1]) > 49200000, zoom)
    
zoom = array(zoom)        
scatter(zoom[:,1], zoom[:,0], c=zoom[:,2], faceted=False)    
colorbar()
show() 
t1  = filter(lambda x: x[1] < 310555000, zoom)
t2  = filter(lambda x: x[1] >= 310555000, zoom)
    
fig_ind = 0             
for line_list in t1:
    fig_ind += 1
    pre_list = line_list[:3]
    tx_wf = [int(i) for i in line_list[3:51]]
    rx_wf = [int(i) for i in line_list[51:]]
    text_file = open("test.txt", "w")
    text_file.writelines(line_list)
    #figure(fig_ind)
    #plot(rx_wf)
    #name = str(pre_list[0])+"_"+str(pre_list[1])
    #savefig("plots/t1/"+name+".png")
             
for line_list in t2:
    fig_ind += 1
    pre_list = line_list[:3]
    tx_wf = [int(i) for i in line_list[3:51]]
    rx_wf = [int(i) for i in line_list[51:]]
    #figure(fig_ind)
    #plot(rx_wf)
    #name = str(pre_list[0])+"_"+str(pre_list[1])
    #savefig("plots/t2/"+name+".png")
                 
print "done"
print len(zoom), min(map(lambda x: x[0], zoom))
    
# /data1/ws/util2/progs 89/ 