function STOR(varargin)
%TextOffsetRoughness returns the number of tracks in the pond data set and
%matrices for coordinates of a graph of the satellite tracks along with 
%roughness values offset perpendicularly from the tracks. The function has 
%up to eleven optional inputs: filename, tracks, roughness value processing 
%('values', 'sqrt', or 'log'), title ('default' maintains default titling 
%and 'image' creates a PostScript image and text file with parameters), 
%scale factor, boundaries, offset color, jump color, track color,
%background color.

%% Initialization and Help
%Here the various user inputs are inputted into the cell optinputs and the
%defaults are set by the starting values of optinputs.
optinputs={0, 0, 0, inf, 'default', 'values', [0 0]};
inputnumber=size(varargin,2);
for n=1:inputnumber
    if (iscell(varargin{1,n})==0)
        if (varargin{1,n}~=0)         %inputs of 0 will maintain default
            optinputs{1,n}=varargin{1,n};
        end
    else
        optinputs{1,n}=varargin{1,n};
    end
end

%Rename the input variables to something easier to read
filename=optinputs{1,1};
segments=optinputs{1,2};
orient=optinputs{1,3};
outlier=optinputs{1,4};
usertitle=optinputs{1,5};
graphtype=optinputs{1,6};
boundaries=optinputs{1,7};
%Program checks input arguments for impossible situations
fid=fopen(filename);                                 %opens the text file to file identification fid
if fid==-1
    errormsg=['File ' filename ' not found, check argument one.'];
    error(errormsg)     %Exits the program if file is not found.
else   
    data=textscan(fid, '%f%f%f', 'CommentStyle', '#');       %reads the text file to a 1x3 cell array (x, y, and z) and ignores lines with # in front
    fclose(fid);                       %closes the text file
end
%% Data Processing
DataSize=size(data{1,1},1);
DataMatrix=zeros(DataSize,3);
DataMatrix(:,1)=data{1,1};
DataMatrix(:,2)=data{1,2};
DataMatrix(:,3)=data{1,3};
%remove outliers
outliermin=outlier;
outliercount=0;
for n=1:DataSize
    if DataMatrix(n-outliercount,3)>outliermin
        DataMatrix(n-outliercount, :)=[];
        DataSize=DataSize-1;
        outliercount=outliercount+1;
    end
end
switchcounth=1;
switchcountv=1;
SwitchArrayH=[1; zeros(5, 1)];
SwitchArrayV=[1; zeros(5, 1)];
%initialize moveright and moveup, variables that track whether the data is
%increasing in magnitude
if (DataMatrix(1, 1)<DataMatrix(2, 1))
    moveright=1;
else
    moveright=-1;
end
if (DataMatrix(1,2)<DataMatrix(2,2))
    moveup=1;
else
    moveup=-1;
end
%every time the data switches directions, log it in the SwitchArray
for n=3:DataSize
    if (moveright*(DataMatrix(n, 1)-DataMatrix(n-1, 1))<0)
        switchcounth=switchcounth+1;
        if (switchcounth>size(SwitchArrayH, 1))
            SwitchArrayH=[SwitchArrayH; zeros(5,1)];
        end
        SwitchArrayH(switchcounth)=n;
        moveright=-moveright;
    end
    if (moveup*(DataMatrix(n, 2)-DataMatrix(n-1, 2))<0)
        switchcountv=switchcountv+1;
        if (switchcountv>size(SwitchArrayV, 1))
            SwitchArrayV=[SwitchArrayV; zeros(5,1)];
        end
        SwitchArrayV(switchcountv)=n;
        moveup=-moveup;
    end
end
SwitchArrayH(switchcounth+1)=size(DataMatrix, 1);
SwitchArrayV(switchcountv+1)=size(DataMatrix, 1);
%remove all unneccesarry entries
while (SwitchArrayH(size(SwitchArrayH, 1))==0)
    SwitchArrayH(size(SwitchArrayH, 1))=[];
end
while (SwitchArrayV(size(SwitchArrayV, 1))==0)
    SwitchArrayV(size(SwitchArrayV, 1))=[];
end
%set up and then create the arrays to correlate vertical and horizontal
%segments
H2VArray=zeros(size(SwitchArrayH,1)-1, 1);
V2HArray=zeros(size(SwitchArrayV,1)-1, 1);
vindex=1;
for n=1:size(H2VArray, 1)
    while(SwitchArrayV(vindex)<SwitchArrayH(n))
        V2HArray(vindex)=n-1;
        vindex=vindex+1;
        hindex=n;
    end
    if (SwitchArrayV(vindex)==SwitchArrayH(n))
        H2VArray(n)=vindex;
    else
        H2VArray(n)=vindex-1;
    end
end
while(vindex<=size(V2HArray, 1))
    if(SwitchArrayV(vindex)<SwitchArrayH(hindex))
        V2HArray(vindex)=hindex-1;
        vindex=vindex+1;
    else
        hindex=hindex+1;
    end
end
%reduce switches to only switches with overlapping ranges
%flag entries to be removed with a value of zero
% if(DataMatrix(1,1)<DataMatrix(SwitchArray(2),1))
%     movepos=1;
% else
%     movepos=-1;
% end
% for n=2:(size(SwitchArray,1)-1)
%     if((movepos==1)&&(DataMatrix(SwitchArray(n)-1,1)>DataMatrix(SwitchArray(n+1)-1,1)))
%         SegArray(n)=0;
%     elseif ((movepos==-1)&&(DataMatrix(SwitchArray(n)-1,1)<DataMatrix(SwitchArray(n+1)-1,1)))
%         SegArray(n)=0;
%     end
%     movepos
%     movepos=-movepos;
%     lastsegend=DataMatrix(SwitchArray(n)-1,1)
%     thissegend=DataMatrix(SwitchArray(n+1)-1,1)
% end
% SegArray;
% SwitchArray;
%% Plotting
hpfhandle=figure;
hold on
hphandle=zeros(size(SwitchArrayH,1), 1);
hcolor=rand(size(SwitchArrayH,1), 3)/1.3;
for n=1:size(SwitchArrayH,1)
    if (n==size(SwitchArrayH,1))
        hphandle(n)=plot(DataMatrix(SwitchArrayH(n):size(DataMatrix,1), 1), DataMatrix(SwitchArrayH(n):size(DataMatrix,1), 2), 'Color', hcolor(n, :));
    else
        hphandle(n)=plot(DataMatrix(SwitchArrayH(n):(SwitchArrayH(n+1)-1), 1), DataMatrix(SwitchArrayH(n):(SwitchArrayH(n+1)-1), 2), 'Color', hcolor(n, :));
    end
end
hold off
vpfhandle=figure;
hold on
vphandle=zeros(size(SwitchArrayV,1), 1);
vcolor=rand(size(SwitchArrayV,1), 3)/1.3;
for n=1:size(SwitchArrayV,1)
    if (n==size(SwitchArrayV,1))
        vphandle(n)=plot(DataMatrix(SwitchArrayV(n):size(DataMatrix,1), 1), DataMatrix(SwitchArrayV(n):size(DataMatrix,1), 2), 'Color', vcolor(n, :));
    else
        vphandle(n)=plot(DataMatrix(SwitchArrayV(n):(SwitchArrayV(n+1)-1), 1), DataMatrix(SwitchArrayV(n):(SwitchArrayV(n+1)-1), 2), 'Color', vcolor(n, :));
    end
end
hold off
pdims=axis;
if (size(orient, 2)==1)
    if (segments==0)
        if size(orient,2)==1
            if orient==1
                segments={1:(size(SwitchArrayH,1)-1)};
            elseif orient==2
                segments={1:(size(SwitchArrayV,1)-1)};
            elseif orient==0
                orient=1;
                segments={1:(size(SwitchArrayH,1)-1)};
                i=1;
                while (i<size(segments{1},2))
                    if(H2VArray(i)==H2VArray(i+1))
                        deletenum=H2VArray(i);
                        if size(segments,2)==1
                            segments{2}=SwitchArrayV(deletenum);
                            orient=[1 2];
                        else
                            segments{2}=[segments{2} SwitchArrayV(deletenum)];
                        end
                        k=0;
                        while(H2VArray(i+k)==deletenum)
                            if (SwitchArrayH(i+k+1)>SwitchArrayV(H2VArray(i+k)+1))
                                break;
                            end
                            k=k+1;
                            segments{1}(i)=[];
                        end
                        i=i+1;
                    end
                end
            else
                error('Invalid orient parameter')
            end
        end
    end
end
for j=1:size(segments, 2)
    sub_num=1;
    if (orient(j)==1)
        subp=[.1 .37 .85 .13; .1 .2 .85 .13; .1 .03 .85 .13];
        SegArray=SwitchArrayH;
        phandle=hphandle;
        color=hcolor;
    elseif (orient(j)==2)
        subp=[.48 .08 .14 .87; .65 .08 .14 .87; .82 .08 .14 .87];
        SegArray=SwitchArrayV;
        phandle=vphandle;
        color=vcolor;
    else
        error(['Orient(' num2str(j) ') is not 1 or 2']);
    end
    for n=segments{j}
        if (sub_num==1)
            figh=figure;
            if (orient(j)==1)
                set(figh, 'Position', [figh*15 0 560 900]);
                chandle=subplot('position', [.1 .55 .85 .42]);
                copyobj(phandle, chandle);
                hold on;
                axis(pdims);
                hold off;
                title(filename);
                subplot('position', subp(1, :));
            elseif (orient(j)==2)
                set(figh, 'Position', [0 figh*15 1250 480]);
                chandle=subplot('position', [.03 .08 .42 .87]);
                copyobj(phandle, chandle);
                title(filename);
                subplot('position', subp(1, :));
            end
            sub_num=2;
        elseif (sub_num==2)
            subplot('position', subp(2, :));
            sub_num=3;
        elseif (sub_num==3)
            subplot('position', subp(3, :));
            sub_num=1;
        else
            error('Error: corrupted incrementer');
        end       
        if (orient(j)==1)
            plot(DataMatrix(SegArray(n):(SegArray(n+1)-1), 1), DataMatrix(SegArray(n):(SegArray(n+1)-1), 3), 'Color', color(n,:));
            dims=axis;
            dims(1:2)=pdims(1:2);
            title(['Segment ' num2str(n) ' (' num2str(H2VArray(n)) ')']);
        elseif (orient(j)==2)
            plot(DataMatrix(SegArray(n):(SegArray(n+1)-1), 3), DataMatrix(SegArray(n):(SegArray(n+1)-1), 2), 'Color', color(n,:));
            dims=axis;
            dims(3:4)=pdims(3:4);
            title(['Segment ' num2str(n) ' (' num2str(V2HArray(n)) ')']);
        end
        axis(dims);
    end
end
close(hpfhandle);
close(vpfhandle);
end
