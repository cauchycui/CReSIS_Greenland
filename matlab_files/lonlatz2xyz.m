function lonlatz2xyz( filename)
%UNTITLED4 Summary of this function goes here
%   converts an xyz file to lon lat z using utm2deg.m
ifid=fopen(filename);
ofid=fopen([filename '.utm'], 'w');
line_in=fgetl(ifid);
while(ischar(line_in))
    data=sscanf(line_in, '%f', 3);
    if(size(data,1)>0)
        [x y zone]=deg2utm(data(2), data(1));
        fprintf(ofid, '%f %f %f\n', x, y, data(3));
    end
    line_in=fgetl(ifid);
end
end

