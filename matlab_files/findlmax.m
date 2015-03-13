function [ lmax ] = findlmax( dirname, ffilter )
% FINDLMAX finds the max number of lines of files in a directory. ffilter
% determines what files are counted

ffilter= 'Area*.txt';
dirname='/data/phil/searise/cresisboxes/try1/';
lmax=-1;
% tic;
% [status, result] = system('rm ~/documents/matlab_files/output.log');
% diary('~/documents/matlab_files/output.log')
try
if ~strcmp(dirname(size(dirname,2)),'/')
    dirname=[dirname '/'];
end
if strcmp(ffilter(size(ffilter,2)),'*')
    error('Wildcard endings not implemented yet');
end
wildinds=strfind(ffilter, '*');
%create the search string array
pat_num=size(wildinds,2)+1;
clear sstrs
sstrs{pat_num}=ffilter(wildinds(pat_num-1)+1:size(ffilter,2));
for i=pat_num-2:-1:1
    sstrs{i+1}=ffilter(wildinds(i)+1:wildinds(i+1)-1);
end
sstrs{1}=ffilter(1:wildinds(1)-1);
[status, result] = system( ['ls ' dirname]);
if (status)
    error(['ls error: ' result])
end
clear patmatch
for i=pat_num:-1:1
    patmatch{i}=strfind(result, sstrs{i});
end
for i=1:size(patmatch{1},2)
matched=true;
    patbeg=patmatch{1}(i);
    endind=find(patmatch{pat_num}>patbeg,1);
    if endind
        patend=patmatch{pat_num}(endind);
    else
        matched=false;
    end
    for j=2:pat_num-1
        if size(find((patmatch{j}>(patbeg+size(sstrs{i},2)))&&(patmatch{j}<(patend-size(sstrs{j},2))),1),2)==0
            matched=false;
        end
    end
    if matched
        filename=result(patbeg:patend+size(sstrs{pat_num},2)-1);
        [status, wcresult] = system( ['wc -l ' dirname filename]);
        if (status)
            error(['wc error: ' result])
        end
        l=str2double(wcresult(1));
        if l>lmax
            lmax=l;
        end
    end
end
    totaltime=toc;
    esecs=mod(totaltime, 60);
    emins=mod(totaltime-esecs,3600)/60;
    ehours=totaltime-esecs-emins*60;
    disp([num2str(ehours) ' hours, ' num2str(emins) ' minutes, and ' num2str(esecs) ' seconds elapsed finding lmax']);
catch scripterror
    disp(scripterror.message)
%     totaltime=toc;
%     esecs=mod(totaltime, 60);
%     emins=mod(totaltime-esecs,3600)/60;
%     ehours=(totaltime-esecs-emins*60)/3600;
%     disp([num2str(ehours) ' hours, ' num2str(emins) ' minutes, and ' num2str(esecs) ' seconds elapsed before error']);
end

%diary('off');
%TRY USING GREP
