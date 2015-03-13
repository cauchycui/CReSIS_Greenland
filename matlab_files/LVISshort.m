function inarea=LVISshort(filename)
inputf=fopen(filename);
outputf=fopen([filename '.short'], 'w');
fgetl(inputf);
aline=fgetl(inputf);
while(ischar(aline))
    data=sscanf(aline, '%d %d %f %f %f %f %f %f %f %f %f %f \n');
    lon=data(4)-360;
    lat=data(5);
    elev=data(6);
    fprintf(outputf, '%f %f %f\n', lon, lat, elev);
    for i=1:9999
        fgetl(inputf);
    end
    aline=fgetl(inputf);
end
fclose(outputf);
fclose(inputf);
count=plotLVIS([filename '.short'])
inarea=checkLVIS([filename '.short']);
end