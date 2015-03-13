%function [ output_args ] = find( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
boxdir='/data/phil/searise/cresisboxes/test/';
fid=fopen([boxdir 'limits.txt'], 'r');
if fid<=0
    error('No limit file found')
end
blimits=sscanf(fgetl(fid), '%d');
fclose(fid);
for i=blimits(1):blimits(1)
    for j=blimits(3):blimits(4)        
        [status, result] = system(['wc -l ' boxdir 'Area' num2str(i) ',' num2str(j) '*']);
        if status==0
            result
            i
            j
            break;
        end
    end
end
%end

