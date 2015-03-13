function eq=dlinreg(filename, coord1, coord2)
%coord1=[552500 7606000];
%coord2=[583300 7764000];
%filename='/data/phil/greenland_GLAS/utm_elev/GLA06_06022220_r8251_633_L3E.P6663_01_00.txt.lle.utm';
%filename='/data/phil/greenland_GLAS/utm_elev/GLA06_05021720_r8251_633_L3B.P6663_01_00.txt.lle.utm';
%find area for first coordinate
area1=[0 0 0 0];
place=1;
while(~mod(coord1(1),place))
    place=place*10;
end
area1(1)=coord1(1)-place;
area1(2)=coord1(1)+place;
place=1;
while(~mod(coord1(2),place))
    place=place*10;
end
area1(3)=coord1(2)-place;
area1(4)=coord1(2)+place;
%find area for second coordinate
area2=[0 0 0 0];
place=1;
while(~mod(coord2(1),place))
    place=place*10;
end
area2(1)=coord2(1)-place;
area2(2)=coord2(1)+place;
place=1;
while(~mod(coord2(2),place))
    place=place*10;
end
area2(3)=coord2(2)-place;
area2(4)=coord2(2)+place;

looking1=1;
looking2=1;
fid=fopen(filename);
aline=fgetl(fid);
dformat='%f %f %f';
figure;
hold on;
while (ischar(aline))
    data=sscanf(aline, dformat);
    plot(data(1), data(2), 'b.');
    if (looking1&&pointinarea(data(1),data(2), area1))
        looking1=0;
        point1=[data(1) data(2)];
        plot(data(1), data(2), 'ro');
    end
    if (looking2&&pointinarea(data(1),data(2), area2))
        looking2=0;
        point2=[data(1) data(2)];
        plot(data(1), data(2), 'ro');
    end
    aline=fgetl(fid);
end
fclose(fid);
linslope=(point2(2)-point1(2))/(point2(1)-point1(1));
yintcpt=point1(2)-linslope*point1(1);
eq=[linslope yintcpt];
end