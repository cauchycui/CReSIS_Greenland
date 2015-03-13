function cleanlar( filename )
%UNTITLED Clean out the outliers from Larsen's 2010 Bering data
num_points=10000;
disp('Checking file length...');
[status, result] = system( ['wc -l ' filename]);
if (status)
    disp('wc error')
    return;
end
linecount=sscanf(result, '%d');
disp([num2str(linecount) ' lines found'])
count=0;
fid=fopen(filename);
fido=fopen([filename '.clean'], 'w');
meandata=zeros(floor(num_points/100), 1);
meanloc=zeros(floor(num_points/100),2);
a_line=fgetl(fid);
tic;
statuscount=1;
skippedcount=0;
extracount=0;
while (ischar(a_line))
%     %This part is somewhat useless as of now
%     for i=1:floor(num_points/100)
%         if ischar(a_line)
%             x=sscanf(a_line, '%f');
%             if size(x,2)<3
%                 skippedcount=skippedcount+1;
%                 disp(['Warning: line ' num2str(count+i) ' skipped']);
%             else
%                 meandata(i)=x(3);
%                 meanloc(i,1)=x(1);
%                 meanloc(i,2)=x(2);
%                 if size(x,2)>3
%                     extracount=extracount+1;
%                     disp(['Warning: line ' num2str(count+i) ' extra data ignored']);
%                 end
%             end
%             a_line=fgetl(fid);
%         else
%             meandata(i)=[];
%             meanloc(i,:)=[];
%         end
%     end
%     %Section above just calculates avg
%     avg=mean(meandata);
    maxcutoff=1600;
    for i=1:size(meandata,1)
        if (meandata(i)<maxcutoff)
            fprintf(fido, '%f %f %f\n', meanloc(i,1), meanloc(i,2), meandata(i));
        end
    end
    for i=floor(num_points/100):num_points
        if ischar(a_line)
            x=sscanf(a_line, '%f');
            if (x(3)<maxcutoff)
                fprintf(fido, '%s\n', a_line);
            end
            a_line=fgetl(fid);
            if (~ischar(a_line))
                disp(['end of file reached at ' num2str(i+count)])
                break
            end
        else
            break;
        end
    end
    perc=100*(i+count)/linecount;
    if (floor(perc)==5*statuscount)
        etime=toc;
        tic;
        disp(['Reached line ' num2str(i+count) '(' num2str(perc) '% in ' num2str(etime) ' seconds)'])
        statuscount=statuscount+1;
    end
    count=count+num_points;
end
disp([num2str(skippedcount) ' lines skipped and ' num2str(extracount)...
    ' lines of extra data ignored out of ' num2str(count+i) ' lines read.'])
end

