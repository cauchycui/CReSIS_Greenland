%Plot data on a Greenland map
%borders=[-81.5918 -10.400394 59.175928 83.886366];
borders=[-81.840822 -13.916019 58.904646 83.979259];
[gImg gMap] = imread('gGreenland.png');
figure;
set(gcf, 'position', [200 50 600 600])
hi = image([-81.840822 -13.916019], [83.979259 58.904646], gImg);
axis(borders);
set(gca, 'YDir','normal');
daspect([4 1 1]);