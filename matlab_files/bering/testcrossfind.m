slar=enterdata('/data/phil/bering/larsen/BeringBagley_2010_233.txt.short');
results=crossfind(slar, all_tops);
result1=results{1,1};
result2=results{1,2};
eslar=[];
for i=1:size(result1 ,1)
    eslar=[eslar; slar(result1(i, 1):result1(i,2), :)];
end

etops=[];
for i=1:size(result2 ,1)
    etops=[etops; all_tops(result2(i, 1):result2(i,2), :)];
end
figure;
hold on;
plot(slar(:,1), slar(:,2), 'b.');
plot(all_tops(:,1), all_tops(:,2), 'r.');
hold off;
title('pre-crossfind');
figure;
hold on;
plot(eslar(:,1), eslar(:,2), 'b.');
plot(etops(:,1), etops(:,2), 'r.');
hold off;
title('post-crossfind');