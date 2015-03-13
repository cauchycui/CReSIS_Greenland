function count=plotLVIS(varargin)
%Read LVIS ASCII data lat lon coordinates and plot them onto a google maps
%image
filename=varargin{1};
if size(varargin, 2)>1
    marker=varargin{2};
else
    marker=1;
end;
%plotGreenland;
hold on;
latjakbounds=[69.5 69.5 68.5 68.5];
lonjakbounds=[-51.25 -46.8333 -46.8333 -51.25];
plot(lonjakbounds, latjakbounds, 'b');
fid=fopen(filename);
count=0;
aline=fgetl(fid);
while(ischar(aline))
    data=sscanf(aline, '%f %f %f\n');
    lon=data(1);
    lat=data(2);
    if ((lon>-80)&&(lon<-10)&&(lat>59)&&(lat<84))
        count=count+1;
    end
    if (count~=marker)
        plot(lon, lat, 'ro');
    else
        plot(lon, lat, 'go', 'linewidth', 8);
    end
    aline=fgetl(fid);
end
hold off;
end