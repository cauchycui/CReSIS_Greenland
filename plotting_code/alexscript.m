%clf
%clear all

data=load('/home/yearslwa/code/ULS_2009_07_25_08_03_41.arl');

%colormap(jet)
%l=length(data);

grid on
hold on


scatter(data(:,1),data(:,2),8,data(:,3),'filled')
colorbar
caxis([0 .1])
%plot3(data(:,1),data(:,2),data(:,3))