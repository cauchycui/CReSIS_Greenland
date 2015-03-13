function [Breakpoints] = PlotOffsetElevation(filename, varargin)
tic
fid=fopen(filename);                %opens the text file to file identification fid
data=textscan(fid, '%f%f%f');       %reads the text file to a 1x3 cell array (x, y, and z)
fclose(fid);                        %closes the text file
DataSize=size(data{1,1},1);       %records the number of x entries and assumes the number of total entries are the same
PathMatrix=zeros(DataSize,2);      %creates an nx3 matrix where n is the number of data points
PathMatrix(:,1)=data{1,1};              %inputs the x data into the matrix
PathMatrix(:,2)=data{1,2};              %inputs the y data into the matrix
%SlopeMatrix is the matrix with all the slopes of the tracks
SlopeMatrix=zeros(DataSize,2);
%The first element of SlopeMatrix is created seperately to have a reference to check further slopes against for the purpose of finding discontinuities
SlopeMatrix(1,1)=(PathMatrix(2,2)-PathMatrix(1,2))/(PathMatrix(2,1)-PathMatrix(1,1));
Breakpoints=1;			%Breakpoints keeps track of the number of discontinuities and counts the first point as a discontinuity
%pathdistanceold=sqrt(((PathMatrix(2,2)-PathMatrix(1,2))^2)+(PathMatrix(2,1)-PathMatrix(1,1))^2);
%Here elements of SlopeMatrix are created by dividing the change in y by the change in x
for n=2:DataSize
    SlopeMatrix(n,1)=(PathMatrix(n,2)-PathMatrix(n-1,2))/(PathMatrix(n,1)-PathMatrix(n-1,1));
    %pathdistance=sqrt(((PathMatrix(n,2)-PathMatrix(n-1,2))^2)+(PathMatrix(n,1)-PathMatrix(n-1,1))^2);
    %If the slope changes by more than 20%, it notes the number of breakpoints has increased and it notes there is a discontinuity within SlopeMatrix's second column with a 1
    if abs((SlopeMatrix(n,1)-SlopeMatrix(n-1,1))/(SlopeMatrix(n,1)))>.2%||pathdistance>1000*pathdistanceold
        Breakpoints=Breakpoints+1;
        SlopeMatrix(n,1)=(PathMatrix(n+1,2)-PathMatrix(n,2))/(PathMatrix(n+1,1)-PathMatrix(n,1));
        SlopeMatrix(n,2)=1;        
    end
    %pathdistanceold=pathdistance;
end
%Creates the BreakArray which is a vector with all the row numbers of discontinuities including row 1 and the last row
BreakArray=zeros(Breakpoints+1,1);
BreakArray(1)=1;
BreakArray(Breakpoints+1)=DataSize;
BreakPlace=0;		%This keeps track of the row within the for loop
BreakNumber=1;		%This keeps track of the number of discontinuity positions logged
for n=1:DataSize
    BreakPlace=BreakPlace+1;
    if SlopeMatrix(n,2)==1
        BreakNumber=BreakNumber+1;
        BreakArray(BreakNumber)=BreakPlace;
    end
end
%The OffsetArray keeps track of the ratio the y coordinates need to be offset compared to the x coordinates. I.E. y offset = (x offset)*OffsetArray
OffsetArray=zeros(DataSize,1);
%Uses trigonometry to find the ratio; see Day 3 notes for a diagram
for n=1:DataSize
    OffsetArray(n)=tan((pi/2)-atan(SlopeMatrix(n,1)));
end
%OffsetMatrix keeps track of the x and y displacements from the path
OffsetMatrix=zeros(size(PathMatrix));
%OffsetMatrix x values are equal to roughness values; attempts to normalize data should be made here
OffsetMatrix(:,1)=400*log(data{1,3});
for n=1:DataSize
    OffsetMatrix(n,2)=OffsetMatrix(n,1)*-1*OffsetArray(n);
end
%clears the current figure (if there is one) and then prevents figures from overwriting eachother
cla
hold on
if size(varargin,2)==2
    starttrack=varargin{1,1};
    endtrack=varargin{1,2};
elseif size(varargin,2)==1
    starttrack=1;
    endtrack=varargin{1,1};
else
    starttrack=1;
    endtrack=Breakpoints;
end
%function plots tracks based on user inputted values starttrack and endtrack
for m=starttrack+1:endtrack+1
    %PlotMatrix1 plots the track, while PlotMatrix2 plots the offset values
    %BreakArray is checked against its previous value to find the number of entries of the track
    PlotMatrix1=zeros((BreakArray(m)-BreakArray(m-1)), 2);
    PlotMatrix2=zeros((BreakArray(m)-BreakArray(m-1)), 2);
    MirrorMatrix=zeros(size(PlotMatrix2));
    %Here the entries are entered into the two plot matrices
    for n=1:BreakArray(m)-BreakArray(m-1)
        PlotMatrix1(n,1)=PathMatrix(n-1+BreakArray(m-1),1);
        PlotMatrix1(n,2)=PathMatrix(n-1+BreakArray(m-1),2);
        PlotMatrix2(n,1)=PathMatrix(n-1+BreakArray(m-1),1)+OffsetMatrix(n-1+BreakArray(m-1),1);
        PlotMatrix2(n,2)=PathMatrix(n-1+BreakArray(m-1),2)+OffsetMatrix(n-1+BreakArray(m-1),2);
        MirrorMatrix(n,1)=PathMatrix(n-1+BreakArray(m-1),1)-OffsetMatrix(n-1+BreakArray(m-1),1);
        MirrorMatrix(n,2)=PathMatrix(n-1+BreakArray(m-1),2)-OffsetMatrix(n-1+BreakArray(m-1),2);
    end
    plot(PlotMatrix2(:,1), PlotMatrix2(:,2),'r');
    plot(MirrorMatrix(:,1),MirrorMatrix(:,2), 'r');
    plot(PlotMatrix1(:,1), PlotMatrix1(:,2),'b');
    
end
%Allows new figures to overwrite the current figure again, and lets the figure be zoomed
hold off
zoom on
%PlotMatrix
toc
end


