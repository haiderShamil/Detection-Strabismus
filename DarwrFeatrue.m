clc;clear all;close all;
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
XR=[Gx1 f1' f2' f3' f4'  output1(:,9) output1(:,11) output1(:,13)] ;
% Left eye
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
XL=[Gx2 f1' f2' f3' f4'  output1(:,10) output1(:,12) output1(:,14)] ;
Featuer1_GX=[XR(:,1) XL(:,1)];
Featuer2_ecludain=[XR(:,2) XL(:,2)];
Featuer3_sumabsulte=[XR(:,3) XL(:,3)];
Featuer4_Minkowskis=[XR(:,4) XL(:,4)];
Featuer5_chebychev=[XR(:,5) XL(:,5)];
% Featuer6_sumabsulte=[XR(:,3) XL(:,3)];
figure ;grid on;
plot(Featuer2_ecludain)
legend({'Right Eye',....
    'Left Eye'},...
    'FontSize',14,'TextColor','k')
ylabel('Euclidean Distance Value','FontSize',14 ,'FontWeight','bold','Color','k');
xlabel('Images','FontSize',14 ,'FontWeight','bold','Color','k');
%% Sum of Absolute Differences  
figure ;grid on;
plot(Featuer3_sumabsulte)
legend({'Right Eye',....
    'Left Eye'},...
    'FontSize',14,'TextColor','k')
ylabel('Sum of Absolute Differences Value','FontSize',14 ,'FontWeight','bold','Color','k');
xlabel('Images','FontSize',14 ,'FontWeight','bold','Color','k');
%% 
figure ;grid on;
plot(Featuer4_Minkowskis)
legend({'Right Eye',....
    'Left Eye'},...
    'FontSize',14,'TextColor','k')
ylabel('Minkowskis Distancee Value','FontSize',14 ,'FontWeight','bold','Color','k');
xlabel('Images','FontSize',14 ,'FontWeight','bold','Color','k');
%%
figure ;grid on;
plot(Featuer5_chebychev)
legend({'Right Eye',....
    'Left Eye'},...
    'FontSize',14,'TextColor','k')
ylabel('Chebyshev distanceValue','FontSize',14 ,'FontWeight','bold','Color','k');
xlabel('Images','FontSize',14 ,'FontWeight','bold','Color','k');
% %%
% figure ;grid on;
% plot(Featuer2_ecludain)
% legend({'Right Eye',....
%     'Left Eye'},...
%     'FontSize',14,'TextColor','k')
% ylabel('Euclidean Distance Value','FontSize',14 ,'FontWeight','bold','Color','k');
% xlabel('Images','FontSize',14 ,'FontWeight','bold','Color','k');