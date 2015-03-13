function inareacount=checkLVIS(filename)
%Read LVIS ASCII data lat lon coordinates and plot them onto a google maps
%image
%jak bounds
latmax=69.5;
latmin=68.5;
lonmin=-51.25;
lonmax=-46.8333;
fid=fopen(filename);
inareacount=0;
aline=fgetl(fid);
while(ischar(aline))
    data=sscanf(aline, '%f %f %f\n');
    lon=data(1);
    lat=data(2);
    if ((lon>lonmin)&&(lon<lonmax)&&(lat>latmin)&&(lat<latmax))
        inareacount=inareacount+1;
    end
    aline=fgetl(fid);
end
end