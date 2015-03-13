function [ cov_grid blimits ] = makecoveragegrid( boxdir )
%MAKECOVERAGEGRID Summary of this function goes here
%   Detailed explanation goes here
%boxdir='/data/phil/searise/cresisboxes/try1/';
fid=fopen([boxdir 'limits.txt'], 'r');
if fid<=0
    error('No limit file found')
end
blimits=sscanf(fgetl(fid), '%d');
fclose(fid);
cov_grid=zeros(blimits(4)-blimits(3)+1, blimits(2)-blimits(1)+1);
yoffset=1-blimits(3);
xoffset=1-blimits(1);
for i=blimits(1):blimits(1)
    for j=blimits(3):blimits(4)        
        [status, result] = system(['wc -l ' boxdir 'Area' num2str(i) ',' num2str(j) '*']);
        if status==0
            cov_grid(j+yoffset,i+xoffset)=str2num(result(1))+1;
        end
    end
end
end

