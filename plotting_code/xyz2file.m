function xyz2file( filename, x, y, z )
%copies x, y, and z in space delineated columns to the filename for reading
%with TOR
if((size(x,1)~=size(y,1))||(size(x,2)~=size(y,2))||(size(x,2)~=size(z,2))||(size(x,1)~=size(z,1)))
    error('Arguments must be of equal size');
end
if ((isvector(x)==0)||(isvector(y)==0)||(isvector(z)==0))
    error('Arguments must be vectors');
end
if ((ischar(filename)==0)||(size(filename, 1)~=1))
    error('Filename is not in recognized format');
end
fd=fopen(filename, 'w');
for i=1:max(size(x))
    if (isnan(z(i))==0)
        fprintf(fd, '%f %f %f\n', x(i), y(i), z(i));
    end
end

end

