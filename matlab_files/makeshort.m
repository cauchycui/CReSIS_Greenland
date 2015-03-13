function makeshort(varargin)
if (size(varargin,2)>3)
    if (mod(size(varargin,2), 3))
    error('Need arguments in triplets');
    end
elseif (size(varargin,2)<2)
    error('not enough arguments');
end
filename=varargin{1};
power=varargin{2};
if size(varargin,2)==3
    outputname=varargin{3};
else
    outputname=[filename '.short'];
end
dformat='%f %f %f';
inputf=fopen(filename);
outputf=fopen([outputname], 'w');
fgetl(inputf);
aline=fgetl(inputf);
while (ischar(aline))
    data=sscanf(aline, dformat);
    x=data(1);
    y=data(2);
    z=data(3);
    fprintf(outputf, [dformat '\n'], x, y, z);
    for i=1:(10^power-1)
        fgetl(inputf);
    end
    aline=fgetl(inputf);
end
fclose(outputf);
fclose(inputf);
end