%function [ davg, points, xUTMavg, yUTMavg ] = avggriddata(filename, varargin)
%AVGGRIDDATA takes a file made with seagridsavesort and finds the average
%of the points within it
filename='/data/phil/searise/cresisboxes/try1/Area-3917,-22624.txt';
fid=fopen(filename, 'r');
points=0;
davg=0;
xUTMavg=0;
yUTMavg=0;
a_line=fgetl(fid);
while(ischar(a_line))
    datum=sscanf(a_line, '%d: %f %f %f');
    if isequal(size(datum), [4, 1])
        points=points+1;
        davg=davg+datum(4);
        xUTMavg=xUTMavg+datum(2);
        yUTMavg=yUTMavg+datum(3);
    end
    a_line=fgetl(fid);
end
davg=davg/points;
xUTMavg=xUTMavg/points;
yUTMavg=yUTMavg/points;
fclose(fid);
%end