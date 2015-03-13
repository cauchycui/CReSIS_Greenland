function [minx maxx miny maxy] = seagridsavesort(datafile, year, dirpath)
%sorts all the data into 100x100m boxes lined up with the searise grid
%NOTE: assumes searise coordinates mark lower left corner of a box
%outfile='/data/phil/searise/cresisboxes/try2.txt/';
file_length=wc(datafile);
infid=fopen(datafile, 'r');
a_line=fgetl(infid);
wbh=waitbar(0, '0% done');
set(wbh, 'name', 'seagridsort sorting data into a grid...');
minx=inf;
maxx=-inf;
miny=inf;
maxy=-inf;
%ofid=fopen(outfile, 'w');
for i=1:file_length
    data=sscanf(a_line, '%f', 3);
    x=floor(data(1)/100);
    if x<minx
        minx=x;
    elseif x>maxx
        maxx=x;
    end
    y=floor(data(2)/100);
    if y<miny
        miny=y;
    elseif y>maxy
        maxy=y;
    end
    fname=['Area' num2str(x) ',' num2str(y) '.txt'];
    [status, result] = system(['ls ' dirpath fname]);
    fid=fopen([dirpath fname], 'a+');
    if (status==0)
        fprintf(fid, ['\n' year ': %s'], a_line);
    elseif (status==2)
        fprintf(fid, [year ': %s'], a_line);
    else
        error(['ls error: ' result])
    end
    fclose(fid);
    progress=(i/file_length);
    waitbar(progress, wbh, [num2str(100*progress)...
        '% done']);
    a_line=fgetl(infid);
end
close(wbh);
fclose(infid);
end