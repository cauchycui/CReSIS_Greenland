% 
dirname='/data/phil/greenland_GLAS/utm_elev/';
file1=[dirname 'GLA06_06022220_r8251_633_L3E.P6663_01_00.txt.lle.utm'];
file2=[dirname 'GLA06_05021720_r8251_633_L3B.P6663_01_00.txt.lle.utm'];
%file3=[dirname 'GLA06_06022220_r8251_633_L3E.P6663_01_00.txt.lle.utm.lin'];
file3=[dirname 'GLA06_05021720_r8251_633_L3B.P6663_01_00.txt.lle.utm.lin'];
%results=crossfind(file1, file2, .01);
%extractlines(file1, results{1});
%extractlines(file2, results{2});
filename1=file1;
filename2=file2;
fid1=fopen(filename1);
aline=fgetl(fid1);
dformat='%f %f %f';
figure;
hold on;
while (ischar(aline))
    data=sscanf(aline, dformat);
    plot(data(1), data(2), 'bx');
    aline=fgetl(fid1);
end
fclose(fid1);
fid2=fopen(filename2);
aline=fgetl(fid2);
while (ischar(aline))
    data=sscanf(aline, dformat);
    plot(data(1), data(2), 'ro');
    aline=fgetl(fid2);
end
fclose(fid2);
% fid3=fopen(file3);
% aline=fgetl(fid3);
% while (ischar(aline))
%     data=sscanf(aline, dformat);
%     plot(data(1), data(2), 'g.');
%     aline=fgetl(fid3);
% end
% fclose(fid3);
% plot(x1,y1, 'go')
% plot(x1, y1+200, 'g.')
% plot(x1, y1-200, 'g.')