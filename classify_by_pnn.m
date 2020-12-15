% clc;clear all;close all;
function [Accurcy] =classify_by_pnn()
load('PNN_Net.mat')
load('TestResult.mat')
X1 = output1(:,2)/2;
X2 = output1(:,3);
Y1 =output1(:,1)/2; 
Y2 = output1(:,4);
Gx1= X1 - X2;
for i=1:length(X2)
f1(i)= sqrt(((X2(i) - X1(i)).^ 2)+((Y2(i) - Y1(i)).^ 2));
f2(i)= sum_of_absolute_differences([X1(i),Y1(i)], [X2(i),Y2(i)]);
f3(i) = Minkowskis_distance_equation(X1(i),X2(i),Y1(i),Y2(i));
f4(i)= pdist([X1(i),X2(i); Y1(i),Y2(i)],'chebychev');
end
X=[Gx1 f1' f2' f3' f4'  output1(:,9) output1(:,11) output1(:,13)] ;
T = ind2vec( Labal(:,1)');
Y = sim(net_R_PNN,X');
YR = vec2ind(Y);
Acc_R= sum(YR==Labal(:,1)')/length(YR);
[TTT_Right]=  AccurcyTable4_9(Labal(:,1)',YR)


%% Left eye
X1 = output1(:,6)/2;
X2 = output1(:,7);
Y1 = output1(:,5)/2;
Y2 = output1(:,8);
Gx2=X1-X2;
for i=1:length(X2)
f1(i)= sqrt(((X2(i) - X1(i)).^ 2)+((Y2(i) - Y1(i)).^ 2));
f2(i)= sum_of_absolute_differences([X1(i),Y1(i)], [X2(i),Y2(i)]);
f3(i) = Minkowskis_distance_equation(X1(i),X2(i),Y1(i),Y2(i));
f4(i)= pdist([X1(i),X2(i); Y1(i),Y2(i)],'chebychev');
end
X=[Gx2 f1' f2' f3' f4'  output1(:,10) output1(:,12) output1(:,14)] ;
T = ind2vec( Labal(:,2)');

Y = sim(net_L_PNN,X');
YL = vec2ind(Y);
Acc_L= sum(YL==Labal(:,2)')/length(YL);
[TTT_left]=  AccurcyTable4_9(Labal(:,2)',YL)
 T=perfoemence_all  (TTT_left,TTT_Right);
% class =  [YL' Labal(:,2)];
classR=[ YR' Labal(:,1)  ];
classL=[YL' Labal(:,2)];
% % save classPNN classL classR
disp(['Accurcy of  rgith eye ' num2str(Acc_R) ]);
disp(['Accurcy of  lefteye '  num2str(Acc_L)]);
Accurcy= (Acc_L+Acc_R)/2;
% length(YR)
% YR
% YL
% for i=1:length(YR)
%    if (YR(i)==1)&&(YL(i)==1)
%        classT(i)=1;
%    elseif (YR(i)==1)&&(YL(i)==2)
%        classT(i)=2;
%        elseif (YR(i)==1)&&(YL(i)==3)
%        classT(i)=3;
%        elseif (YR(i)==2)&&(YL(i)==1)
%        classT(i)=4;
%        elseif (YR(i)==2)&&(YL(i)==2)
%        classT(i)=5;
%        elseif (YR(i)==2)&&(YL(i)==3)
%        classT(i)=6;
%        elseif (YR(i)==3)&&(YL(i)==1)
%        classT(i)=7;
%        elseif (YR(i)==3)&&(YL(i)==2)
%        classT(i)=8;
%        elseif (YR(i)==3)&&(YL(i)==3)
%        classT(i)=9;
%    end
% end
clc;
%  T=perfoemence_all  (TTT_left,TTT_Right);
 view (net_L_PNN);view (net_R_PNN);