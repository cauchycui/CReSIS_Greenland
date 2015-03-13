function PlotOffsetRoughness(varargin)
%TextOffsetRoughness returns the number of tracks in the pond data set and
%matrices for coordinates of a graph of the satellite tracks along with roughness values offset
%perpendicularly from the tracks. The function has up to eleven optional
%inputs: filename, tracks, roughness value processing ('values',
%'sqrt', or 'log'), title ('default' maintains default titling and 'image'
%creates a PostScript image and text file with parameters), scale factor,
%boundaries, offset color, jump color, track color, background color.

%% Initialization and Help
%Here the various user inputs are inputted into the cell optinputs and the
%defaults are set by the starting values of optinputs.
doffsetRGB= [.8 0 0];
djumpRGB=[0 .8 .4];
dtrackRGB=[.2 .6 1];
dbgRGB=[1 1 1];
optinputs={0, 0, 'values', 1, 'default', 'default', 0, doffsetRGB, djumpRGB, dtrackRGB, dbgRGB};
inputnumber=size(varargin,2);
for n=1:inputnumber
    if varargin{1,n}~=0         %inputs of 0 will maintain default
    optinputs{1,n}=varargin{1,n};
    end
end

%Rename the input variables to something easier to read
filename=optinputs{1,1};
tracks=sort(optinputs{1,2});
graphtype=optinputs{1,3};
mirror=optinputs{1,4};
usertitle=optinputs{1,5};
scaling=optinputs{1,6};
boundaries=optinputs{1,7};
offsetRGB=optinputs{1,8};
jumpRGB=optinputs{1,9};
trackRGB=optinputs{1,10};
bgRGB=optinputs{1, 11};

%gives the order of input arguments
if ischar(filename)~=1
    disp('PlotOffsetRoughness will display the number of tracks found within a data set')
    disp('and plot the tracks along with qualitative plots of roughness values perpendicular')
    disp('to the satellite tracks.')
    disp('PlotOffsetRoughness has up to eleven inputs: filename, tracks, linearization,')
    disp('symmetry, title, scaling, boundaries, offset color, jump color, track color,')
    disp('and background color. If an argument is not entered, the default value is used.')
    disp('For more help, type PlotOffsetRoughness(''help <argument>'').')
elseif strcmp(filename, 'help')
    disp('For help with an argument please enter ''help <argument>''. Argument names include')
    disp('filename, tracks, linearization, title, scaling, boundaries, and offset color.')
%gives a description of each of the arguments and their use
elseif strcmp(filename, 'help filename')
    disp('filename is simply the name of the pond roughness file being')
    disp('plotted (or the path to it if the file is not in the same folder as')
    disp('PlotOffsetRoughness.m). The filename must be surrounded by ''.')
elseif strcmp(filename, 'help tracks')
    disp('The tracks values determine which and how many satellite tracks to plot. By')
    disp('default, the function plots all the tracks, but otherwise will plot all tracks')
    disp('given in the tracks argument. For instance, a tracks entry of [2:6 10 15:16]')
    disp('will plot tracks two through six, ten, fifteen and sixteen.')
elseif strcmp(filename, 'help linearization')
    disp('The three options for roughness linearization are ''values'', ''sqrt'', and ''log''.')
    disp('''values'' plots the raw roughness data, ''sqrt'' plots the square-rooted values,')
    disp('and ''log'' performs a log base two transform on the data. By default linearization')
    disp('is set to ''values''. For more control over plotted data, see scaling.')
elseif strcmp(filename, 'help symmetry')
    disp('If this argument is a 1, the offset plot will only plot on one side of the track.')
    disp('If this argument is a 2, the offset plot will plot symmetrically around the track.')
    disp('Values higher than 2 will plot on the current plot (rather than making a new one).')
    disp('A value of 3 will plot one side,  a value of 4 will plot on the opposite side, and a')
    disp('value of 5 will plot symmetrically.')
elseif strcmp(filename, 'help title')
    disp('title sets the title of the plot. The title must be surrounded by ''. By default,')
    disp('the title displays Jakobshavn Isbrae <year> GLAS Data pond. To keep the default')
    disp('while entering additional arguments, enter ''default''. To create a PostScript image')
    disp('and a text file including boundary data and linearization type, enter ''image''.')
    disp('To label each of the tracks with a track number, enter ''label''.')
elseif strcmp(filename, 'help scaling')
    disp('scaling sets the average x displacement of the plotted roughness data from the')
    disp('satellite tracks in terms of the x axis. So a scaling of 1/100 will result in an ')
    disp('average distance of 1/100 of the x axis away from the satellite tracks. By default,')
    disp('the average displacement is 1/100 for ''values'', 1/50 for ''sqrt'', and 1/40 for')
    disp('''log''.')
elseif strcmp(filename, 'help boundaries') || strcmp(filename, 'help xmin') || strcmp(filename, 'help xmax') || strcmp(filename, 'help ymin') || strcmp(filename, 'help ymax')
    disp('Allows the user to manually set the minimum and maximum x and y values of the plot.')
    disp('The boundaries must be inputted in brackets: [xmin xmax ymin ymax].')
    disp('If not enough boundary arguments are given, any user inputted boundary arguments are')
    disp('ignored and a message is displayed warning the user default boundaries are used.')
    disp('An entry of 0 will not trigger this warning message.')
    disp('Default boundaries use MatLAB plot boundaries.')
elseif strcmp(filename, 'help offset color') || strcmp(filename, 'help jump color') || strcmp(filename, 'help track color') || strcmp(filename, 'help background color')
    disp('All four color arguments require RGB values inputted within brackets: [red green blue].')
    disp('1 is the max value and 0 is the minimum value. E.G. [0 0 1] is blue and [0 0 0] is black.')
    disp('The offset color affects the offset plotted roughness data, the jump color affects the ')
    disp('empty space between observations, the track color affects the color of the satellite')
    disp('tracks, and the background color affects the color of the plot. If anything but a bracketed')
    disp('RGB value is inputted, a warning message will be sent and values reset to their defaults.')
    disp('An entry of 0 will not trigger this warning message. Default values for offset color, jump')
    disp('color, track color, and background color are, respectively, [.8 0 0], [0 .8 .4], [.2 .6 1],')
    disp('and [1 1 1].')
else
%Program checks input arguments for impossible situations
fid=fopen(filename);                                 %opens the text file to file identification fid
if fid==-1
    errormsg=['File ' filename ' not found, check argument one.'];
    error(errormsg)     %Exits the program if file is not found.
else
if mirror<1||mirror>5
    disp('Argument five should be between 1 and 5.');
end

%Program checks function to see if arguments are in expected formats
if ischar(filename)~=1
    errormsg=['Argument one, ', num2str(filename), ', should be a string.'];
    disp(errormsg);
end
if isnumeric(tracks)~=1
    errormsg=['Argument two, ', tracks, ', should be numeric.'];
    disp(' ');    disp(errormsg);
end
if ischar(usertitle)~=1
    errormsg=['Argument six, ', num2str(usertitle), ', should be a string.'];
    disp(errormsg);
end
if isnumeric(scaling)~=1 && strcmp(scaling, 'default')~=1
    errormsg=['Argument seven, ', scaling, ', should be numeric or ''default''.'];
    disp(errormsg);
end
if isnumeric(boundaries)~=1
    errormsg=['Argument eight, ', boundaries,', should be numeric.'];
    disp(errormsg);
end
if size(offsetRGB,2)~=3
    if offsetRGB~=0
        disp(' ');
        errormsg=['Argument nine, ', num2str(offsetRGB), ', should have three entries.'];
        disp(errormsg);
        disp(['Setting offset color to ' num2str(doffsetRGB) '.']);
    end
    offsetRGB=doffsetRGB;
elseif isnumeric(offsetRGB)~=1
    disp(' ');
    errormsg=['Argument nine, ', offsetRGB, ', should have three numeric entries.'];
    disp(errormsg);
    disp(['Setting offset color to ' num2str(doffsetRGB) '.']);
    offsetRGB=doffsetRGB;
elseif offsetRGB(1)>1 || offsetRGB(1)<0 || offsetRGB(2)>1 || offsetRGB(2)<0 || offsetRGB(3)>1 || offsetRGB(3)<0
    disp(' ');
    disp(num2str(offsetRGB), ' lie outside the range of zero to one.')
    disp(['Setting offset RGB to ' num2str(doffsetRGB) '.']);
    offsetRGB=doffsetRGB;
end

if size(jumpRGB,2)~=3
    if jumpRGB~=0
        disp(' ');
        errormsg=['Argument ten, ', num2str(jumpRGB), ', should have three entries.'];
        disp(errormsg);
        disp(['Setting jump color to ' num2str(djumpRGB) '.']);
        jumpRGB=djumpRGB;
    end
elseif isnumeric(jumpRGB)~=1
    disp(' ');
    errormsg=['Argument ten, ', jumpRGB, ', should have three numeric entries.'];
    disp(errormsg);
    disp(['Setting jump color to ' num2str(djumpRGB) '.']);
    jumpRGB=djumpRGB;
elseif jumpRGB(1)>1 || jumpRGB(1)<0 || jumpRGB(2)>1 || jumpRGB(2)<0 || jumpRGB(3)>1 || jumpRGB(3)<0
    disp(' ');
    disp(num2str(jumpRGB), ' lie outside the range of zero to one.')
    disp(['Setting jump RGB to ' num2str(djumpRGB) '.']);
end
if size(trackRGB,2)~=3
    if trackRGB~=0
        disp(' ');
        errormsg=['Argument eleven, ', num2str(trackRGB), ', should have three entries.'];
        disp(errormsg);
        disp(['Setting track color to ' num2str(dtrackRGB) '.']);
    end
    trackRGB=dtrackRGB;
elseif isnumeric(trackRGB)~=1
    disp(' ');
    errormsg=['Argument eleven, ', trackRGB, ', should have three numeric entries.'];
    disp(errormsg);
    disp(['Setting track color to ' num2str(dtrackRGB)'.']);
    trackRGB=dtrackRGB;
elseif trackRGB(1)>1 || trackRGB(1)<0 || trackRGB(2)>1 || trackRGB(2)<0 || trackRGB(3)>1 || trackRGB(3)<0
    disp(' ');
    disp([num2str(trackRGB) ' lie outside the range of zero to one.'])
    disp(['Setting track RGB to ' num2str(dtrackRGB) '.']);
    trackRGB=dtrackRGB;
end
if size(bgRGB,2)~=3
    if bgRGB~=0
        disp(' ');
        errormsg=['Argument twelve, ', num2str(bgRGB), ', should have three entries.'];
        disp(errormsg);
        disp(['Setting background color to ' num2str(dbgRGB) '.']);
    end
    bgRGB=dbgRGB;
elseif isnumeric(bgRGB)~=1
    disp(' ');
    errormsg=['Argument twelve, ', bgRGB, ', should have three numeric entries.'];
    disp(errormsg);
    disp(['Setting background color to ' num2str(dbgRGB) '.']);
    bgRGB=dbgRGB;
elseif bgRGB(1)>1 || bgRGB(1)<0 || bgRGB(2)>1 || bgRGB(2)<0 || bgRGB(3)>1 || bgRGB(3)<0
    disp(' ');
    disp(num2str(bgRGB), ' lie outside the range of zero to one.')
    disp(['Setting background RGB to ' num2str(dbgRGB) '.']);
    bgRGB=dbgRGB;
end


    data=textscan(fid, '%f%f%f', 'CommentStyle', '#');       %reads the text file to a 1x3 cell array (x, y, and z) and ignores lines with # in front
    fclose(fid);                       %closes the text file
end

%% Data Processing
DataSize=size(data{1,1},1);       %records the number of x entries and assumes the number of total entries are the same
DataMatrix=zeros(DataSize,3);      %creates an nx3 matrix where n is the number of data points
DataMatrix(:,1)=data{1,1};              %inputs the x data into the matrix
DataMatrix(:,2)=data{1,2};              %inputs the y data into the matrix
DataMatrix(:,3)=data{1,3};          %inputs roughness data into matrix

%SlopeMatrix is the matrix with all the slopes of the tracks
SlopeMatrix=zeros(DataSize,3);
%The first element of SlopeMatrix is created seperately to have a reference
%to check further slopes against for the purpose of finding discontinuities
SlopeMatrix(1,1)=(DataMatrix(2,2)-DataMatrix(1,2))/(DataMatrix(2,1)-DataMatrix(1,1));
Breakpoints=1;			%Breakpoints keeps track of the number of discontinuities and counts the first point as a discontinuity
Jumppoints=1;
pathdistanceold=sqrt(((DataMatrix(2,2)-DataMatrix(1,2))^2)+(DataMatrix(2,1)-DataMatrix(1,1))^2);    %The distance between the first two points
%Here elements of SlopeMatrix are created by dividing the change in y by the change in x
for n=2:DataSize
    SlopeMatrix(n,1)=(DataMatrix(n,2)-DataMatrix(n-1,2))/(DataMatrix(n,1)-DataMatrix(n-1,1));
    pathdistance=sqrt(((DataMatrix(n,2)-DataMatrix(n-1,2))^2)+(DataMatrix(n,1)-DataMatrix(n-1,1))^2);
    %If the slope changes by more than 20%, it notes the number of breakpoints has increased and it notes there is a discontinuity within SlopeMatrix's second column with a 1
    if abs((SlopeMatrix(n,1)-SlopeMatrix(n-1,1))/(SlopeMatrix(n,1)))>.2
        Breakpoints=Breakpoints+1;
        SlopeMatrix(n,1)=(DataMatrix(n+1,2)-DataMatrix(n,2))/(DataMatrix(n+1,1)-DataMatrix(n,1));
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

if tracks==0
    tracks=1:Breakpoints;
end
trackentries=size(tracks,2);
%Creates the BreakArray which is a vector with all the row numbers of discontinuities including row 1 and the last row
BreakArray=zeros(Breakpoints+1,1);      %The +1 is to add room to count the very last datapoint as a breakpoint
BreakArray(1)=1;
BreakArray(Breakpoints+1)=DataSize;
JumpMatrix=zeros(Jumppoints,2);        %If the very first or last data point is a jumppoint, this could be a problem
JumpMatrix(1,2)=1;
BreakPlace=0;		%This keeps track of the row within the for loop
BreakNumber=1;		%This keeps track of the number of slope discontinuities logged
JumpNumber=1;      %This keeps track of the number of position discontinuities logged
%A JumpMatrix is created that contains the row numbers of each jump point
%in the first column; a BreakArray is created that contains the row numbers
%of each break point. Every break point is a jump point, and the second
%column of the JumpMatrix notes which jump points are also break points and
%which break point they are.
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
JumpMatrix(size(JumpMatrix,1),2)=Breakpoints+1;
%The OffsetArray keeps track of the ratio the y coordinates need to be offset compared to the x coordinates. I.E. y offset = (x offset)*OffsetArray
OffsetArray=zeros(DataSize,1);
%Uses trigonometry to find the ratio; see Day 3 notes for a diagram
for n=1:DataSize
    OffsetArray(n)=tan((pi/2)-atan(SlopeMatrix(n,1)));
end

%Here is where the scaling coefficient is determined; the SampleMatrix is a
%matrix including all the data actually being used
SampleMatrix=zeros(size(DataMatrix,1), 3);
sampleend=0;
for m=tracks
    samplestart=sampleend+1;
    sampleend=sampleend+BreakArray(m+1)-BreakArray(m);
    SampleMatrix(samplestart:sampleend, :)=DataMatrix(BreakArray(m):BreakArray(m+1)-1, :);
end
SampleMatrix=SampleMatrix(1:sampleend, :);
RoughnessAverage=mean(SampleMatrix(:, 3));
xlength=max(SampleMatrix(:,1))-min(SampleMatrix(:,1));
if strcmp(scaling, 'default')
    if strcmp(graphtype, 'values')
        scaling=(1/200);
    elseif strcmp(graphtype, 'sqrt')
        scaling=(1/50);
    elseif strcmp(graphtype, 'log')
        scaling=(1/40);
    end
end
if scaling<1
if strcmp(graphtype, 'values')
        coefficient=scaling*xlength/RoughnessAverage;
elseif strcmp(graphtype, 'sqrt')
        coefficient=scaling*xlength/sqrt(RoughnessAverage);
elseif strcmp(graphtype, 'log')
        coefficient=scaling*xlength/log2(RoughnessAverage);
end
else
    coefficient=scaling;
end
%OffsetMatrix keeps track of the x and y displacements from the path
OffsetMatrix=zeros(size(DataMatrix));
%OffsetMatrix x values are processed here to create one of three
%linearization methods: values, square root, log
if strcmp(graphtype,'values')    
    OffsetMatrix(:,1)=coefficient*DataMatrix(:,3);
elseif strcmp(graphtype, 'sqrt')
    OffsetMatrix(:,1)=coefficient*sqrt(DataMatrix(:,3));
elseif strcmp(graphtype, 'log')
    minimum=min(log2(SampleMatrix(:,3)));
    OffsetMatrix(:,1)=coefficient*(log2(DataMatrix(:,3))-minimum);
end
for n=1:DataSize
    OffsetMatrix(n,2)=OffsetMatrix(n,1)*-1*OffsetArray(n);
end

%% Plotting
%Prevents plots from overwriting each other and creates a figure with a
%given size
if mirror<3
figure('Position', [1 512 640 512]);
set(gca, 'Color', bgRGB);
elseif mirror==3
    mirror=1;
end
hold on
%function plots tracks based on user inputted values starttrack and endtrack

for m=tracks+1
    %PlotMatrix2 plots the offset values by adding the offset matrix to the
    %path matrix; BreakArray is compared against its previous value to find
    %number of data points of the current track   
    PlotMatrix2=zeros((BreakArray(m)-BreakArray(m-1)), 2);
    %Here the entries are entered into the plot matrix along with a mirror
    %if symmetry is on
    PlotMatrix2(1:BreakArray(m)-BreakArray(m-1),1)=DataMatrix(BreakArray(m-1):BreakArray(m)-1,1)...
        + OffsetMatrix(BreakArray(m-1):BreakArray(m)-1,1);
    PlotMatrix2(1:BreakArray(m)-BreakArray(m-1),2)=DataMatrix(BreakArray(m-1):BreakArray(m)-1,2)...
        +OffsetMatrix(BreakArray(m-1):BreakArray(m)-1,2);
    if mirror>1
        MirrorMatrix=zeros((BreakArray(m)-BreakArray(m-1)), 2);
        MirrorMatrix(1:BreakArray(m)-BreakArray(m-1),1)=DataMatrix(BreakArray(m-1):BreakArray(m)-1,1)-OffsetMatrix(BreakArray(m-1):BreakArray(m)-1,1);
        MirrorMatrix(1:BreakArray(m)-BreakArray(m-1),2)=DataMatrix(BreakArray(m-1):BreakArray(m)-1,2)-OffsetMatrix(BreakArray(m-1):BreakArray(m)-1,2);
        plot(MirrorMatrix(:,1), MirrorMatrix(:,2),'Color', offsetRGB)
    end
    if mirror~=4
    plot(PlotMatrix2(:,1), PlotMatrix2(:,2),'Color', offsetRGB);
    end
end

%Uses the second column of JumpMatrix to find which jump points correspond
%to the selected tracks and writes them into JumpArray, a jump equivalent 
%for the tracks variable
tracknumber=1;
writing=0;
JumpArray=zeros(1, Jumppoints);
for n=1:Jumppoints

    if JumpMatrix(n,2)==tracks(tracknumber)
        writing=1;
        if tracknumber~=trackentries
        tracknumber=tracknumber+1;
        end
    elseif tracknumber~=1 && JumpMatrix(n,2)==tracks(tracknumber-1)+1
        writing=0;
    elseif JumpMatrix(n,2)==tracks(tracknumber)+1
        writing=0;
    end
    if writing==1
        JumpArray(n)=n;
    end
end
JumpArray=sort(JumpArray);
count=0;
for n=1:Jumppoints
    if JumpArray(n)~=0
        count=count+1;
    end
end

JumpArray=JumpArray(Jumppoints+1-count:Jumppoints);

%Creates different colored lines wherever the program has discovered jumps
for n=JumpArray
    index=JumpMatrix(n,1);
    if JumpMatrix(n,2)==0 && mirror~=3
        line([DataMatrix(index-1,1) + OffsetMatrix(index-1,1)...
         DataMatrix(index,1) + OffsetMatrix(index,1)],...
        [DataMatrix(index-1,2) + OffsetMatrix(index-1,2)...
         DataMatrix(index,2) + OffsetMatrix(index,2)],...
        'color', jumpRGB)
        if mirror>1                     %if symmetry is on, the lines are mirrored
         line([DataMatrix(index-1,1) - OffsetMatrix(index-1,1)...
         DataMatrix(index,1) - OffsetMatrix(index,1)],...
        [DataMatrix(index-1,2) - OffsetMatrix(index-1,2)...
         DataMatrix(index,2) - OffsetMatrix(index,2)],...
        'color', jumpRGB)
        end
    end
end

for m=tracks+1
    %PlotMatrix1 plots the track. BreakArray is checked against its
    %previous value to find the number of entries of the track
    PlotMatrix1=zeros((BreakArray(m)-BreakArray(m-1)), 2);
    %Here the entries are entered into the plot matrix
    PlotMatrix1(1:BreakArray(m)-BreakArray(m-1),1)=DataMatrix(BreakArray(m-1):BreakArray(m)-1,1);
    PlotMatrix1(1:BreakArray(m)-BreakArray(m-1),2)=DataMatrix(BreakArray(m-1):BreakArray(m)-1,2);
    plot(PlotMatrix1(:,1), PlotMatrix1(:,2),'Color', trackRGB, 'LineWidth', 1.5);
    if strcmp(usertitle, 'label')
        text(PlotMatrix1(1,1),PlotMatrix1(1,2), num2str(m-1));
    end
end


%Allows new figures to overwrite the current figure again, and fixes the
%aspect ratio to be equal distances for x and y
hold off
axis equal
if size(boundaries,2)==4
    axis(boundaries)
elseif boundaries~=0
    disp(' ');
    disp('Insufficient axis boundaries given, default values used.')
end

%Creates the x and y labels and boxes the graph
words=[filename, '      ', date, '      ', graphtype];
variable_label = xlabel({'UTM East(m)', words});
ylabel('UTM North(m)');
set(variable_label, 'interpreter', 'none')
set(gca, 'Box', 'on');
%Checks whether the user has defined a title, and if not, titles the plot
%Jakobshavn Isbrae <year> GLAS Data pond
if strcmp(usertitle, 'default') || strcmp(usertitle, 'label')
    GraphTitle=strcat('Jakobshavn Isbrae 20', filename(7:8), ' GLAS Data pond');
    if trackentries~=1
        tracks=['tracks ', num2str(tracks),];
    else
        tracks=['track ', num2str(tracks)];
    end
    title({GraphTitle; tracks});
elseif strcmp(usertitle, 'image')~=1
    title(usertitle)
%If the title is 'image', the axes are removed and the plot is saved as an
%PostScript image and textfile with the name of the pond data as the name 
%of the file
else
    %without a user defined boundary, the image will be cropped as close as
    %possible
    if size(boundaries,2)~=4
    axis image              %crops the image so there is no empty space
    boundaries=axis;        %records the boundaries of the cropped image
    end
    axis off
    handle = gcf;
    print(handle, '-dpsc', '-r300', [filename '.ps'])
    disp(' ')
    disp(['Image created with name ', filename, '.ps']);
    txtid= fopen([filename '.txt'], 'wt');
    fprintf(txtid, '#xmin, xmax, ymin, ymax, linearization\n%f\n%f\n%f\n%f', boundaries);
    fprintf(txtid, '\n%s', graphtype);
    fclose(txtid);
    disp(['Text file created with name ', filename, '.txt']);
    close
end

%% Data Display
%Outputs the number of tracks in a nice way
disp(' ');
disp([num2str(Breakpoints), ' track(s) detected.']);
disp(['Scaling coefficient of ', num2str(coefficient), ' used.'])
end
end

