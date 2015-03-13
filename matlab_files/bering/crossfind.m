function results  = crossfind( filename1, filename2 )
%crossfind Find lines in two xyz files where data roughly overlaps
if ischar(filename1)
    fid1=fopen(filename1);
    if fid1==-1
        errormsg=['File ' filename1 ' not found, check argument one.'];
        error(errormsg)     %Exits the program if file is not found.
    else
        data1=textscan(fid1, '%f %f %f', 'CommentStyle', '#');       %reads the text file to a 1x3 cell array (x, y, and z) and ignores lines with # in front
        fclose(fid1);                       %closes the text file
    end
elseif size(filename1,2)==3
    data1{1,1}=filename1(:, 1);
    data1{1,2}=filename1(:, 2);
    data1{1,3}=filename1(:, 3);
else
    error('Not a file or compatible dataset')
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
elseif size(filename2,2)==3
    data2{1,1}=filename2(:, 1);
    data2{1,2}=filename2(:, 2);
    data2{1,3}=filename2(:, 3);
else
    error('Not a file or compatible dataset')
end

%find the smaller xmax
var1=max(data1{1});
var2=max(data2{1});
if var1>var2
    xmax=var2;
else
    xmax=var1;
end
%find the larger xmin
var1=min(data1{1});
var2=min(data2{1});
if var1<var2
    xmin=var2;
else
    xmin=var1;
end
%find the smaller ymax
var1=max(data1{2});
var2=max(data2{2});
if var1>var2
    ymax=var2;
else
    ymax=var1;
end
%find the larger ymin
var1=min(data1{2});
var2=min(data2{2});
if var1<var2
    ymin=var2;
else
    ymin=var1;
end
ynum=ceil((ymax-ymin)/((xmax-xmin)*.05));
xnum=20;
grid1{ynum, xnum}=[];
grid2{ynum, xnum}=[];
length=.05*(xmax-xmin);
%sort data set 1
for i=1:size(data1{1,1})
    if ((data1{1,1}(i)<=xmax)&&(data1{1,1}(i)>=xmin)&& ...
            (data1{1,2}(i)>=ymin)&&(data1{1,2}(i)<=ymax))
        x=floor((data1{1,1}(i)-xmin)/length)+1;
        if (x>xnum)
            x=xnum;
        end
        y=floor((data1{1,2}(i)-ymin)/length)+1;
        if(y>ynum)
            y=ynum;
        end
        grid1{y,x}=[grid1{y,x} i];
    end
end

%sort data set 2
for i=1:size(data2{1,1})
    if ((data2{1,1}(i)<=xmax)&&(data2{1,1}(i)>=xmin)&& ...
            (data2{1,2}(i)>=ymin)&&(data2{1,2}(i)<=ymax))
        x=floor((data2{1,1}(i)-xmin)/length)+1;
        if (x>xnum)
            x=xnum;
        end
        y=floor((data2{1,2}(i)-ymin)/length)+1;
        if(y>ynum)
            y=ynum;
        end
        grid2{y,x}=[grid2{y,x} i];
    end
end
result1=[0 0];
r_num1=0;
result2=[0 0];
r_num2=0;
for i=1:xnum
    for j=1:ynum
        if (size(grid1{j,i},2))&&(size(grid2{j,i},2))
            grid1{j,i}=sort(grid1{j,i});
            grid2{j,i}=sort(grid2{j,i});
            r_num1=r_num1+1;
            result1(r_num1, 1)=grid1{j,i}(1);
            lastline1=grid1{j,i}(1);
            for k=2:size(grid1{j,i},2)
                if (grid1{j,i}(k)~=(lastline1+1)) 
                    result1(r_num1,2)=lastline1;
                    r_num1=r_num1+1;
                    result1(r_num1, 1)=grid1{j,i}(k);
                end
                lastline1=grid1{j,i}(k);
            end
            if (result1(r_num1,2)==0)
                result1(r_num1, 2)=lastline1;
            end
            r_num2=r_num2+1;
            result2(r_num2, 1)=grid2{j,i}(1);
            lastline2=grid2{j,i}(1);
            for k=2:size(grid2{j,i},2)
                if (grid2{j,i}(k)~=(lastline2+1)) 
                    result2(r_num2,2)=lastline2;
                    r_num2=r_num2+1;
                    result2(r_num2, 1)=grid2{j,i}(k);
                end
                lastline2=grid2{j,i}(k);
            end
            if (result2(r_num2, 2)==0)
                result2(r_num2, 2)=lastline2;
            end
        end
    end
end
results={result1 result2};
end

