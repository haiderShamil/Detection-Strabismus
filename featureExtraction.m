function [XR, XL,GxR,GxL]=  featureExtraction(output1)
X1 = output1(:,2)/2;
X2 = output1(:,3);
Y1 =output1(:,1)/2; 
Y2 = output1(:,4);
GxR= X1 - X2;
%number of images
for i=1:length(X2)
    %Right eye
f1(i)= sqrt(((X2(i) - X1(i)).^ 2)+((Y2(i) - Y1(i)).^ 2));
f2(i)= sum_of_absolute_differences([X1(i),Y1(i)], [X2(i),Y2(i)]);
f3(i) = Minkowskis_distance_equation(X1(i),X2(i),Y1(i),Y2(i));
f4(i)= pdist([X1(i),X2(i); Y1(i),Y2(i)],'chebychev');
end
XR=[GxR f1' f2' f3' f4'  output1(:,9) output1(:,11) output1(:,13)] ;
% Left eye
X1 = output1(:,6)/2;
X2 = output1(:,7);
Y1 = output1(:,5)/2;
Y2 = output1(:,8);
GxL=X1-X2;
for i=1:length(X2)
f1(i)= sqrt(((X2(i) - X1(i)).^ 2)+((Y2(i) - Y1(i)).^ 2));
f2(i)= sum_of_absolute_differences([X1(i),Y1(i)], [X2(i),Y2(i)]);
f3(i) = Minkowskis_distance_equation(X1(i),X2(i),Y1(i),Y2(i));
f4(i)= pdist([X1(i),X2(i); Y1(i),Y2(i)],'chebychev');
end
XL=[GxL f1' f2' f3' f4'  output1(:,10) output1(:,12) output1(:,14)] ;
