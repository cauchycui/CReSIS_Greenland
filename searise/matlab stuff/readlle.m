fid=fopen('jakobshavn_bedmap_pts_SEARISEPROJ_fix.txt');
matrix=textscan(fid,'%f %f %f');
jak(:,1)=matrix{1,1};
jak(:,2)=matrix{1,2};
jak(:,3)=matrix{1,3};