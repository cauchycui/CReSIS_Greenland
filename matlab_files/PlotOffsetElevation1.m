function PlotOffsetElevation(filename,portion)

fid=fopen(filename);                %opens the text file to file identification fid
data=textscan(fid, '%f%f%f');       %reads the text file to a 1x3 cell array (x, y, and z)
fclose(fid);                        %closes the text file
MatrixSize=size(data{1,1});         %checks the number of points by measuring the number of x entries
PathMatrix=zeros(MatrixSize(1),2);      %creates an nx3 matrix where n is the number of data points
PathMatrix(:,1)=data{1,1};              %inputs the x data into the matrix
PathMatrix(:,2)=data{1,2};              %inputs the y data into the matrix
%PathMatrix(:,3)=data{1,3};              %inputs the z data into the matrix
part=ceil(MatrixSize(1)/portion);      %creates a limit for the number of entries plotted
%A=Figure
plot(PathMatrix(1:part,1),PathMatrix(1:part,2)) %plots the figure
%OffsetArray=data{1,3};
SlopeArray=zeros(MatrixSize(1),1);
SlopeArray(1)=(PathMatrix(2,2)-PathMatrix(1,2))/(PathMatrix(2,1)-PathMatrix(1,1));
if part==MatrixSize(1)
    safepart=part-1;
    truncate=1;
else
    safepart=part;
    truncate=0;
end
for n=2:safepart
    SlopeArray(n)=(PathMatrix(n+1,2)-PathMatrix(n-1,2))/(PathMatrix(n+1,1)-PathMatrix(n-1,1));
end
if truncate==1;
    SlopeArray(MatrixSize(1))=(PathMatrix(MatrixSize(1),2)-PathMatrix(MatrixSize(1)-1,2))/(PathMatrix(MatrixSize(1),1)-PathMatrix(MatrixSize(1)-1,2));
end
OffsetArray=zeros(size(SlopeArray));
for n=1:part
    OffsetArray(n)=atan((pi/2)-atan(SlopeArray(n)));
end
OffsetMatrix=zeros(size(PathMatrix));
OffsetMatrix(:,1)=data{1,3};
for n=1:part
    OffsetMatrix(n,2)=OffsetMatrix(n,1)*OffsetArray(n);
end
PlotMatrix=zeros(2*part, 2);
for n=1:part
    PlotMatrix(n,1)=PathMatrix(n,1);
    PlotMatrix(n,2)=PathMatrix(n,2);
    PlotMatrix(part+n,1)=PathMatrix(n,1)+OffsetMatrix(n,1);
    PlotMatrix(part+n,2)=PathMatrix(n,2)+OffsetMatrix(n,2);
end
%B=Figure

plot(PlotMatrix(:,1), PlotMatrix(:,2));
zoom on
%PlotMatrix
end


