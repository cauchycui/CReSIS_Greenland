%plot CRESIS tracks in Greenland
%might need to run curlftpfs data.cresis.ku.edu/data/rds/ /home/chenpa/cresisportal
cresisroot='/home/chenpa/cresisportal/';
years=[2012 2011 2010 2009];
%years=2012;
figure;
%plot the google picture
borders=[-81.840822 -13.916019 58.904646 83.979259];
[tmImg,tmMap]=imread('ggreenland.png');
hi = image([-81.840822, -13.916019], [83.979259, 58.904646], tmImg);
set(gca, 'YDir','normal');
axis([-81.840822 -13.916019 58.904646 83.979259]);
set(gca, 'dataaspectratio', [2 1 1])
set(gcf, 'position', [50 50 800 500])
hold on;
%create the time scale colormap
mycolormap=customcolormap(size(years, 2), [.7 .2 .2; .5 .8 .6]);
colormap(mycolormap);
colorbar;
j=1;
counter=0;
for cur_year=years
    str_cell=ls2strlist(['-d ' cresisroot num2str(cur_year) '_Greenland*']);
    for i=1:size(str_cell, 2)
        [dirpath dirname]=pathname(str_cell{i});
        xdoc=xmlread([cresisroot dirname '/kml_good/Browse_' dirname '.kml']);
        kmlstring=xmlwrite(xdoc);
        seg_color=mycolormap(j,:);
        plotkmlstr;
    end
    j=j+1;
end
counter