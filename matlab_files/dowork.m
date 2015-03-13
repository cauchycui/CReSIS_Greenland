%a script to run overnight

% display('Extracting area 1')
% data2010='/data/phil/bering/larsen/BeringBagley_2010_233.txt.short';
% area=[356500 358800 6675500 6677000]; %area1.1
% compareplot
% elines=findlonglines(lardata, 3);
% extractlines('/data/phil/bering/larsen/BeringBagley_2010_233.txt', elines, 'a1');
% extractlines('/data/phil/bering/herzfeldlab/flight1_14_08_42.dat', herzdata1, 'a1');
% extractlines('/data/phil/bering/herzfeldlab/flight1_14_22_21.dat', herzdata2, 'a1');
% extractlines('/data/phil/bering/herzfeldlab/flight2_16_51_00.dat', herzdata3, 'a1');
% extractlines('/data/phil/bering/herzfeldlab/flight2_17_15_00.dat', herzdata4, 'a1');
% display('Extracting area 2')
% area=[361000 379000 6683000 6696000]; %area2.1
% compareplot
% elines=findlonglines(lardata, 3);
% extractlines('/data/phil/bering/larsen/BeringBagley_2010_233.txt', elines, 'a2');
% extractlines('/data/phil/bering/herzfeldlab/flight1_14_08_42.dat', herzdata1, 'a2');
% extractlines('/data/phil/bering/herzfeldlab/flight1_14_22_21.dat', herzdata2, 'a2');
% extractlines('/data/phil/bering/herzfeldlab/flight2_16_51_00.dat', herzdata3, 'a2');
% extractlines('/data/phil/bering/herzfeldlab/flight2_17_15_00.dat', herzdata4, 'a2');
% area=[379000 394000 6669200 6700000]; %area 3.1
% display('Extracting area 3')
% compareplot
% elines=findlonglines(lardata, 3);
% extractlines('/data/phil/bering/larsen/BeringBagley_2010_233.txt', elines, 'a3');
% extractlines('/data/phil/bering/herzfeldlab/flight1_14_08_42.dat', herzdata1, 'a3');
% extractlines('/data/phil/bering/herzfeldlab/flight1_14_22_21.dat', herzdata2, 'a3');
% extractlines('/data/phil/bering/herzfeldlab/flight2_16_51_00.dat', herzdata3, 'a3');
% extractlines('/data/phil/bering/herzfeldlab/flight2_17_15_00.dat', herzdata4, 'a3');
% display('Re-extracting area 1')
% area=[356500 358800 6675500 6677000]; %area1.1
% data2010='/data/phil/bering/larsen/BeringBagley_2010_233.txt.a1';
% compareplot
% display('Extracting corrected data...')
% a1_tops=[];
% for i=1:size(topdata,1)
%     a1_tops=[a1_tops; all_tops(topdata(i, 1):topdata(i,2),:)];
% end
% extractlines('/data/phil/bering/larsen/BeringBagley_2010_233.txt.a1', lardata);
% fid=fopen('/data/phil/bering/herzfeldlab/tops.a1.txt', 'w');
% for i=1:size(a1_tops,1)
%     fprintf(fid, '%f %f %f \n', a1_tops(i,1), a1_tops(i,2), a1_tops(i,5));
% end
% fclose(fid);

% display('Re-extracting area 2')
% area=[361000 379000 6683000 6696000]; %area2.1
% data2010='/data/phil/bering/larsen/BeringBagley_2010_233.txt.a2';
% compareplot
% extractlines('/data/phil/bering/larsen/BeringBagley_2010_233.txt.a2', lardata);
% display('Extracting corrected data...')
% a2_tops=[];
% for i=1:size(topdata,1)
% a2_tops=[a2_tops; all_tops(topdata(i, 1):topdata(i,2),:)];
% end
% fid=fopen('/data/phil/bering/herzfeldlab/tops.a2.txt', 'w');
% for i=1:size(a2_tops,1)
%     fprintf(fid, '%f %f %f \n', a2_tops(i,1), a2_tops(i,2), a2_tops(i,5));
% end
% fclose(fid);

%display('Re-extracting area 3')
area=[379000 394000 6669200 6700000]; %area 3.1
data2010='/data/phil/bering/larsen/BeringBagley_2010_233.txt.a3';
% compareplot
% display('Extracting corrected data...')
% a3_tops=[];
% for i=1:size(topdata,1)
% a3_tops=[a3_tops; all_tops(topdata(i, 1):topdata(i,2),:)];
% end
% fid=fopen('/data/phil/bering/herzfeldlab/tops.a3.txt', 'w');
% for i=1:size(a3_tops,1)
%     fprintf(fid, '%f %f %f \n', a3_tops(i,1), a3_tops(i,2), a3_tops(i,5));
% end
% fclose(fid);
% extractlines('/data/phil/bering/larsen/BeringBagley_2010_233.txt.a3', lardata);


disp('Plotting...')
plotdif('/data/phil/bering/larsen/BeringBagley_2010_233.txt.a1.extract', '/data/phil/bering/herzfeldlab/flight2_16_51_00.dat.a1', .02);
title('Area 1 2011 (Herzfeld) minus 2010 elevation data (Larsen) in meters');
print(gcf, '~/documents/plots/bering/larsenherzdiffA1.1.jpg', '-djpeg')
plotdif('/data/phil/bering/larsen/BeringBagley_2010_233.txt.a1.extract', '/data/phil/bering/herzfeldlab/tops.a1.txt', .02);
title('Area 1 2011 surface corrected (Herzfeld) minus 2010 data (Larsen) in meters');
print(gcf, '~/documents/plots/bering/larsenherzdiffA1.1c.jpg', '-djpeg')

a2_f1a=enterdata('/data/phil/bering/herzfeldlab/flight1_14_08_42.dat.a2');
a2_f1b=enterdata('/data/phil/bering/herzfeldlab/flight1_14_22_21.dat.a2');
a2_f2a=enterdata('/data/phil/bering/herzfeldlab/flight2_16_51_00.dat.a2');
a2_f2b=enterdata('/data/phil/bering/herzfeldlab/flight2_17_15_00.dat.a2');
a2_all=[a2_f1a; a2_f1b; a2_f2a; a2_f2b];
plotdif('/data/phil/bering/larsen/BeringBagley_2010_233.txt.a2.extract', a2_all, .02);
hold on;
plot(a2_f1a(:, 1), a2_f1a(:, 2), 'c.', 'markersize', 2)
plot(a2_f1b(:, 1), a2_f1b(:, 2), 'b.','markersize', 2)
plot(a2_f2a(:, 1), a2_f2a(:, 2), 'm.','markersize', 2)
plot(a2_f2b(:, 1), a2_f2b(:, 2), 'r.', 'markersize', 2)
title('Area 2 2011 (Herzfeld) minus 2010 elevation data (Larsen) in meters');
print(gcf, '~/documents/plots/bering/larsenherzdiffA2.1.jpg', '-djpeg')
plotdif('/data/phil/bering/larsen/BeringBagley_2010_233.txt.a2.extract', '/data/phil/bering/herzfeldlab/tops.a2.txt', .02);
title('Area 2 2011 surface corrected (Herzfeld) minus 2010 data (Larsen) in meters')
print(gcf, '~/documents/plots/bering/larsenherzdiffA2.1c.jpg', '-djpeg')

a3_f1a=enterdata('/data/phil/bering/herzfeldlab/flight1_14_08_42.dat.a3');
a3_f1b=enterdata('/data/phil/bering/herzfeldlab/flight1_14_22_21.dat.a3');
a3_f2b=enterdata('/data/phil/bering/herzfeldlab/flight2_17_15_00.dat.a3');
a3_all=[a3_f1a; a3_f1b; a3_f2b];
plotdif('/data/phil/bering/larsen/BeringBagley_2010_233.txt.a3.extract', a3_all, .02);
hold on;
plot(a3_f1a(:, 1), a3_f1a(:, 2), 'c.', 'markersize', 2)
plot(a3_f1b(:, 1), a3_f1b(:, 2), 'b.', 'markersize', 2)
plot(a3_f2b(:, 1), a3_f2b(:, 2), 'r.', 'markersize', 2)
title('Area 3 2011 (Herzfeld) minus 2010 elevation data (Larsen) in meters');
print(gcf, '~/documents/plots/bering/larsenherzdiffA3.1.jpg', '-djpeg')
%plotdif('/data/phil/bering/larsen/BeringBagley_2010_233.txt.a3.extract', '/data/phil/bering/herzfeldlab/tops.a3.txt', .02);
%title('Area 3 2011 surface corrected (Herzfeld) minus 2010 data (Larsen) in meters')
% disp('Testing comparedatasets...')
% comparedatasets;
% title('comparedatasets output (A3)');
