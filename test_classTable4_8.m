clc ;clear all;
% load('classNN.mat')
% load('classPNN.mat')
load('classCNN1.mat')
% load('classKNN.mat')
class=double(classR);
 NN= sum((class(:,1)==1 & class(:,2)==1));
 NL= sum((class(:,1)==2 & class(:,2)==1));
 NR= sum((class(:,1)==3 & class(:,2)==1));
 
 LN= sum((class(:,1)==1 & class(:,2)==2));
 LL= sum((class(:,1)==2 & class(:,2)==2));
 LR= sum((class(:,1)==3 & class(:,2)==2));
 
 RN= sum((class(:,1)==1 & class(:,2)==3));
 RL= sum((class(:,1)==2 & class(:,2)==3));
 RR= sum((class(:,1)==3 & class(:,2)==3));
 listR =[NN NR NL  ;RN RR RL ; LN LR LL   ];
 
 %% 
 
 class=double(classL);
 NN= sum((class(:,1)==1 & class(:,2)==1));
 NL= sum((class(:,1)==2 & class(:,2)==1));
 NR= sum((class(:,1)==3 & class(:,2)==1));
 
 LN= sum((class(:,1)==1 & class(:,2)==2));
 LL= sum((class(:,1)==2 & class(:,2)==2));
 LR= sum((class(:,1)==3 & class(:,2)==2));
 
 RN= sum((class(:,1)==1 & class(:,2)==3));
 RL= sum((class(:,1)==2 & class(:,2)==3));
 RR= sum((class(:,1)==3 & class(:,2)==3));
 listL =[NN NR NL  ;RN RR RL ; LN LR LL   ];
