function [minx maxx miny maxy file_length] = seagridsave(datafile, year, outfile)
%sorts all the data into 100x100m boxes lined up with the searise grid
%NOTE: assumes searise coordinates mark lower left corner of a box
%  datafile='/data/phil/searise/cresisdata2009_Greenland_TO.txt.utm';
%  year=2009;
%  datafile='/data/phil/searise/cresisdata2010_Greenland_DC8.txt.utm';
%  year=2010;
%outfile='/data/phil/searise/cresisboxes/try3.txt';
%find the length and open the datafile for reading
file_length=wc(datafile);
infid=fopen(datafile, 'r');
a_line=fgetl(infid);

minx=inf;
maxx=-inf;
miny=inf;
maxy=-inf;
%progress bar initialization
tic;
waitmode=-1;
lasttime=0;
%open the file to be written to (will append to an existing file)
if exist(outfile, 'file')==2    
    ofid=fopen(outfile, 'a+');
else
    ofid=fopen(outfile, 'w+');
    if ofid==-1
        error('output file cannot be created')
    end
end
%put the data into the textfile and note the min and max x and y
%currently marks the coordinate as the top right corner of the box
for i=1:file_length
    data=sscanf(a_line, '%f', 3);
    x=100*ceil(data(1)/100);
    if x<minx
        minx=x;
    elseif x>maxx
        maxx=x;
    end
    y=100*ceil(data(2)/100);
    if y<miny
        miny=y;
    elseif y>maxy
        maxy=y;
    end
    fprintf(ofid, '%d %d %f %d\n', x, y, data(3), year);
    %progress bar code
    if ~mod(i,100)
        etime=toc;
        progress=(i/file_length);
        if ~waitmode
            esecs=mod(etime, 60);
            emins=mod(etime-esecs,3600)/60;
            ehours=etime-esecs-emins*60;
            waitbar(progress, wbh, [num2str(100*progress) '% done in '...
                num2str(ehours) ' hours, ' num2str(emins) ' minutes, and ' num2str(esecs) ' seconds']);
        elseif etime-lasttime>30
            disp([num2str(100*progress) '% done in ' num2str(etime) ' seconds'])
            lasttime=etime;
        elseif (waitmode==-1&&etime>=1)
            if progress<0.0032
                waitmode=0;
                %set up progress bar if wait length is long enough
                wbh=waitbar(0, '0% done');
                set(wbh, 'name', ['seagridsave saving data to ' outfile '...']);
                waitbar(progress, wbh, [num2str(100*progress)...
                    '% done']);
            else
                waitmode=1;
            end
        end
    end
    a_line=fgetl(infid);
end
if waitmode==0
    close(wbh);
end
fclose(infid);
fclose(ofid);
end