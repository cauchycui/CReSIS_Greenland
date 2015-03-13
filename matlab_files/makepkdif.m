%calculates peakdiff of filename assuming it has been
%generated using Bruce's readglas.py with parameters
%i_lat,i_lon,i_parm1,iparm2
filename='/data/phil/greenland_GLAS/sigma/GLA05_03022021_r8251_633_L1A.P6663_01_00.txt.sig';
ext='.pkdif';
infid=fopen(filename, 'r');
outfid=fopen([filename ext], 'w');
aline=fgetl(infid);
%while (ischar(aline))
    data=sscanf(aline, '%f');
    if size(data,1)~=10
        disp('Warning: incorrect format');
    end
    pkdif=(data(5)-data(9))/10;
    fclose(infid);
    fclose(outfid);