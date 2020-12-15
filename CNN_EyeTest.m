% % clc;clear all;close all;
function [Accurcy] =CNN_EyeTest();
 load('CNN_Train7.mat')
%  load('CNN_TrainR.mat')
%  load('CNN_TrainL.mat')
 analyzeNetwork(CNN_NetLeftEYE)
%% 
path= 'TestEyeImageRight'
data=imageDatastore(path,'IncludeSubfolders',true,'LabelSource','foldernames');
% data=imageDatastore (fullfile(matlabroot,'toolbox','matlab'),'IncludeSubfolders',true,'FileExtensions','.tif','LabelSource','foldernames')
Label= (data.Labels);
output= (classify(CNN_NetRightEYE,data));
accRight=sum(Label==output)/length(Label);
Performence_Right=    AccurcyTable4_9(double(Label),double(output))
accRight=sum(Label==output)/length(Label);
classR=[ output Label  ];

%% Left Eye
path= 'TestEyeImageLeft';
data=imageDatastore(path,'IncludeSubfolders',true,'LabelSource','foldernames');
Label= (data.Labels);
output= (classify(CNN_NetLeftEYE,data));
accLeft=sum(Label==output)/length(Label);
[performance_left]=    AccurcyTable4_9(double(Label),double(output))
classL=[output  Label];
% save classCNN classL classR
disp (['The Accurcy of  Right Image= ' num2str(accRight)]);
disp (['The Accurcy of  Left Image= ' num2str(accLeft)]);
Accurcy= (accRight+accLeft)/2;
disp (num2str(Accurcy))
% Header =["Accuracy" ; "TP"; "TN";  "FP";"FN" ; "Misclassification_Rate";...
%     "Specificity" ;"Precision" ;"Sensitive_Recall";"F1_Score"] ;
% perfoemence=(Performence_Right+performance_left)/2;
% perfoemence(2)=round(perfoemence(2));
% perfoemence(3)=round(perfoemence(3));
% perfoemence(4)=round(perfoemence(4));
% perfoemence(5)=round(perfoemence(5));
% clc;
% T = table(Header,perfoemence);
T=perfoemence_all  (Performence_Right,performance_left);
disp (T)