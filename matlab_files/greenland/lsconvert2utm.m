dirpath='/data/phil/greenland_GLAS/';
[status, result] = system( ['ls ' dirpath '*.lle']);
if status
    error(['ls error: ' result]);
end
i=0;
clear filelist
a_line=sscanf(result, '%s \n',1);
while size(a_line,2)
    result(1:(size(a_line, 2)+1))=[];
    i=i+1;
    filelist{i,1}=a_line;
    a_line=sscanf(result, '%s \n',1);
end
for i=1:size(filelist,1)
    [fpath fname]=pathname(filelist{i});
    lonlatz2xyz(filelist{i}, [fpath 'utm_elev/' fname '.utm']);
end
