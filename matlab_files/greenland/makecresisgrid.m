years=1993:2014;
outputfile='/Users/harrycui/data/searise/all_cresis_griddata.txt';
%a place to save intermediate files
intermediatedir='/Users/harrycui/data/searise/';
%a prefix for intermediate files
pstprefix='cresisdata';
dataloc='/Users/harrycui/cresisportal/';
%% Actual Code
%TODO: make script a function, add parameter to skip copying cresis data if
%applicable


[status, result]=system(['ls ' dataloc]); 
if status
    error(['error--' result]);
end
% if isequal(result, '')
%     [status result]=system(['curlftpfs data.cresis.ku.edu/data/rds/ ' dataloc]);
%     if status
%         error(['curlftpfs error: ' result]);
%     end
% end
printcresisyearkml(years, [intermediatedir pstprefix], 1, dataloc);
[~, ~]=system(['rm ' intermediatedir 'cresissort.tmp']);
xmax =-inf;
xmin =inf;
ymax =-inf;  
ymin =inf;
for year=years
    if strcmp(num2str(year),'1994') || strcmp(num2str(year),'2000') || strcmp(num2str(year),'2004')
            continue
        end
       
    filenames=ls2strlist([intermediatedir pstprefix num2str(year) '*.pst']);
%    celldisp(filenames);
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

if exist([intermediatedir 'cresissort.tmp'], 'file')
fsortseadata([intermediatedir 'cresissort.tmp']);
%avgsortedgriddata([intermediatedir 'cresissort.tmp'], [outputfile '.ydat'])
minsortedgriddata([intermediatedir 'cresissort.tmp'], [outputfile '.ydat'])
mawkstr='mawk ''{print $1, $2, $3}'' ';
[~,~]=system(['rm ' outputfile]);
[status, result]=system([mawkstr outputfile '.ydat>>' outputfile]);
if status
    disp(['mawk error: ' result])
end
else
    disp('No data found in CRESIS database for that time range');
end