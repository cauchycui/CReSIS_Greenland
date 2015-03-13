function xyz2lonlatz( filename, zone )
%UNTITLED4 Summary of this function goes here
%   converts an xyz file to lon lat z using utm2deg.m
ifid=fopen(filename);
ofid=fopen([filename '.deg'], 'w');
line_in=fgetl(ifid);
while(ischar(line_in))
    data=sscanf(line_in, '%f', 3);
    if(size(data,1)>0)
        [lat lon]=utm2deg(data(1), data(2), zone);
        fprintf(ofid, '%f %f %f\n', lon, lat, data(3));
    end
    line_in=fgetl(ifid);
end
end

