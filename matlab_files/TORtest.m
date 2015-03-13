fid=fopen('GLA06_05052016_r4203_428_L3C.dat.pond1.txt');
textscan(fid, '%s', 6);
sattrack=textscan(fid, '%f %f');
offsettrack=[];
textscan(fid, '%s', 2);
header{1,1}='anything';
while strcmp(header{1,1}, '%Mirror')~=1
    scanvar=textscan(fid, '%f %f');
    temptrack=scanvar{1, 1};
    temptrack(:, 2)=scanvar{1,2};
    offsettrack=[offsettrack; temptrack];
    header=textscan(fid, '%s', 2);
end
mirrortrack=[];
while numel(temptrack)>0
    scanvar=textscan(fid, '%f %f');
    temptrack=scanvar{1, 1};
    temptrack(:, 2)=scanvar{1,2};
    mirrortrack=[mirrortrack; temptrack];
    textscan(fid, '%s', 2);
end
fclose(fid);