function [class ,Acc, TTT]=  kmeanfuntest(path,cluster_centers)
[L  Label]=calclatecorrlation1(path);
for  i=1:size(L,1)
    for j=1:i-1
        L(i,j)=0;
    end
end

T2 =calc_std (L)*100;
 feature_vector=T2';
for i=1:length(T2)
    g(i,3)=pdist([cluster_centers(1);T2(i)]);
    g(i,2)=pdist([cluster_centers(2);T2(i)]);
    g(i,1)=pdist([cluster_centers(3);T2(i)]);
end
[res resind]=min(g');
class=[resind'  Label ];
Acc= sum(class(:,1)==class(:,2))/length(class(:,1));
TTT=    AccurcyTable4_9(class(:,2),class(:,1))

