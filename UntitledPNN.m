clc;clear  all;close all;
load('TestResult1.mat')
rate=0.28;
% cv    = cvpartition(size(output1,1),'HoldOut',0.3);
% idx = cv.test;
% output1 = output1(~idx,:);
% Labal = Labal(~idx,:);

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
T = ind2vec( Labal(~idx,1)');
X=X(idx,:);
Labal_R= Labal(idx,1);
net_R_PNN= newpnn(X_train',T);
Y = sim(net_R_PNN,X');
YR = vec2ind(Y);
Acc_R= sum(YR==Labal_R')/length(YR);
[TTT_Right]=  AccurcyTable4_9(Labal_R',YR)


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
T = ind2vec( Labal(~idx,2)');
X=X(idx,:);
Labal_L= Labal(idx,2);
net_L_PNN= newpnn(X_train',T);
Y = sim(net_L_PNN,X');
YL = vec2ind(Y);
Acc_L= sum(YL==Labal_L')/length(YL);
[TTT_left]=  AccurcyTable4_9(Labal_L',YL)
 T=perfoemence_all  (TTT_left,TTT_Right);

classR=[ YR' Labal_R  ];
classL=[YL' Labal_L];

disp(['Accurcy of  rgith eye ' num2str(Acc_R) ]);
disp(['Accurcy of  lefteye '  num2str(Acc_L)]);
Accurcy= (Acc_L+Acc_R)/2;

clc;
 T=perfoemence_all  (TTT_left,TTT_Right);
 view (net_L_PNN);view (net_R_PNN);