function PlotOffsetRoughness(filename, varargin)
%PlotOffsetRoughness returns the number of tracks in the pond data set and
%plots a graph of the satellite tracks along with roughness values offset
%perpendicularly from the tracks. The function has up to nine optional
%inputs: starttrack, endtrack, roughness value processing ('values',
%'sqrt', or 'log'), title ('default' maintains default titling), xmin,
%xmax, ymin, ymax.

fid=fopen(filename);                %opens the text file to file identification fid
data=textscan(fid, '%f%f%f', 'CommentStyle', '#');       %reads the text file to a 1x3 cell array (x, y, and z) and ignores lines with # in front
fclose(fid);                        %closes the text file
DataSize=size(data{1,1},1);       %records the number of x entries and assumes the number of total entries are the same
PathMatrix=zeros(DataSize,2);      %creates an nx2 matrix where n is the number of data points
PathMatrix(:,1)=data{1,1};              %inputs the x data into the matrix
PathMatrix(:,2)=data{1,2};              %inputs the y data into the matrix
roughness=data{1,3};
%SlopeMatrix is the matrix with all the slopes of the tracks
SlopeMatrix=zeros(DataSize,3);
%The first element of SlopeMatrix is created seperately to have a reference
%to check further slopes against for the purpose of finding discontinuities
SlopeMatrix(1,1)=(PathMatrix(2,2)-PathMatrix(1,2))/(PathMatrix(2,1)-PathMatrix(1,1));
Breakpoints=1;			%Breakpoints keeps track of the number of discontinuities and counts the first point as a discontinuity
Jumppoints=1;
pathdistanceold=sqrt(((PathMatrix(2,2)-PathMatrix(1,2))^2)+(PathMatrix(2,1)-PathMatrix(1,1))^2);    %The distance between the first two points
%Here elements of SlopeMatrix are created by dividing the change in y by the change in x
for n=2:DataSize
    SlopeMatrix(n,1)=(PathMatrix(n,2)-PathMatrix(n-1,2))/(PathMatrix(n,1)-PathMatrix(n-1,1));
    pathdistance=sqrt(((PathMatrix(n,2)-PathMatrix(n-1,2))^2)+(PathMatrix(n,1)-PathMatrix(n-1,1))^2);
    %If the slope changes by more than 20%, it notes the number of breakpoints has increased and it notes there is a discontinuity within SlopeMatrix's second column with a 1
    if abs((SlopeMatrix(n,1)-SlopeMatrix(n-1,1))/(SlopeMatrix(n,1)))>.2
        Breakpoints=Breakpoints+1;
        SlopeMatrix(n,1)=(PathMatrix(n+1,2)-PathMatrix(n,2))/(PathMatrix(n+1,1)-PathMatrix(n,1));
        SlopeMatrix(n,2)=1;        
    end
    %If the distance between two points is more than twice that of the
    %previous distance, a jump is noted in SlopeMatrix and the number of
    %Jumppoints increases
    if abs(pathdistance-pathdistanceold)/pathdistanceold>1
        Jumppoints=Jumppoints+1;
        SlopeMatrix(n,3)=1;
    end
    pathdistanceold=pathdistance;
end
%Creates the BreakArray which is a vector with all the row numbers of discontinuities including row 1 and the last row
BreakArray=zeros(Breakpoints+1,1);      %The +1 is to add room to count the very last datapoint as a breakpoint
BreakArray(1)=1;
BreakArray(Breakpoints+1)=DataSize;
JumpMatrix=zeros(Jumppoints,2);        %If the very first or last data point is a jumppoint, this could be a problem
JumpMatrix(1,2)=1;
BreakPlace=0;		%This keeps track of the row within the for loop
BreakNumber=1;		%This keeps track of the number of slope discontinuities logged
JumpNumber=1;      %This keeps track of the number of position discontinuities logged    
for n=1:DataSize
    BreakPlace=BreakPlace+1;
    if SlopeMatrix(n,3)==1
        JumpNumber=JumpNumber+1;
        JumpMatrix(JumpNumber,1)=BreakPlace;
        
        if SlopeMatrix(n,2)==1
            BreakNumber=BreakNumber+1;
            BreakArray(BreakNumber)=BreakPlace;
            JumpMatrix(JumpNumber,2)=BreakNumber;
        end
        
    end
    
end
%The OffsetArray keeps track of the ratio the y coordinates need to be offset compared to the x coordinates. I.E. y offset = (x offset)*OffsetArray
OffsetArray=zeros(DataSize,1);
%Uses trigonometry to find the ratio; see Day 3 notes for a diagram
for n=1:DataSize
    OffsetArray(n)=tan((pi/2)-atan(SlopeMatrix(n,1)));
end
optinputs={1, Breakpoints, 'values', 1, 'default', 0, 0, 0, 0};
inputnumber=size(varargin,2);
for n=1:inputnumber
    optinputs{1,n}=varargin{1,n};
end
%OffsetMatrix keeps track of the x and y displacements from the path
OffsetMatrix=zeros(size(PathMatrix));
%OffsetMatrix x values are equal to roughness values; attempts to normalize data should be made here
if size(varargin,2)==1
    starttrack=1;
    endtrack=varargin{1,1};
else
    starttrack=optinputs{1,1};
    endtrack=optinputs{1,2};
end
if strcmp(optinputs{1,3},'values')    
    OffsetMatrix(:,1)=roughness;
elseif strcmp(optinputs{1,3}, 'sqrt')
    OffsetMatrix(:,1)=100*sqrt(roughness);
elseif strcmp(optinputs{1,3}, 'log')
    minimum=min(log2(roughness(BreakArray(starttrack):BreakArray(endtrack))));
    OffsetMatrix(:,1)=400*(log2(roughness)-minimum);
end
for n=1:DataSize
    OffsetMatrix(n,2)=OffsetMatrix(n,1)*-1*OffsetArray(n);
end
%clears the current figure (if there is one) and then prevents figures from
%overwriting eachother
figure('Position', [1 512 640 512]);
cla
hold on
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
        if optinputs{1,4}>1
            MirrorMatrix(n,1)=PathMatrix(n-1+BreakArray(m-1),1)-OffsetMatrix(n-1+BreakArray(m-1),1);
            MirrorMatrix(n,2)=PathMatrix(n-1+BreakArray(m-1),2)-OffsetMatrix(n-1+BreakArray(m-1),2);
        end
    end
    if optinputs{1,4}>1
        plot(MirrorMatrix(:,1), MirrorMatrix(:,2),'r')
    end
    plot(PlotMatrix2(:,1), PlotMatrix2(:,2),'r');
    plot(PlotMatrix1(:,1), PlotMatrix1(:,2),'b');
    
end
JumpEnd=0;
for n=1:Jumppoints
    if JumpMatrix(n,2)==starttrack
        JumpStart=n;
    end
    if JumpMatrix(n,2)==endtrack+1
        JumpEnd=n;
    end
end
if JumpEnd==0
    JumpEnd=Jumppoints;
end
for n=JumpStart:JumpEnd
    index=JumpMatrix(n,1);
    if JumpMatrix(n,2)==0
        line([PathMatrix(index-1,1)+OffsetMatrix(index-1,1)...
         PathMatrix(index,1) + OffsetMatrix(index,1)],...
        [PathMatrix(index-1,2)+OffsetMatrix(index-1,2)...
         PathMatrix(index,2) + OffsetMatrix(index,2)],...
        'color', [0 1 0])
        line([PathMatrix(index-1,1)+OffsetMatrix(index-1,1)...
         PathMatrix(index-1,1) + OffsetMatrix(index-1,1)],...
        [PathMatrix(index-1,2)+OffsetMatrix(index-1,2)...
         PathMatrix(index-1,2) + OffsetMatrix(index-1,2)],...
        'color', [1 0 0])
        line([PathMatrix(index,1)+OffsetMatrix(index,1)...
         PathMatrix(index,1) + OffsetMatrix(index,1)],...
        [PathMatrix(index,2)+OffsetMatrix(index,2)...
         PathMatrix(index,2) + OffsetMatrix(index,2)],...
        'color', [1 0 0])
    end
end
%plot(TestMatrix(:,1), TestMatrix(:,2), 'g.')
%Allows new figures to overwrite the current figure again, and fixes the
%aspect ratio to be equal distances for x and y
hold off
axis equal
if optinputs{1,6}~=0 && optinputs{1,7}~=0 && optinputs{1,8}~=0 && optinputs{1, 9}~=0
   axis([optinputs{1,6},optinputs{1,7}, optinputs{1,8}, optinputs{1,9}])
elseif optinputs{1,6}~=0 || optinputs{1,7}~=0 || optinputs {1,8}~=0 || optinputs {1,9}~=0
    display('Not enough axis boundaries given, default values used.')
end
words=[filename, '      ', date, '      ', optinputs{1,3}];
%words=strcat(filename, details)
variable_label = xlabel({'UTM East(m)', words});
ylabel('UTM North(m)');
set(variable_label, 'interpreter', 'none')
if strcmp(optinputs{1,5}, 'default')
    GraphTitle=strcat('Jakobshavn Isbrae 20', filename(7:8), ' GLAS Data pond');
    if starttrack~=endtrack
        tracks=['track ', num2str(starttrack), ' through track ', num2str(endtrack)];
    else
        tracks=['track ', num2str(starttrack)];
    end
    title({GraphTitle; tracks});
else
    title(optinputs{1,5})
end
disp([num2str(Breakpoints), ' track(s) detected'])
end


