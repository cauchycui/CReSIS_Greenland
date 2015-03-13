% %filename1='/data/phil/bering/larsen/BeringBagley_2010_233.txt';
fullname2='/data/phil/bering/herzfeldlab/crossoversegs/herzfelda3.txt';
filename2='herzfelda3.txt';
fullname1='/data/phil/bering/herzfeldlab/crossoversegs/larsena3.txt';
filename1='larsena3.txt';
path='/data/phil/bering/';
% %Narrow the dataset
disp('Checking file lengths...');
[status, result] = system( ['wc -l ' fullname1]);
if (status)
    disp('wc error')
    return;
end
linecount1=sscanf(result, '%d');
[status, result] = system( ['wc -l ' fullname2]);
if (status)
    disp('wc error')
    return;
end
linecount2=sscanf(result, '%d');
%find the number of reductions needed to reduce the two files to length
%~10000
loops1=ceil(floor(log10(linecount1)-4)/3);
loops2=ceil(floor(log10(linecount2)-4)/3);
%make a directory to store all the temporary files created
[status, result]=system(['mkdir ' path 'temp']);
tmppath=[path 'temp/'];
disp('Sampling the data sets as necessary...');
%make the neccessarry temporary files
if loops1==0
    short1=fullname1;
else
    for i=1:loops1
        short1=[tmppath filename1 '.short' num2str(i)];
        makeshort(fullname1, 3, short1);
    end
end
percent=100*linecount1/(linecount1+linecount2);
display([num2str(percent) '% done sampling data sets...']);
if loops2==0
    short2=fullname2;
else
    for i=1:loops2
        short2=[tmppath filename2 '.short' num2str(i)];
        makeshort(fullname2, fac2, short2);
    end
end

disp('Finding overlapping data...');
%find the overlapping data for each shortened file, moving upwards until
%comparing extracts from the two original files
if loops1>loops2
    lloops=loops1;
    lfilename=filename1;
    lfullname=fullname1;
    lshort=short1;
    sloops=loops2;
    sfilename=filename2;
    sfullname=fullname2;
    sshort=short2;
else
    lloops=loops2;
    lfilename=filename2;
    lfullname=fullname2;
    lshort=short2;
    sloops=loops1;
    sfilename=filename1;
    sfullname=fullname1;
    sshort=short1;
end
tic;
for i=1:(sloops-1)
    elines=crossfind(sshort, lshort);
    selines=findlonglines(elines{1}, 3);
    lelines=findlonglines(elines{2}, 3);
    sshort=[tmppath sfilename '.short' num2str(sloops-i)];
    lshort=[tmppath lfilename '.short' num2str(sloops-i)];
    fextractlines(sshort, selines);
    fextractlines(lshort, lelines);
    sshort=[tmppath sfilename '.short' num2str(sloops-i) '.extract'];
    lshort=[tmppath lfilename '.short' num2str(sloops-i) '.extract'];
    etime=toc;
    tic;
    disp([num2str(i) ' of ' num2str(lloops) ' loops finished in ' num2str(etime) ' seconds']);
end
elines=crossfind(sshort, lshort);
sshort=[tmppath sfilename '.extract'];
lelines=findlonglines(elines{2}, 3);
lshort=[tmppath lfilename '.short' num2str(sloops-i)];
fextractlines(lshort, lelines);
lshort=[tmppath lfilename '.short' num2str(sloops-i) '.extract'];
if sloops>0
    i=i+1;
    selines=findlonglines(elines{1}, 3);
    fextractlines(sfullname, selines, sshort);
    etime=toc;
    tic;
    disp([num2str(i) ' of ' num2str(lloops) ' loops finished in ' num2str(etime) ' seconds']);
else
    fextractlines(sfullname, elines{1}, sshort);
end
for i=(sloops+1):(lloops-1)
    elines=crossfind(sshort, lshort);
    lelines=findlonglines(elines{2}, 3);
    lshort=[tmppath lfilename '.short' num2str(sloops-i)];
    fextractlines(lshort, lelines);
    lshort=[tmppath lfilename '.short' num2str(sloops-i) '.extract'];
    etime=toc;
    tic;
    disp([num2str(i) ' of ' num2str(lloops) ' loops finished in ' num2str(etime) ' seconds']);
end
elines=crossfind(sshort, lshort);
if lloops>0
    lelines=findlonglines(elines{2}, 3);
else
    lelines=elines{2};
end
fextractlines(sfullname, elines{1});
fextractlines(lfullname, lelines);
etime=toc;
disp([num2str(i) ' of ' num2str(lloops) ' loops finished in ' num2str(etime) ' seconds']);
disp('Plotting overlapping data...');

plotdif([fullname1 '.extract.extract'], [fullname2 '.extract.extract'], .02);