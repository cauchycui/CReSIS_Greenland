function [ longlines ] = findlonglines( lines, fac )
%findlonglines reconstructs line numbers from a file thats been made
%short with makeshort
fac=10^fac;
for i=1:size(lines, 1)
    if (((lines(i,1)-1)*fac)>0)
        lines(i, 1)=(lines(i,1)-1)*fac;
    else
        lines(i, 1)=1;
    end
    lines(i, 2)=(lines(i,2)+1)*fac;
end
longlines=lines;
end

