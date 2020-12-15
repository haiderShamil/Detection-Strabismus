clc;clear all;close all;
load('TestResult.mat')
rate=0.28;
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
cv    = cvpartition(size(X,1),'HoldOut',rate);
idx = cv.test;
X_train =X(~idx,:);
T=Labal(~idx,1);
net = feedforwardnet(50);
net_NN_R = train(net,X_train',T');
YR= abs(round (net_NN_R(X')));
YR(find(YR==0))=1;
YR(find(YR>3))=1;
Acc_R= sum(YR==Labal(:,1)')/length(YR);
[TTT_Right]=  AccurcyTable4_9(Labal(:,1)',YR);
% Y = round (sim(net_NN_R ,X'));
% acc1=sum(Y==T')/length(T)
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
cv    = cvpartition(size(X,1),'HoldOut',rate);
idx = cv.test;
X_train =X(~idx,:);
T=Labal(~idx,2);
net = feedforwardnet(50);
net_NN_L = train(net,X_train',T')
YL= abs(round (net_NN_L (X')));
YL(find(YL==0))=1;
YL(find(YL>3))=3;
Acc_L= sum(YL==Labal(:,2)')/length(YL);
[TTT_left]=  AccurcyTable4_9(Labal(:,2)',YL);
classR=[ YR' Labal(:,1)  ];
classL=[YL' Labal(:,2)];
% % save classNN classL classR
disp(['Accurcy of  rgith eye ' num2str(Acc_R) ]);
disp(['Accurcy of  lefteye '  num2str(Acc_L)]);
Accurcy=  (Acc_R+Acc_L)/2;
% nntraintool
clc;
 T=perfoemence_all  (TTT_left,TTT_Right);
