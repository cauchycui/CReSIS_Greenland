%area=[-inf inf -inf inf];
%area=[-inf 415000 -inf inf];
%data2009sd='/data/phil/bering/larsen/BeringBagleyeast_2009_231.txt.short.deg';
%data2010='/data/phil/bering/larsen/BeringBagley_2010_233.txt.short';
%area=[-143.75 -143.5 60.175 60.2]; %area1.0 deg
%data2010='/data/phil/bering/herzfeldlab/crossoversegs/larsena1.txt.2short.extract';
%area=[357250 357750 6676000 6676500]; %area1.0
%area=[356500 358800 6675500 6677000]; %area1.1
%area=[-143.5 -143.25 60.26 60.35]; %area2.0 deg
%data2010='/data/phil/bering/herzfeldlab/crossoversegs/larsena2.txt.3short.extract';
%area=[361000 379000 6683000 6694000];
%area=[361000 379000 6683000 6696000]; %area2.1
%area=[-143.25 -142.75 60.35 60.4]; %area3
%area=[365000 400000 6689000 6699500]; %area3.0
%area=[379000 394000 6669200 6700000]; %area 3.1
%data2010='/data/phil/bering/herzfeldlab/crossoversegs/larsena3.txt.3short';

disp('Checking file lengths...');
[status, result] = system( ['wc -l ' data2010]);
if (status)
    disp('wc error')
    return;
end
linecount=sscanf(result, '%d');
statuscount=1;
tic;
fid=fopen(data2010);
a_line=fgetl(fid);
%figure;
hold on
lline=-1;
count=0;
dcount=0;
lardata=[0 0];
while(ischar(a_line))   
    coords=sscanf(a_line, '%f', 2);
    if size(coords,1)>1
        count=count+1;
        if (pointinarea([coords(1) coords(2)], area))
            %plot(coords(1), coords(2), 'go')
            if (lline<1)
                dcount=dcount+1;
                lardata(dcount, 1)=count;
                %text(coords(1), coords(2), num2str(count));
            end
            lline=count;
        end
        if ((lline>0)&&(lline~=count))
            lardata(dcount,2)=lline;
            lline=0;
        end
    else
        disp(['Skipped line reading "' a_line '"']);
    end
    a_line=fgetl(fid);
    if (count==(statuscount*floor(linecount/20)))
        elapsedtime=toc;
        disp([num2str(5*statuscount) '% done in ' num2str(elapsedtime) ' seconds.']);
        statuscount=statuscount+1;
    end
end
if lardata(size(lardata, 1), 2)==0
    lardata(size(lardata, 1), 2)=count;
end
fclose(fid);
%data2011a='/data/phil/bering/herzfeldlab/flight1_14_08_42.dat';
%data2011a='/data/phil/bering/herzfeldlab/crossoversegs/flight1_14_08_42_a2.txt';
%data2011a='/data/phil/bering/herzfeldlab/crossoversegs/flight1_14_08_42_a3.txt';
disp('Plotting flight 1...');
lline=-1;
count=0;
dcount=0;
herzdata1=[0 0];
statuscount=1;
landmark=floor(size(herz1,1)/10);
%fid=lfopen(data2011a);
for i=1:size(herz1, 1)
    coords=herz1(i, 1:2);
    count=count+1;
    if (pointinarea([coords(1) coords(2)], area))
        %plot(coords(1), coords(2), 'ro')
        if (lline<1)
            dcount=dcount+1;
            herzdata1(dcount, 1)=count;
            %text(coords(1), coords(2), num2str(count));
        end
        lline=count;
    end
    if ((lline>0)&&(lline~=count))
        herzdata1(dcount,2)=lline;
        lline=0;
    end
    if (i==(landmark*statuscount))
        disp([num2str(10*statuscount) '% done with flight 1'])
        statuscount=statuscount+1;
    end
end
if ((herzdata1(size(herzdata1, 1), 2)==0)&&(herzdata1(1,1)~=0))
    herzdata1(size(herzdata1, 1), 2)=size(herz1, 1);
end
%lfclose(fid);
data2011b='/data/phil/bering/herzfeldlab/flight1_14_22_21.dat';
%data2011b='/data/phil/bering/herzfeldlab/crossoversegs/flight1_14_22_21_a2.txt';
%data2011b='/data/phil/bering/herzfeldlab/crossoversegs/flight1_14_22_21_a3.txt';
disp('Plotting flight 2...');
lline=-1;
count=0;
dcount=0;
herzdata2=[0 0];
%fid=lfopen(data2011b);
for i=1:size(herz2, 1)
    coords=herz2(i, 1:2);
    count=count+1;
    if (pointinarea([coords(1) coords(2)], area))
        %plot(coords(1), coords(2), 'bo')
        if (lline<1)
            dcount=dcount+1;
            herzdata2(dcount, 1)=count;
            %text(coords(1), coords(2), num2str(count));
        end
        lline=count;
    end
    if ((lline>0)&&(lline~=count))
        herzdata2(dcount,2)=lline;
        lline=0;
    end
end
if ((herzdata2(size(herzdata2, 1), 2)==0)&&(herzdata2(1,1)~=0))
    herzdata2(size(herzdata2, 1), 2)=size(herz2,1);
end
%lfclose(fid);
disp('Plotting flight 3...');
lline=-1;
count=0;
dcount=0;
herzdata3=[0 0];
%data2011c='/data/phil/bering/herzfeldlab/flight2_16_51_00.dat';
%data2011c='/data/phil/bering/herzfeldlab/crossoversegs/flight2_16_51_00_a1.txt.extract';
%data2011c='/data/phil/bering/herzfeldlab/crossoversegs/flight2_16_51_00_a2.txt.extract';
%data2011c='/data/phil/bering/herzfeldlab/crossoversegs/flight2_16_51_00_a3.txt';
%fid=lfopen(data2011c);

for i=1:size(herz3, 1)
    coords=herz3(i, 1:2);
    count=count+1;
    if (pointinarea([coords(1) coords(2)], area))
        %plot(coords(1), coords(2), 'mo')
        if (lline<1)
            dcount=dcount+1;
            herzdata3(dcount, 1)=count;
            %text(coords(1), coords(2), num2str(count));
        end
        lline=count;
    end
    if ((lline>0)&&(lline~=count))
        herzdata3(dcount,2)=lline;
        lline=0;
    end
end
if ((herzdata3(size(herzdata3, 1), 2)==0)&&(herzdata3(1,1)~=0))
    herzdata3(size(herzdata3, 1), 2)=size(herz3,1);
end
%lfclose(fid);
disp('Plotting flight 4...');
lline=-1;
count=0;
dcount=0;
herzdata4=[0 0];
%data2011d='/data/phil/bering/herzfeldlab/flight2_17_15_00.dat.deg';
%data2011d='/data/phil/bering/herzfeldlab/crossoversegs/flight2_17_15_00a2.txt.extract';
%data2011d='/data/phil/bering/herzfeldlab/crossoversegs/flight2_17_15_00_a3.txt';
%fid=lfopen(data2011d);
%a_line=lfgetl(fid);
for i=1:size(herz4, 1)
    coords=herz4(i, 1:2);
    count=count+1;
    if (pointinarea([coords(1) coords(2)], area))
        %plot(coords(1), coords(2), 'ko')
        if (lline<1)
            dcount=dcount+1;
            herzdata4(dcount, 1)=count;
            %text(coords(1), coords(2), num2str(count));
        end
        lline=count;
    end
    if ((lline>0)&&(lline~=count))
        herzdata4(dcount,2)=lline;
        lline=0;
    end
end
if ((herzdata4(size(herzdata4, 1), 2)==0)&&(herzdata4(1,1)~=0))
    herzdata4(size(herzdata4, 1), 2)=size(herz4,1);
end

disp('Plotting corrected data...');
lline=-1;
count=0;
dcount=0;
topdata=[0 0];
for i=1:size(all_tops, 1)
    coords=all_tops(i, 1:2);
    count=count+1;
    if (pointinarea([coords(1) coords(2)], area))
        %plot(coords(1), coords(2), 'g.', 'color', [.2 .5 .40])
        if (lline<1)
            dcount=dcount+1;
            topdata(dcount, 1)=count;
            %text(coords(1), coords(2), num2str(count));
        end
        lline=count;
    end
    if ((lline>0)&&(lline~=count))
        topdata(dcount,2)=lline;
        lline=0;
    end
end
if ((topdata(size(topdata, 1), 2)==0)&&(topdata(1,1)~=0))
    topdata(size(topdata, 1), 2)=size(all_tops,1);
end

%lfclose(fid);
hold off;