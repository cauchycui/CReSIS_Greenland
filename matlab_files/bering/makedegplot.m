area=[-144 -142.5 60.1 60.5];
%area=[0 425000 0 7000000];
offset=.05;
i=size(sdlar,1);
while (i>0)
    if ~pointinarea([sdlar(i, 1) sdlar(i, 2)], area)
        sdlar(i,:)=[];
    end
    i=i-1;
end
figure
hold on;
%plot the google picture
[tmImg,tmMap]=imread('beringtrackcompare.png');
hi = image([-143.9, -142.7], [60.49, 60.11], tmImg);
set(gca, 'YDir','normal');
axis([-143.9 -142.7 60.11 60.49]);
%plot the data
plot(sdlar(:,1), sdlar(:,2), 'g.');
plot(herz1(:, 3), herz1(:, 4), 'c.');
plot(herz2(:, 3), herz2(:, 4), 'b.');
plot(herz3(:, 3), herz3(:, 4), 'm.');
plot(herz4(:, 3), herz4(:, 4), 'r.');
%first area
plot([-143.5892 -143.5477 -143.5467 -143.5881 -143.5892], ...
    [60.2045 60.2053 60.1918 60.1918 60.2045], 'k-')
th=text(-143.5477, 60.2053, 'A1');
set(th, 'fontsize', 20)
%second area
plot([-143.5211 -143.1950 -143.1872 -143.5122 -143.5122], ...
    [60.3765 60.3823 60.2656 60.2599 60.3765], 'k-')
th=text(-143.5122-offset, 60.2599, 'A2');
set(th, 'fontsize', 20)
%third area
plot([-143.1974 -142.9252 -142.9209 -143.1926 -143.1974], ...
    [60.4182 60.4224 60.3506 60.3464 60.4182], 'k-')
th=text(-142.9252, 60.4224, 'A3');
set(th, 'fontsize', 20)
% some cosmetic issues
set(gca, 'dataaspectratio', [875 557 1], 'fontsize', 20)
set(gcf, 'position', [50 50 1200 700])
title('Larsen Herzfeld Geographical Data Overlap')
legend('Larsen Data', 'Herzfeld 1a', 'Herzfeld 1b', 'Herzfeld 2a',...
    'Herzfeld 2b', 'location', 'southeast');
hold off