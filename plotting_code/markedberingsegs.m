close all
x=[-1500 1500];
y1=[60.23 60.23];
y2=[60.29 60.29];
y3=[60.41 60.41];
y4=[60.355 60.355];
y5=[60.46 60.46];
STOV('bering.icet', {[2 3 4], 1}, [2 2], 0, 'Bering Ice Thickness', 'googlebering.png');
%STOV('bering.zsurf', {[2 3 4], 1}, [2 2], 0, 'Bering Surface Elevation','googlebering.png' );
%STOV('bering.zbed', {[2 3 4], 1}, [2 2], 0, 'Bering Bed Elevation','googlebering.png');
paxes=findall(0, 'type', 'axes');
set(paxes, 'NextPlot', 'add');
paxis=axis(paxes);
plot(paxes(6), x, y1, 'r--');
plot(paxes(6), x, y2, 'm--');
plot(paxes(6), x, y3, 'b--');
plot(paxes(6), x, y4, 'g--');
plot(paxes(6), x, y5, 'k--');
plot(paxes(5), x, y1, 'r--');
plot(paxes(5), x, y2, 'm--');
plot(paxes(5), x, y3, 'b--');
plot(paxes(4), x, y3, 'b--');
plot(paxes(4), x, y4, 'g--');
plot(paxes(3), x, y4, 'g--');
plot(paxes(3), x, y5, 'k--');
plot(paxes(2), x, y1, 'r--');
plot(paxes(2), x, y2, 'm--');
plot(paxes(2), x, y3, 'b--');
plot(paxes(2), x, y4, 'g--');
plot(paxes(2), x, y5, 'k--');
plot(paxes(1), x, y1, 'r--');
plot(paxes(1), x, y2, 'm--');
plot(paxes(1), x, y3, 'b--');
plot(paxes(1), x, y4, 'g--');
plot(paxes(1), x, y5, 'k--');
for i=1:6
    axis(paxes(i), paxis{i});
end