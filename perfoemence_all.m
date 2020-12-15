function T=perfoemence_all  (L ,R)
Header =["Accuracy" ; "TP"; "TN";  "FP";"FN" ; "Misclassification_Rate";...
    "Specificity" ;"Precision" ;"Sensitive_Recall";"F1_Score"] ;
perfoemence=(R+L)/2;
perfoemence(2)=R(2)+L(2);
perfoemence(3)=R(3)+L(3);
perfoemence(4)=R(4)+L(4);
perfoemence(5)=R(5)+L(5);
T = table(Header,perfoemence);
disp (T)