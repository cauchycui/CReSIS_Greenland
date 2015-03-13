testm=zeros(561,301);
for m=1:561
    for n=1:301
        if compare(m,n)>-1&&compare(m,n)<1
            testm(m,n)=0;
        elseif compare(m,n)<-1
            testm(m,n)=-100;
        elseif compare(m,n)>1&&compare(m,n)<=1000
            testm(m,n)=100;
        elseif compare(m,n)>1000
            testm(m,n)=500;
        else
            testm(m,n)=compare(m,n);
        end
    end
end