function fsortseadata( filename, varargin )
%FSORTSEADATA Sorts data created by seagridsave.m
%uses matlab's sort function to sort data
%filename='/data/phil/searise/cresisboxes/monstertry.txt';
%file_length=wc(filename);
ifid=fopen(filename);
if ifid<0
    error('Input file not found');
end
try 
    data=textscan(ifid, '%f %f %f %f');
catch scanerror
    disp(scanerror.message)
end
data=[data{1} data{2} data{3} data{4}];
data=sortrows(data, [1 2 4 3]);
fclose(ifid);
data=data';
%overwrite the old file with the new sorted file
data=reshape(data, 4*size(data,2), 1);
fid=fopen(filename, 'w+');
fprintf(fid, '%d %d %f %d\n', data);
fclose(fid);
end    
    
% [status, result] = system( ['cp ' filename '.tmp ' filename]);
% if (status)
%     error(['cp error: ' result])
% end
% [status, result] = system( ['rm ' filename '.tmp']);
% if (status)
%     error(['rm error: ' result])
% end
%end