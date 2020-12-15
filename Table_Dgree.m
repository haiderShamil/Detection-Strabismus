% clc ;clear all;close all;warning('off');
% uiwait(msgbox('Select the file'));
% D= uigetdir(path);S = dir(fullfile(D,'*.jpg'));
output1=[];
Labal=[];
ListCNN(1,:) = [{'No.'} {'Name'}  {'GxR'}  {'GxL'}  {'LabalR'}   {'LabalL)'} {'classT'}  {'YR_CNN'}  {'YL_CNN'} {'classT_CNN'} ];
ListDNN(1,:) = [{'No.'} {'Name'}  {'GxR'}  {'GxL'}  {'LabalR'}   {'LabalL)'} {'classT'}  {'YR_DNN'}  {'YL_DNN'} {'classT_DNN'} ];
ListPNN(1,:) = [{'No.'} {'Name'}  {'GxR'}  {'GxL'}  {'LabalR'}   {'LabalL)'} {'classT'}  {'YR_PNN'}  {'YL_PNN'} {'classT_PNN'} ];
List_kmean(1,:) = [{'No.'} {'Name'}  {'GxR'}  {'GxL'}  {'LabalR'}   {'LabalL)'} {'classT'}  {'YR_kmean'}  {'YL_kmean'} {'classT_kmean'} ];
List_ALL = [{'No.'} {'Name'}  {'GxR'}  {'GxL'}  {'LabalR'}   {'LabalL)'} {'classT'}  {'YR_CNN'}  {'YL_CNN'} {'classT_CNN'}  {'YR_DNN'}  {'YL_DNN'} {'classT_DNN'} {'YR_PNN'}  {'YL_PNN'} {'classT_PNN'}  {'YR_kmean'}  {'YL_kmean'} {'classT_kmean'} ];

for k = 1:numel(S)
% try
   k 
    F = fullfile(D,S(k).name);
[filepath,name,ext] = fileparts(F);
I=imread(F);
I= rgb2gray(I);I1=I;
I = imresize(I,[256 256]); 
subplot(2,2,1);imshow(I1);title('orginal image')
I = imgaussfilt(I,0.8);
subplot(2,2,2);
imshow(I);title('Enhancment Image')
EyeDetect_n = vision.CascadeObjectDetector('EyePairBig');
BB_N=step(EyeDetect_n,I1);
subImage_n = imcrop(I1, BB_N);
%% 
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,I);
subImage = imcrop(I, BB);
subplot(2,3,4);
imshow(subImage_n);title('segmentatio the eye')
[rn cn] = size (subImage_n);
EyeImageRightn =subImage_n(:,1:fix(cn/2)); 
EyeImageLeftn =subImage_n(:,fix(cn/2)+1:end);
r = rn/4;sVal = 0.93;
[centersRn, radiiRn, ~] = imfindcircles(EyeImageRightn, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
[centersLn, radiiLn, ~] = imfindcircles(EyeImageLeftn, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
subplot(2,3,6);
imshow(EyeImageLeftn);title('crop the Left eye')

viscircles(centersLn, radiiLn,'EdgeColor','g');
subplot(2,3,5);
imshow(EyeImageRightn);title('crop the Right eye');
viscircles([centersRn(1) centersRn(2)] , radiiRn,'EdgeColor','g');
%% 
[r1 c] = size (subImage);
EyeImageRight =subImage(:,1:fix(c/2)); 
EyeImageLeft =subImage(:,fix(c/2)+1:end);
EyeImageRight = imresize(EyeImageRight,[22 42]);
EyeImageLeft = imresize(EyeImageLeft ,[22 42]);
r = r1/4;sVal = 0.93;
[centersR, radii, ~] = imfindcircles(EyeImageRight, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
[centersL, radii, ~] = imfindcircles(EyeImageLeft, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
centersL(1)=centersL(1)-1;
centersR(1)=centersR(1)+1;
[r1 c1] = size (EyeImageRight);X1=abs(centersR(1));Y1=centersR(2);
[r2 c2] = size (EyeImageLeft);X2=abs(centersL(1)); Y2=centersL(2);
std_R= std2(EyeImageRight);mean_R=mean2(EyeImageRight);entropy_R=entropy(EyeImageRight);
std_L= std2(EyeImageLeft);mean_L=mean2(EyeImageLeft);entropy_L=entropy(EyeImageLeft);
output1=[r1 c1 X1 Y1 r2 c2 X2 Y2  std_R std_L mean_R mean_L entropy_R entropy_L ];
Labal = [  str2num(name(1))  str2num(name(2))];

[XR, XL,GxR,GxL]=  featureExtraction(output1);
classT = class_function(Labal(1),Labal(2)) ;
%% 

load('CNN_Train7.mat')
YR_cnn= double((classify(CNN_NetRightEYE,EyeImageRight)));
YL_cnn= double((classify(CNN_NetLeftEYE,EyeImageLeft)));
classT_CNN  = class_function(YR_cnn,YL_cnn) ;
%% 
load('net_NN_L.mat')
load('net_NN_R.mat')
%% 
YR_DNN= abs(round (net_NN_R(XR')));
YR_DNN(find(YR_DNN==0))=1;
YR_DNN(find(YR_DNN>3))=1;
%% 
YL_DNN= abs(round (net_NN_L (XL')));
YL_DNN(find(YL_DNN==0))=1;
YL_DNN(find(YL_DNN>3))=3;
classT_DNN = class_function(YR_DNN,YL_DNN)  ;
%% 
load('PNN_Net.mat')
%% 
Y = sim(net_R_PNN,XR');
YR_PNN = vec2ind(Y);
%% 
Y = sim(net_L_PNN,XL');
YL_PNN = vec2ind(Y);
classT_PNN = class_function(YR_PNN,YL_PNN)  ;
%% 
load   kmeancluster_Train
YR_kmean=  kmean_Singleimage('TrainEyeImageRight/',EyeImageRight,cluster_centersRight);
YL_kmean=  kmean_Singleimage('TrainEyeImageLeft/',EyeImageLeft, cluster_centersLeft);

classT_kmean = class_function(YR_kmean,YL_kmean)  ;
%% 

ListCNN(k+1,:) = [k {name}  GxR  GxL  Labal(1) Labal(2) {classT} YR_cnn YL_cnn {classT_CNN} ];
ListDNN(k+1,:) = [k {name}  GxR  GxL  Labal(1) Labal(2) {classT} YR_DNN YL_DNN {classT_DNN} ];
ListPNN(k+1,:) = [k {name}  GxR  GxL  Labal(1) Labal(2) {classT} YR_PNN YL_PNN {classT_PNN} ];
List_kmean(k+1,:)=[k {name}  GxR  GxL  Labal(1) Labal(2) { classT} YR_kmean YL_kmean {classT_kmean} ];
List_ALL(k+1,:)=[k {name}  GxR  GxL  Labal(1) Labal(2) { classT}  YR_cnn YL_cnn {classT_CNN} YR_DNN YL_DNN {classT_DNN}   YR_PNN YL_PNN {classT_PNN}  YR_kmean YL_kmean {classT_kmean} ];




end
xlswrite('dgree_Table_CNN', ListCNN);
xlswrite('dgree_Table_DNN', ListDNN);
xlswrite('dgree_Table_PNN', ListPNN);
xlswrite('dgree_Table_Kmean', List_kmean);
xlswrite('dgree_Table_ALL', List_ALL);