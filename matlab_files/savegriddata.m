% filename='/data/phil/searise/cresisdata2012.utm';
% infid=fopen(filename, 'r');
% a_line=fgetl(infid);
% data=zeros(wc(filename),3);
% i=1;
% while ischar(a_line)
%     data(i, :)=sscanf(a_line, '%f', 3);
%     a_line=fgetl(fid);
%     i=i+1;
% end
% fclose(fid);
% clear quad1
% clear quad2
% clear quad3
% clear quad4
% [quad1, quad2, quad3, quad4]=seagridsort(data);
seagridsavesort('/data/phil/searise/cresisdata2012.utm','/data/phil/searise/cresisboxes/2012/')