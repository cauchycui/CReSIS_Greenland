function results=plotdif( filename1, filename2, length )
%Plots the difference of two data sets of format x y z, organizing both
%data sets into squares of length length and then averaging data within
%each box and subtracting filename1's average from filename2's average.
if ischar(filename1)
    fid1=fopen(filename1);
    if fid1==-1
        errormsg=['File ' filename1 ' not found, check argument one.'];
        error(errormsg)     %Exits the program if file is not found.
    else
        data1=textscan(fid1, '%f %f %f', 'CommentStyle', '#');       %reads the text file to a 1x3 cell array (x, y, and z) and ignores lines with # in front
        fclose(fid1);                       %closes the text file
    end
else
    if size(filename1, 2)==3
        data1{1,1}=filename1(:, 1);
        data1{1,2}=filename1(:, 2);
        data1{1,3}=filename1(:, 3);
    else
        error('Not a file or compatible dataset')
    end
end
if ischar(filename2)
fid2=fopen(filename2);
if fid2==-1
    errormsg=['File ' filename2 ' not found, check argument two.'];
    error(errormsg)     %Exits the program if file is not found.
else
    data2=textscan(fid2, '%f %f %f', 'CommentStyle', '#');       %reads the text file to a 1x3 cell array (x, y, and z) and ignores lines with # in front
    fclose(fid2);                       %closes the text file
end
else
    if size(filename2, 2)==3
        data2{1,1}=filename2(:, 1);
        data2{1,2}=filename2(:, 2);
        data2{1,3}=filename2(:, 3);
    else
        error('Not a file or compatible dataset')
    end
end
var1=max(data1{1,1});
var2=max(data2{1,1});
if var1>var2
    xmax=var1;
else
    xmax=var2;
end
var1=min(data1{1,1});
var2=min(data2{1,1});
if var1<var2
    xmin=var1;
else
    xmin=var2;
end
var1=max(data1{1,2});
var2=max(data2{1,2});
if var1>var2
    ymax=var1;
else
    ymax=var2;
end
var1=min(data1{1,2});
var2=min(data2{1,2});
if var1<var2
    ymin=var1;
else
    ymin=var2;
end
ynum=ceil((ymax-ymin)/((xmax-xmin)*length));
xnum=ceil(1/length);
grid1{ynum, xnum}=[];
grid2{ynum, xnum}=[];
results=zeros(ynum, xnum);
length=length*(xmax-xmin);
ymax=(ynum*length)+ymin;
xmax=(xnum*length)+xmin;
%sort data set 1
for i=1:size(data1{1,1})
    x=floor((data1{1,1}(i)-xmin)/length)+1;
    if (x>xnum)
        x=xnum;
    end
    y=floor((data1{1,2}(i)-ymin)/length)+1;
    if(y>ynum)
        y=ynum;
    end
    grid1{y,x}=[grid1{y,x} data1{1,3}(i)];
end
%sort data set 2
for i=1:size(data2{1,1})
    x=floor((data2{1,1}(i)-xmin)/length)+1;
    if (x>xnum)
        x=xnum;
    end
    y=floor((data2{1,2}(i)-ymin)/length)+1;
    if(y>ynum)
        y=ynum;
    end
    grid2{y,x}=[grid2{y,x} data2{1,3}(i)];
end
%average and plot the difference of both data sets
figure;
set(gcf, 'position', [50 50 800 600]);
hold on
plot(data1{1,1}, data1{1,2}, 'g.', 'markersize', 2, 'color', [.1 .6 .2])
plot(data2{1,1}, data2{1,2}, 'm.', 'markersize', 2);
zmin=inf;
zmax=-inf;
for i=1:xnum
    for j=1:ynum
        grid1{j,i}=mean(grid1{j,i});
        grid2{j,i}=mean(grid2{j,i});
        results(j, i)=grid2{j,i}-grid1{j,i};
        if ((~isnan(grid1{j,i}))&&(~isnan(grid2{j,i})))
            if results(j,i)<zmin
                zmin=results(j,i);
            end
            if results(j,i)>zmax
                zmax=results(j,i);
            end
        end            
    end
end
zmax=45;
zmin=-70;
c_map=colormap;
cnum=size(c_map,1);
for i=1:xnum
    for j=1:ynum
        if (~isnan(results(j,i)))
            recpos=[xmin+(i-1)*length ymin+(j-1)*length length length];
            %finds the value between 1 and cnum that the results value
            %corresponds to
            reccol=((cnum-1)*(results(j,i)-zmin)/(zmax-zmin))+1;
            if reccol>cnum
                reccol=cnum;
            elseif reccol<1
                reccol=1;
            end
            %averages the closest integer values with a weighted average to
            %give a smoother color change
            reccol=((reccol-floor(reccol))*c_map(ceil(reccol), :))+ ...
                ((1-reccol+floor(reccol))*c_map(floor(reccol), :));
            rectangle('position', recpos, 'facecolor', reccol, 'edgecolor', [.5 .5 .5]);
        end
    end
end
if isequal([inf, -inf], [zmin zmax])
    display('No overlap found');
else
    colorbar;
    caxis([zmin zmax]);
end
plot([xmin xmax xmax xmin xmin], [ymin ymin ymax ymax ymin], 'k');
for i=1:xnum-1
    x=xmin+length*i;
    plot([x x], [ymin ymax], 'k--');
end
for i=1:ynum-1
    y=ymin+length*i;
    plot([xmin xmax], [y y], 'k--');
end
axis equal;
axis([xmin xmax ymin ymax]);
xlabel('UTM Easting (m)')
ylabel('UTM Northing (m)')
hold off;
end

