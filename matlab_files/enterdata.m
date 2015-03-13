function [ resultmat ] = enterdata( filename )
%ENTERDATA enters data from a file into a matlab variable
disp('Checking file length...');
[status, result] = system( ['wc -l ' filename]);
if (status)
    disp('wc error')
    return;
end
linecount=sscanf(result, '%d');
disp([num2str(linecount) ' lines found'])
fid=fopen(filename);
a_line=fgetl(fid);
num_line=str2num(a_line);
resultmat=zeros(linecount, size(num_line,2));
count=0;
while(ischar(a_line))
    count=count+1;
    num_line=str2num(a_line); %#ok<*ST2NM>
    resultmat(count,:)=num_line;
    a_line=fgetl(fid);
    if (mod(count,500000)==0)
        percent=100*count/linecount;
        disp([num2str(count) '/' num2str(linecount) ' lines read in (' ...
            num2str(percent) '%)'])
    end
end
end
