function minsortedgriddata(filename, varargin)
%AVGGRIDDATA takes a file made with seagridsave and sorted by sortseadata
%and finds the averages.
%The first argument is the file made by seagridsave and sorted by
%sortseadata and the second optional argument is the name of the file to be
%output
%filename='/data/phil/searise/cresisboxes/monstertry.txt';
fid=fopen(filename, 'r');
if fid==-1
    error('Input file not found');
end
if nargin==1
    ofid=fopen([filename '.avg'], 'w+');
else
    ofid=fopen(varargin{1}, 'w+');
end
%get the first line to start our first box
a_line=fgetl(fid);
datum=sscanf(a_line, '%d %d %f %d');
current_box=datum(1:2);
box_years=datum(4);
box_val=datum(3);
data_count=1;
a_line=fgetl(fid);
while(ischar(a_line))
    datum=sscanf(a_line, '%d %d %f %d');
    %check if we've changed boxes
    if isequal(current_box, datum(1:2))
        %if we have not changed boxes, we'll modify the data of this box
        if box_years(length(box_years))~=datum(4)
            box_years=[box_years datum(4)];
        end
        data_count=data_count+1;
        box_val=min(box_val,datum(3));
    else %if we have changed boxes, we'll print the data of the last box before storing new box data
        fprintf(ofid, '%d %d %f %d ', current_box(1), current_box(2), box_val, data_count);
        for i=1:(length(box_years)-1)
            fprintf(ofid, '%d,', box_years(i));
        end
        fprintf(ofid,'%d\n', box_years(length(box_years)));
        %initialize the next box
        current_box=datum(1:2);
        box_years=datum(4);
        box_val=datum(3);
        data_count=1;
    end
    a_line=fgetl(fid);
end
%print out the final box now that there is no more data to check against
fprintf(ofid, '%d %d %f %d ', current_box(1), current_box(2), box_val, data_count);
for i=1:(length(box_years)-1)
    fprintf(ofid, '%d,', box_years(i));
end
fprintf(ofid,'%d\n', box_years(length(box_years)));
fclose(fid);
fclose(ofid);
%end