function cluster_centers = Kmean_cluster(path)

[L  Label]=calclatecorrlation1(path);
for  i=1:size(L,1)
    for j=1:i-1
        L(i,j)=0;
    end
end

T2 =calc_std (L)*100;
feature_vector=T2'; number_of_clusters=3; Kmeans_iteration=50;
[cluster_centers, data]  = km_fun(feature_vector, number_of_clusters, Kmeans_iteration);
cluster_centers=sort(cluster_centers);
 cluster_centers= cluster_centers*0.4;
