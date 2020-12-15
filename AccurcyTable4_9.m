% clc;clear all;close all
function [TTT]=    AccurcyTable4_9(Label,output)

 TP=sum(output==1 & Label==1);
 
 TN1=sum(output==2 & Label==2);
 TN2=sum(output==3 & Label==3) ;
  TN= TN1+ TN2;
  
 FP1=sum(output==2 & Label==1);
 FP2=sum(output==3 & Label==1);

 FP=FP1 +FP2;
 
 FN1=sum(output==1 & Label==2);
FN2=sum(output==1 & Label==3);
FN3=sum(output==2 & Label==3);
FN4=sum(output==3 & Label==2);

FN=FN1 +FN2+FN3 +FN4  ;



total=TP+TN+FP+FN
Accuracy = (TP+TN)/total ;
Misclassification_Rate = (FP+FN)/total ;
Sensitive_Recall = TP/(TP+FN);
Specificity= TN/(TN+FP);
Precision= TP /(TP+FP);
F1_Score =( 2*(Sensitive_Recall* Precision)) / (Sensitive_Recall + Precision);
TTT= [Accuracy ; TP; TN;  FP;FN ; Misclassification_Rate; Specificity ;Precision ;Sensitive_Recall;F1_Score] ;
disp(['Accuracy= '  num2str(Accuracy)]);
% disp(['Misclassification_Rate= '  num2str(Misclassification_Rate)]);
disp(['Specificity= '  num2str(Specificity)]);
% disp(['Precision= '  num2str(Precision)]);
disp(['Sensitive_Recall= '  num2str(Sensitive_Recall)]);
% disp(['F1_Score= '  num2str(F1_Score)]);





% TP=349;TN=124;FP=28;FN=69;%nn
% TP=383;TN=137;FP=41;FN=9;%pnn
% TP=125;TN=28;FP=4;FN=3;%CNN
% TP=372;TN=131;FP=10;FN=57;%kMEAN
