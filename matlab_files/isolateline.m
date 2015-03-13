function isolateline(infile, equation, tolerance, varargin)
%infile='/data/phil/greenland_GLAS/utm_elev/GLA06_05021720_r8251_633_L3B.P6663_01_00.txt.lle.utm';
outfile=[infile '.lin'];
%equation=eq;
%tolerance=400;
fid=fopen(infile);
ofid=fopen(outfile, 'w');
aline=fgetl(fid);
dformat='%f %f %f';
while (ischar(aline))
    data=sscanf(aline, dformat);
    %plot(data(1), data(2), 'b.');
    y=data(1)*equation(1)+equation(2);
    %plot(data(1), y, 'g--');
    %plot(data(1), y+tolerance, 'g.');
    %plot(data(1), y-tolerance, 'g.');
    if (data(2)<(y+tolerance))&&(data(2)>(y-tolerance))
        looking1=0;
        point1=[data(1) data(2)];
        %plot(data(1), data(2), 'ro');
        fprintf(ofid, '%s\n', aline);
    end    
    aline=fgetl(fid);
end
fclose(fid);