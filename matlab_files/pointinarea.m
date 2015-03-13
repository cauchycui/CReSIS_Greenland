function inarea=pointinarea( varargin )
%pointinarea returns whether a given coordinate is within the area [xmin
%xmax ymin ymax] where the first argument is the coordinate, and the
%remaining arguments outline the areas as shown above
x=varargin{1}(1);
y=varargin{1}(2);
inarea=0;
for i=2:size(varargin,2)
    bounds=varargin{i};
    if ((x>bounds(1))&&(x<bounds(2))&&(y>bounds(3))&&(y<bounds(4)))
        inarea=1;
        break;
    end
end
end

