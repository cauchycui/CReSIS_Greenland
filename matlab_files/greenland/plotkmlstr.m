%extract the coordinates out of the cresis kml file (might work for others,
%too) and then plot them
i=1;
hold on
while(i<(size(kmlstring, 2)-12))
    if (kmlstring(i)=='<')
        if strcmp(kmlstring(i+1:i+12), 'coordinates>')
            coords=sscanf(kmlstring(i+13:size(kmlstring,2)), '%f,%f,%f');
            %if this fails, probably the data is not in triplets
            coords=reshape(coords, 3, size(coords,1)/3);
            coords=coords';
            plot([coords(1,1) coords(size(coords,1),1)], [coords(1,2) coords(size(coords,1),2)], 'o', 'color', seg_color);
            plot(coords(:, 1), coords(:, 2), 'color', seg_color);
            counter=counter+size(coords,1);
        end
    end
    i=i+1;
end
hold off 