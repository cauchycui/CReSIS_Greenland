filename='/data/phil/bering/herzfeldlab/crossoversegs/larsena1.txt.2short';
fid=fopen(filename);
num_points=2000000;
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
for i=1:num_points
    x=sscanf(a_line, '%f');
    distance(i)=sqrt((oldx-x(1))^2+(oldy-x(2))^2)+olddist;
    oldx=x(1);
    oldy=x(2);
    olddist=distance(i);
    data(i)=x(3);
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