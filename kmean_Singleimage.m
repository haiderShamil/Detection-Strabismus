% clc;clear all;
% load   kmeancluster_Train
% %% 
% img1= imread('1r.bmp');
% path='TrainEyeImageRight/';
% cluster_centers=cluster_centersRight;
 function Y=  kmean_Singleimage(path,img1, cluster_centers)

data=imageDatastore(path,'IncludeSubfolders',true,'LabelSource','foldernames');
namefile=data.Files;
for k1 = 1:numel(namefile)
img2= imread(namefile{k1});
List(1,k1) = corr2(img1,img2);
end
T2 =calc_std (List)*100;
T2=T2*0.31;
g(3)=pdist([cluster_centers(1);T2]);
g(2)=pdist([cluster_centers(2);T2]);
g(1)=pdist([cluster_centers(3);T2]);
[res Y]=min(g');
Y
