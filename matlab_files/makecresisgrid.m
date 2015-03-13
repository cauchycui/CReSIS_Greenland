years=1990:2013;
outputfile='/data/phil/searise/all_cresis_griddata.txt';
intermediatedir='/data/phil/searise/';
pstprefix='cresisdata';
dataloc='/home/chenpa/cresisportal/';
[status, result]=system(['ls ' dataloc]);
if status
    error(['error--' result]);
end
if isequal(result, '')
    [status result]=system('curlftpfs data.cresis.ku.edu/data/rds/ /home/chenpa/cresisportal');
    if status
        error(['curlftpfs error: ' result]);
    end
end
printcresisyearkml(years, [intermediatedir pstprefix]);
system(['rm ' intermediatedir 'cresissort.tmp']);
xmax=-inf;
xmin=inf;
ymax=-inf;
ymin=inf;
for year=years
    filenames=ls2strlist([intermediatedir 'cresisdata' num2str(year) '*.pst']);
    if iscell(filenames)
        for m=1:length(filenames)
            [tmpxmin tmpxmax tmpymin tmpymax] = seagridsave(filenames{m}, year, [intermediatedir 'cresissort.tmp']);
            if tmpxmin<xmin
                xmin=tmpxmin;
            end
            if tmpxmax>xmax
                xmax=tmpxmax;
            end
            if tmpymin<ymin
                ymin=tmpymin;
            end
            if tmpymax>ymax
                ymax=tmpymax;
            end
        end
    end
end
fsortseadata([intermediatedir 'cresissort.tmp']);
avgsortedgriddata([intermediatedir 'cresissort.tmp'], outputfile)
reformatfile(outputfile, '%d %d %f %d %d', '%d %d %d', [outputfile '.xyz']); 