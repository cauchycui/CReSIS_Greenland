function sortseadata( filename )
%SORTSEADATA Sorts data created by seagridsave.m uses a bubble sort
%algorithm to sort the data in filename. sorts the original file in a copy
%file by adding smallest values one by one and then overwrites the original
%file
%filename='/data/phil/searise/cresisboxes/try3.txt.short';
file_length=wc(filename);
tic

ofid=fopen([filename '.tmp'], 'w+');
if ofid==-1
    error(['cannot read temporary file ' filename '.sort'])
end
ifid=fopen(filename, 'r');
if ifid==-1
    error(['cannot overwrite file' filename])
end
tic
threshhold=[-inf -inf -inf -inf];   %determines the smallest value to ignore
%set up a progress bar
wbh=waitbar(0, '0% done');
set(wbh, 'name', ['sortseadata sorting data in ' filename '...']);
try
for i=1:file_length
    %initialize the new minvalue to always be overwritten on the first
    %compare
    minvalue=[inf inf inf inf];
    threshhold_count=0;
    for j=1:file_length
        %scan in a new line
        a_line=fgetl(ifid);
        data=sscanf(a_line, '%f', 4);
        if length(data)==4
            %check that the new line is greater than the threshhold
            if data(1)>threshhold(1)
                over_threshhold=true;
            elseif data(1)<threshhold(1)
                over_threshhold=false;
            else
                if data(2)>threshhold(2)
                    over_threshhold=true;
                elseif data(2)<threshhold(2)
                    over_threshhold=false;
                else
                    if data(4)>threshhold(4)
                        over_threshhold=true;
                    elseif data(4)<threshhold(4)
                        over_threshhold=false;
                    else
                        if data(3)>threshhold(3)
                            over_threshhold=true;
                        else
                            over_threshhold=false;
                            if data(3)==threshhold(3)
                                threshhold_count=threshhold_count+1;
                                if threshhold_count>1
                                    threshhold_count
                                    threshhold
                                end
                            end
                        end
                    end
                end
            end
            if over_threshhold
                %compare the data with x values prioritized over y values
                %prioritized over year--begin by determining whether the newly
                %read in value is greater than the current maxvalue
                lesser=true;
                if data(1)>minvalue(1)
                    lesser=false;
                elseif (data(1)==minvalue(1))
                    if data(2)>minvalue(2)
                        lesser=false;
                    elseif data(2)==minvalue(2)
                        if data(4)>minvalue(4)
                            lesser=false;
                        elseif data(4)==minvalue(4)
                            if data(3)>minvalue(3)
                                lesser=false;
                            elseif data(3)==minvalue(3)
                                disp('Warning: duplicate datapoints found')
                                threshhold
                                minvalue
                                data
                            end
                        end
                    end
                end
                %replace maxvalue if needed
                if lesser
                    minvalue=data;
                end
            end
        end
    end
    frewind(ifid);
    fprintf(ofid, '%d %d %f %d\n', minvalue(1), minvalue(2), minvalue(3), minvalue(4));
    threshhold=minvalue;
    progress=(i/file_length);
    etime=toc;
    if etime>=60
        etime=etime/60;
        tunit=' minutes';
    elseif etime>=3600
        etime=etime/3600;
        tunit=' hours';
    else
        tunit=' seconds';
    end
    waitbar(progress, wbh, [num2str(100*progress) '% done in ' num2str(etime) tunit]);
end
catch serror
disp(['Warning: error in line ' num2str(serror.stack.line) ':' serror.message])
i
j
a_line
end
fclose(ifid);
fclose(ofid);
etime=toc
% [status, result] = system( ['cp ' filename '.tmp ' filename]);
% if (status)
%     error(['cp error: ' result])
% end
% [status, result] = system( ['rm ' filename '.tmp']);
% if (status)
%     error(['rm error: ' result])
% end
close(wbh);
end
