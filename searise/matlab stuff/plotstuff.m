close all
x=[1 500:500:3000];
figure
contour(thks,x)
axis image
title('thk');
figure
contour(nthk,x)
axis image
title('nthk')