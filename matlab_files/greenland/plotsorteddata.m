function plotsorteddata(textfile)
%fid=fopen('/data/phil/searise/cresisboxes/cresissort.tmp.avg');
fid=fopen(textfile, 'r');
if fid==-1
    error('File not found');
end
data=textscan(fid, '%d %d %f %d %s\n');
maxnum=max(data{4});
cur_colormap=colormap;
hold on
for m=1:maxnum
    indices=find(data{4}>=m);
    c_index=1+(m-1)*size(cur_colormap,1)/maxnum;
    rgbvals=cur_colormap(floor(c_index),:)*double(floor(c_index)+1-c_index)+cur_colormap(floor(c_index)+1,:)*double(c_index-floor(c_index));
    plot(100*data{1}(indices)+50,100*data{2}(indices)+50, '.', 'markeredgecolor', rgbvals);
end
colorbar;
caxis([1 maxnum]);
end