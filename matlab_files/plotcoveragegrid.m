%function [ cov_grid blimits ] = plotcoveragegrid( boxdir )
%MAKECOVERAGEGRID Summary of this function goes here
%   Detailed explanation goes here
boxdir='/data/phil/searise/cresisboxes/try1/';
[status, result] = system( ['wc -l ' boxdir 'limits.txt']);
if (status)
    error(['wc error: ' result])
end
fid=fopen([boxdir 'limits.txt'], 'r');
if fid<=0
    error('No limit file found')
end
blimits=sscanf(fgetl(fid), '%d');
if (str2double(result(1)))
    lmax=sscanf(fgetl(fid), '%d');
else
    lmax=findlmax(boxdir, 'Area*.txt');
    fclose(fid);
    fid=fopen([boxdir 'limits.txt'], 'a+');
    fprintf(fid, '\n%d', lmax);
end
 fclose(fid);
%start plotting coverage
[status, result] = system( ['ls ' dirname]);
if (status)
    error(['ls error: ' result])
end
fh=figure;
mcm=customcolormap(lmax,[.8 .1 .1; 0 .4 .2]);
colormap(mcm)
colorbar('ylim', [0 lmax]);
begind=strfind(result, 'Area');
endind=strfind(result, '.txt');
wbh=waitbar(0, '0% done');
set(wbh, 'name', 'plotting data coverage...');
prog_etime=tic;
for i=1:size(begind,2)
    namestart=begind(i);
    nameend=endind(find(endind>namestart,1))+3;
    if nameend<begind(i+1)
        [status, fcount] = system( ['wc -l ' boxdir result(namestart:nameend)]);
        if (status)
            error(['wc error: ' result])
        end
        coords=sscanf(result(namestart:nameend), 'Area%d,%d.txt');
        coords=coords*100;
        figure(fh);
        rectangle('Position', [coords(1) coords(2) 100 100], 'facecolor',...
            mcm(str2double(fcount(1))+1,:))
    end
    if ~mod(i,100)
        progress=(i/size(begind,2));
        etime=toc(prog_etime);
        if etime>=60
            etime=etime/60;
            tunit=' minutes';
        elseif etime>=3600
            etime=etime/3600;
            tunit=' hours';
        else
            tunit=' seconds';
        end
        waitbar(progress, wbh, [num2str(100*progress) '% done in ' etime tunit]);
    end
end
close(wbh)