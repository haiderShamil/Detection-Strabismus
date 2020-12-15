% clc;clear all;close all;
function [Accurcy] = K_Mean_cluster()
%%Train
cluster_centersRight = Kmean_cluster('TrainEyeImageRight\');
cluster_centersLeft = Kmean_cluster('TrainEyeImageLeft\');

% load   kmeancluster_Train
% save kmeancluster_Train11  cluster_centersRight  cluster_centersLeft
%% Test
[classR ,AccR,TTT_Right]=  kmeanfuntest('TestEyeImageRight\',cluster_centersRight );
[classL ,AccL,TTT_left]=  kmeanfuntest('TestEyeImageLeft\',cluster_centersLeft);
% save classKNN classL classR
disp(['Accurcy of  rgith eye ' num2str(AccR) ]);
disp(['Accurcy of  lefteye '  num2str(AccL)]);
Accurcy= (AccL+AccR)/2;
disp(['Accurcy ' num2str(Accurcy) ]);
 clc;
 T=perfoemence_all  (TTT_left,TTT_Right);