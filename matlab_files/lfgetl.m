function [a_line lfid]= lfgetl( lfid )
%LFGETL Gets a line from a large file opened by lfopen

%get a line from the active part
a_line=fgetl(lfid{1}(lfid{1}(1)));

%if the active part is out of lines, check whether the active part is the
%last part. if there are subsequent parts, update the first number in the
%lfid{1} array to indicate which part is active. otherwise, return the
%empty line
if ((~ischar(a_line))&&(lfid{1}(1)~=size(lfid{1},1)))
    lfid{1}(1)=lfid{1}(1)+1;
    a_line=fgetl(lfid{1}(lfid{1}(1)));
end
end

