basepath='/data/phil/searise/vario/';
vernum='/v2/';
clear folders;
%folders={'jakvario', 'helvario', 'kangvario', 'petvario'};
folders={'jakvario'};
degopts={'0', '45', '90', '135', 'tot'};
plot_max=1;
plot_num=0;
figure
set(gcf, 'position', [360 135 560 782]);
for cur_fold=folders
    for cur_deg=degopts
        if plot_num==plot_max
            plot_num=1;
            print(['/home/chenpa/documents/plots/greenland/varioplots/' filename 'plot.jpg'], '-djpeg');
            figure
            set(gcf, 'position', [360 135 560 782]);
        else
            plot_num=plot_num+1;
        end
        fullname=[basepath cur_fold{1} vernum cur_fold{1}(1) 'vario' cur_deg{1} '.dat'];
        fid=fopen(fullname);
        data=textscan(fid, '%d %f %f %f %f %f %d\n');
        fclose(fid);
        [~, filename, ~]=fileparts(fullname);
        subplot(plot_max,1,plot_num)
        plot(data{2}, data{4}, '.');
        title([filename ' 200m lag']);
    end
end
print(['/home/chenpa/documents/plots/greenland/varioplots/' filename 'plot.jpg'], '-djpeg');
% %fullname='/data/phil/searise/vario/jakvario/jvariotot.dat';
% %fullname='/data/phil/searise/vario/helvario/hvariotot.dat';
% bounds=[0 100000 0 1200000];
% fullname='/data/phil/searise/vario/jakvario/jvario0.dat';
%fid=fopen(fullname);
%data=textscan(fid, '%d %f %f %f %f %f %d\n');
% [~, filename, ~]=fileparts(fullname);
% subplot(plot_num,1,1)
% plot(data{2}, data{4}, '.');
% title(filename);
% axis(bounds);
% subplot(plot_num,1,2)
% fullname='/data/phil/searise/vario/jakvario/jvario45.dat';
% fclose(fid);
% fid=fopen(fullname);
% data=textscan(fid, '%d %f %f %f %f %f %d\n');
% plot(data{2}, data{4}, '.');
% axis(bounds);
% [~, filename, ~]=fileparts(fullname);
% title(filename);
% figure
% subplot(plot_num,1,1)
% fullname='/data/phil/searise/vario/jakvario/jvario45.dat';
% fclose(fid);
% fid=fopen(fullname);
% data=textscan(fid, '%d %f %f %f %f %f %d\n');
% plot(data{2}, data{4}, '.');
% axis(bounds);
% [~, filename, ~]=fileparts(fullname);
% title(filename);
% subplot(plot_num,1,2)
% fullname='/data/phil/searise/vario/jakvario/jvario90.dat';
% fclose(fid);
% fid=fopen(fullname);
% data=textscan(fid, '%d %f %f %f %f %f %d\n');
% plot(data{2}, data{4}, '.');
% axis(bounds);
% [~, filename, ~]=fileparts(fullname);
% title(filename);
% figure
% subplot(plot_num,1,1)
% fullname='/data/phil/searise/vario/jakvario/jvario135.dat';
% fclose(fid);
% fid=fopen(fullname);
% data=textscan(fid, '%d %f %f %f %f %f %d\n');
% plot(data{2}, data{4}, '.');
% axis(bounds);
% [~, filename, ~]=fileparts(fullname);
% title(filename);
% subplot(plot_num,1,2)
% fullname='/data/phil/searise/vario/jakvario/jvariotot.dat';
% fclose(fid);
% fid=fopen(fullname);
% data=textscan(fid, '%d %f %f %f %f %f %d\n');
% plot(data{2}, data{4}, '.');
% axis(bounds);
% [~, filename, ~]=fileparts(fullname);
% title(filename);
% fclose(fid);
