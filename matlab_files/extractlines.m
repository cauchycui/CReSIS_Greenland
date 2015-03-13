function [ success_ratio ] = extractlines( varargin )

filename=varargin{1};
elines=varargin{2};
if isequal(elines, [0 0])
    display('No lines to extract, exiting...');
    return;
end
fidin=fopen(filename);
if (size(varargin,2)==3)
    fidout=fopen([filename '.' varargin{3}], 'w');
else
    fidout=fopen([filename '.extract'], 'w');
end
lines_extracted=0;
lin_num=1;
line_str=fgetl(fidin);
elines=sortrows(elines);
for lineset=1:size(elines,1)
    if elines(lineset,1)>elines(lineset,2)
        disp(['Invalid line set: lines ' elines(lineset,1) ' to ' ...
            elines(lineset,2) ' are ignored.'])
    else
        %get to the target line
        eatnum=elines(lineset, 1)-lin_num;
        for i=1:eatnum
            line_str=fgetl(fidin);
            lin_num=lin_num+1;
        end
        %read the given line set
        fprintf(fidout, '%s\n', line_str);
        lines_extracted=lines_extracted+1;
        readnum=elines(lineset,2)-elines(lineset,1);
        if readnum<0
            line_str=fgetl(fidin);
            while(ischar(line_str))
                fprintf(fidout, '%s\n', line_str);
                line_str=fgetl(fidin);
            end
            break;
        else
            for i=1:readnum
                line_str=fgetl(fidin);
                lin_num=lin_num+1;
                lines_extracted=lines_extracted+1;
                fprintf(fidout, '%s\n', line_str);
            end
        end
    end
end
planned_extractions=sum(elines(:,2))-sum(elines(:,1))+size(elines,1);
success_ratio=lines_extracted/planned_extractions;
fclose(fidin);
fclose(fidout);
end