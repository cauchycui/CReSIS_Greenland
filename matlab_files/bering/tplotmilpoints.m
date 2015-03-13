filename='/data/phil/bering/larsen/xab.clean';
fid=fopen(filename);
num_points=1000000;
data=zeros(num_points, 1);
meandata=zeros(floor(num_points/100), 1);
distance=zeros(num_points,1);

%  for i=1:1000000
%      a_line=fgetl(fid);
%  end
a_line=fgetl(fid);
x=sscanf(a_line, '%f');
oldx=x(1);
oldy=x(2);
olddist=0;
tic;
for i=1:floor(num_points/100)
    x=sscanf(a_line, '%f');
    meandata(i)=x(3);
    distance(i)=sqrt((oldx-x(1))^2+(oldy-x(2))^2)+olddist;
    oldx=x(1);
    oldy=x(2);
    olddist=distance(i);
    a_line=fgetl(fid);  
end
avg=mean(meandata);
count=1;
for i=1:floor(num_points/100)
    if (meandata(count)>avg/2)
        data(count)=meandata(count);
        count=count+1;
    else
        data(count)=[];
        distance(count)=[];
    end
end
for i=floor(num_points/100):num_points
    x=sscanf(a_line, '%f');
    distance(count)=sqrt((oldx-x(1))^2+(oldy-x(2))^2)+olddist;
    oldx=x(1);
    oldy=x(2);
    olddist=distance(count);
    if (x(3)>avg/2)
        data(count)=x(3);
        count=count+1;
    else
        data(count)=[];
        distance(count)=[];
    end
    a_line=fgetl(fid);
    if mod(i,num_points/10)==0
        etime=toc;
        perc=100*i/num_points;
        disp(['i=' num2str(i) '(' num2str(perc) '% in ' num2str(etime) ' seconds)'])
    end
    if (~ischar(a_line))
        disp(['end of file reached at ' num2str(i)])
        break
    end
end
figure;
plot(distance, data, 'b.');
title(filename);
fclose(fid);