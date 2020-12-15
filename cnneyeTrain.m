clc;clear all;close all
 pathLeft='TrainEyeImageLeft';
dataLeft=imageDatastore(pathLeft,'IncludeSubfolders',true,'LabelSource','foldernames')
 pathRight='TrainEyeImageRight';
dataRight=imageDatastore(pathRight,'IncludeSubfolders',true,'LabelSource','foldernames')

layers=[imageInputLayer([22 42 1])
    convolution2dLayer(5,20)
    batchNormalizationLayer
    reluLayer
      maxPooling2dLayer(2,'stride',2)
    convolution2dLayer(5,20)
    batchNormalizationLayer
    reluLayer
   maxPooling2dLayer(2,'stride',2)
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer()];
options=trainingOptions('sgdm','MaxEpochs',150,'initialLearnRate',0.002,'Plots','training-progress');

% options=trainingOptions('sgdm','MaxEpochs',150,'initialLearnRate',0.002,'LearnRateDropFactor',0.2,'Plots','training-progress');

% options=trainingOptions('sgdm','MaxEpochs',150,'initialLearnRate',0.002, 'Verbose',false,'Plots','training-progress');

% CNN_NetLeftEYE  = trainNetwork(dataLeft,layers,options);
CNN_NetRightEYE = trainNetwork(dataRight,layers,options);

% %
% save   CNN_Train2  CNN_NetRightEYE   CNN_NetLeftEYE
% save   CNN_TrainR  CNN_NetRightEYE 
% save   CNN_TrainL  CNN_NetLeftEYE 