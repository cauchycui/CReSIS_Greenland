%extract the coordinates out of the cresis kml file (might work for others,
%too)
i=1;
%progress bar initialization
if wait_bar
    lasttime=0;
    waitmode=0;
    %set up progress bar if wait length is long enough
    set(wbh, 'name', ['parsekmlstr saving data to ' outputroot dirname '...']);
else
    waitmode=1;
end
%12 characters are subtracted because due to kml formatting there is no
%possible coordinate data in 12 characters
file_length=length(kmlstring)-12;
while(i<file_length)
    if (kmlstring(i)=='<')
        if strcmp(kmlstring(i+1:i+12), 'coordinates>')
            coords=sscanf(kmlstring(i+13:size(kmlstring,2)), '%f,%f,%f');
            %if this fails, probably the data is not in triplets
            coords=reshape(coords, 3, size(coords,1)/3);
            coords=coords';
            %plot([coords(1,1) coords(size(coords,1),1)], [coords(1,2) coords(size(coords,1),2)], 'o', 'color', seg_color);
            %plot(coords(:, 1), coords(:, 2), 'color', seg_color);
            %counter=counter+size(coords,1);
            for k=1:size(coords,1)
                fprintf(fid, '%f %f %f\n', coords(k, :));
            end
        end
    end
    i=i+1;
    %progress bar code
    if ~mod(i,100)
        etime=toc;
        if (~waitmode&&(etime-lasttime>.2))
            progress=((progresssum+i)/charsum);
            esecs=mod(etime, 60);
            emins=mod(etime-esecs,3600)/60;
            ehours=etime-esecs-emins*60;
            waitbar(progress, wbh, [num2str(100*progress) '% done in '...
                num2str(ehours) ' hours, ' num2str(emins) ' minutes, and ' num2str(esecs) ' seconds']);
            lasttime=etime;
        elseif (etime-lasttime>30&&waitmode==1)
            disp([num2str(100*progress) '% done in ' num2str(etime) ' seconds'])
            lasttime=etime;
        end
    end
end
progresssum=progresssum+i;
