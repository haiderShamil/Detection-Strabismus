
function [List Label]  =calclatecorrlation1(path)

data=imageDatastore(path,'IncludeSubfolders',true,'LabelSource','foldernames');
namefile=data.Files;
Label= double(data.Labels);
for k = 1:numel(namefile)
   k
img1= imread(namefile{k});
for k1 = 1:numel(namefile)
img2= imread(namefile{k1});
List(k,k1) = corr2(img1,img2);
end
end