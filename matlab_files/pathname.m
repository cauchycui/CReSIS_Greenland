function [ path name ] = pathname( fullname )
%pathname Divides a full path and name into a path and name
i=size(fullname,2);
while(~strcmp(fullname(i), '/'))
    i=i-1;
end
name=fullname(i+1:size(fullname,2));
path=fullname(1:i);
end

