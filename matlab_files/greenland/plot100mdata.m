%load the data
demdir='/data/phil/searise/krig/DEMs/';
fnbase='greenland_13_prelim_v3';
clear cmpbase;
%cmpbase='greenland_13_prelim_v2';
%fid=fopen([demdir fnbase '.dtm']);
fid=fopen('/data/phil/searise/all_cresis_griddata.txt');
%fid=fopen('/data/phil/searise/vario/jaksub.text');
%data=textscan(fid, '%f %f %f %f %f\n');
data=textscan(fid, '%f %f %f\n');
%x=min(data{1}):5000:max(data{1});
%y=max(data{2}):-5000:min(data{2});
% z=reshape(data{3}, length(x), length(y));
% z=z';
x=data{1};
y=data{2};
z=data{3};
if exist('cmpbase', 'var')
fid2=fopen([demdir cmpbase '.dtm']);
data2=textscan(fid2, '%f %f %f %f %f\n');
x2=min(data2{1}):5000:max(data2{1});
y2=max(data2{2}):-5000:min(data2{2});
z2=reshape(data2{3}, length(x2), length(y2));
z2=z2';
end
%plot a countour map
% fh=figure;
% set(fh, 'position', [33 78 700 820])
% contour(x, y, z);
% axis image;
% th=title(fnbase);
% set(th, 'interpreter', 'none');
% ah=gca;
% set(ah, 'xgrid', 'on', 'ygrid', 'on')
% colorbar
% hold on
% text(-460000, -2300000, 'jak')
%make a pretty figure
figure
set(gcf, 'position', [744 201 541 645])
ubound=median(data{3});
for ii=1:4
    ubound=median(data{3}(data{3}>ubound));
end
xlims=[x(1) x(length(x))];
ylims=[y(length(y)) y(1)];
if exist('cmpbase','var')
    imagesc(x,y, z-z2)
    th=title([fnbase '-' cmpbase]);
else
    imagesc(x,y,z)
    th=title(fnbase);
    [~, cmax]=caxis;
    caxis([0, cmax]);
    mycolormap=colormap;
    mycolormap(1,:)=0;
    colormap(mycolormap);
end
set(gca, 'ydir', 'normal')
set(th, 'interpreter', 'none');
colorbar
%plot the cresis tracks
hold on
cresisdata=ls2strlist('/data/phil/searise/cresisdata*.pst');
for ii=1:length(cresisdata)
    fid=fopen(cresisdata{ii},'r');
    data=textscan(fid, '%f %f %f\n');
    plot(data{1},data{2},'k.', 'markersize', 1)
    fclose(fid);
end
%plot the glacier boundaries
jbnd=[-460000 -340000 -2300000 -2200000];
text(jbnd(2),jbnd(4), 'jak')
xbox=[jbnd(1) jbnd(2) jbnd(2) jbnd(1) jbnd(1)];
ybox=[jbnd(3) jbnd(3) jbnd(4) jbnd(4) jbnd(3)];
plot(xbox, ybox);
hbnd=[-5000 45000 -2590000 -2530000];
text(hbnd(2),hbnd(4), 'hel')
xbox=[hbnd(1) hbnd(2) hbnd(2) hbnd(1) hbnd(1)];
ybox=[hbnd(3) hbnd(3) hbnd(4) hbnd(4) hbnd(3)];
plot(xbox, ybox);
kbnd=[220000 255000 -2310000 -2260000];
text(kbnd(2),kbnd(4), 'kang')
xbox=[kbnd(1) kbnd(2) kbnd(2) kbnd(1) kbnd(1)];
ybox=[kbnd(3) kbnd(3) kbnd(4) kbnd(4) kbnd(3)];
plot(xbox, ybox);
pbnd=[-395000 -330000 -1040000 -880000];
text(pbnd(2),pbnd(4), 'pet')
xbox=[pbnd(1) pbnd(2) pbnd(2) pbnd(1) pbnd(1)];
ybox=[pbnd(3) pbnd(3) pbnd(4) pbnd(4) pbnd(3)];
plot(xbox, ybox);
%make subsections
jsinds=find((data{1}>jbnd(1)).*(data{1}<jbnd(2)).*(data{2}>jbnd(3)).*(data{2}<jbnd(4)));
jsub=[data{1}(jsinds) data{2}(jsinds) data{3}(jsinds)];
fid=fopen('/home/chenpa/variogram/jaksub.text', 'w');
for ii=1:length(jsinds)
    fprintf(fid, '%d %d %f\n', jsub(ii,1), jsub(ii,2), jsub(ii,3));
end
fclose(fid);
hsinds=find((data{1}>hbnd(1)).*(data{1}<hbnd(2)).*(data{2}>hbnd(3)).*(data{2}<hbnd(4)));
hsub=[data{1}(hsinds) data{2}(hsinds) data{3}(hsinds)];
fid=fopen('/data/phil/searise/vario/helsub.text', 'w');
for ii=1:length(hsinds)
    fprintf(fid, '%d %d %f\n', hsub(ii,1), hsub(ii,2), hsub(ii,3));
end
fclose(fid);

ksinds=find((data{1}>kbnd(1)).*(data{1}<kbnd(2)).*(data{2}>kbnd(3)).*(data{2}<kbnd(4)));
ksub=[data{1}(ksinds) data{2}(ksinds) data{3}(ksinds)];
fid=fopen('/data/phil/searise/vario/kangsub.text', 'w');
for ii=1:length(ksinds)
    fprintf(fid, '%d %d %f\n', ksub(ii,1), ksub(ii,2), ksub(ii,3));
end
fclose(fid);

psinds=find((data{1}>pbnd(1)).*(data{1}<pbnd(2)).*(data{2}>pbnd(3)).*(data{2}<pbnd(4)));
psub=[data{1}(psinds) data{2}(psinds) data{3}(psinds)];
fid=fopen('/data/phil/searise/vario/petsub.text', 'w');
for ii=1:length(psinds)
    fprintf(fid, '%d %d %f\n', psub(ii,1), psub(ii,2), psub(ii,3));
end
fclose(fid);