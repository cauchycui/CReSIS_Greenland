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
%size(filelist,1)
dformat='%f %f %f \n';
for i=1:size(filelist,1)
    figure
%for i=[3 6 8 13 19]
    %axis([308.5000  312.0000   68.4000   70.2000]);
    axis([480000 640000 7580000 7780000]);
    hold on
    color=.8*rand([2 3]);
    fid=fopen(filelist{i,1});
    if fid==0
        error(['file ' filelist{i,1} ' not found'])
    end
    aline=fgetl(fid);
    while (ischar(aline))
        data=sscanf(aline, dformat);
        lat=data(1);
        lon=data(2);
        [x, y]=deg2utm(lat,lon);
        plot(x, y, '.', 'markeredgecolor', color(1, :), 'markerfacecolor', color(2,:))
        aline=fgetl(fid);
    end
    [~, fname]=pathname(filelist{i,1});
    titletxt=[fname ' or track ' num2str(i) ' (UTM)'];
    title(titletxt, 'interpreter', 'none');
    fclose(fid);
    print(gcf, '-djpeg', ['/home/chenpa/documents/plots/greenland/utmtrack' num2str(i) '.jpg']);
    close all
end