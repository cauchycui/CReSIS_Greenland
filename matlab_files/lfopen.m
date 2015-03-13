function lfid = lfopen( fullname )
%LFOPEN breaks large files into smaller files for use with lfgetl and
%lfclose

%split the file into smaller files with 100000 lines
[status, result] = system(['split -d -a 5 -l 100000 ' fullname ' ' fullname '.LFOPEN1']);
if(status)
    error(['split error: ' result]);
end
%find out how many files are made this way
[status, result] = system( ['ls -l ' fullname '.LFOPEN1* | wc -l']);
if (status)
    error(['wc error: ' result])
end
numfiles=sscanf(result, '%d');
if numfiles>100000
    error('That file is too big... recode lfopen')
end
%create a cell with the original full path name and with an array of fids
lfid={zeros(numfiles+1, 1) fullname};
lfid{1,1}(1)=2;
for i=1:numfiles
    partname=[fullname '.LFOPEN' num2str(i+99999)];
    lfid{1,1}(i+1)=fopen(partname);
end
end

