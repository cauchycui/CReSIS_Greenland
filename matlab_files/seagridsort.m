function [quad1, quad2, quad3, quad4]=seagridsort(data)
%sorts all the data into 100x100m boxes lined up with the searise grid
%NOTE: assumes searise coordinates mark lower left corner of a box
startsize=30;
clear quad1;
clear quad2;
clear quad3;
clear quad4;
%all quadrants assume indexing starts at 0
quad1{startsize,startsize}=[];
%quad1 contains all the 0s along its borders
quad2{startsize,startsize}=[];
%quad2 contains all 0s along along the 2-3 border
quad3{startsize,startsize}=[];
quad4{startsize,startsize}=[];
%quad4 contains all 0s along the 3-4 border
wbh=waitbar(0, '0% done');
set(wbh, 'name', 'seagridsort sorting data into a grid...');
for i=1:size(data,1)
    x=floor(data(i,1)/100);
    y=floor(data(i,2)/100);
    if (x>=0)&&(y>=0)
        x=x+1;
        y=y+1;
        if (x>=size(quad1,2))||(y>=size(quad1,1))
            quad1{x,y}=[];
        end
        quad1{x,y}=[quad1{x,y}; data(i,:)];
    elseif (x<0)&&(y>=0)
        x=x*-1;
        y=y+1;
        if (x>=size(quad2,2))||(y>=size(quad2,1))
            quad2{x,y}=[];
        end
        quad2{x,y}=[quad2{x,y}; data(i,:)];
    elseif (x<0)&&(y<0)
        x=x*-1;
        y=y*-1;
        if (x>=size(quad3,2))||(y>=size(quad3,1))
            quad3{x,y}=[];
        end
        quad3{x,y}=[quad3{x,y}; data(i,:)];
    elseif (x>=0)&&(y<0)
        y=y*-1;
        x=x+1;
        if (x>=size(quad4,2))||(y>=size(quad4,1))
            quad4{x,y}=[];
        end
        quad4{x,y}=[quad4{x,y}; data(i,:)];
    end
    progress=(i/size(data,1));
    waitbar(progress, wbh, [num2str(100*progress)...
            '% done']);
        if i==size(data,1);
            i
        elseif i>size(data,1);
            return;
        end
end
end