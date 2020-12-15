clc ;clear all;close all;warning('off');
uiwait(msgbox('Select the file'));
D= uigetdir(path);S = dir(fullfile(D,'*.jpg'));
output1=[];
Labal=[];
for k = 1:numel(S)
% try
   k 
    F = fullfile(D,S(k).name);
[filepath,name,ext] = fileparts(F);
I=imread(F);
I= rgb2gray(I);I1=I;
I = imresize(I,[256 256]); 
subplot(2,2,1);imshow(I1);title('orginal image')
I = imgaussfilt(I,0.8);
subplot(2,2,2);
imshow(I);title('Enhancment Image')
EyeDetect_n = vision.CascadeObjectDetector('EyePairBig');
BB_N=step(EyeDetect_n,I1);
subImage_n = imcrop(I1, BB_N);
%% 
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,I);
subImage = imcrop(I, BB);
subplot(2,3,4);
imshow(subImage_n);title('segmentatio the eye')
[rn cn] = size (subImage_n);
EyeImageRightn =subImage_n(:,1:fix(cn/2)); 
EyeImageLeftn =subImage_n(:,fix(cn/2)+1:end);
r = rn/4;sVal = 0.93;
[centersRn, radiiRn, ~] = imfindcircles(EyeImageRightn, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
[centersLn, radiiLn, ~] = imfindcircles(EyeImageLeftn, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
subplot(2,3,6);
imshow(EyeImageLeftn);title('crop the Left eye')

viscircles(centersLn, radiiLn,'EdgeColor','g');
subplot(2,3,5);
imshow(EyeImageRightn);title('crop the Right eye');
viscircles([centersRn(1) centersRn(2)] , radiiRn,'EdgeColor','g');
%% 
[r1 c] = size (subImage);
EyeImageRight =subImage(:,1:fix(c/2)); 
EyeImageLeft =subImage(:,fix(c/2)+1:end);
EyeImageRight = imresize(EyeImageRight,[22 42]);
EyeImageLeft = imresize(EyeImageLeft ,[22 42]);
r = r1/4;sVal = 0.93;
[centersR, radii, ~] = imfindcircles(EyeImageRight, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
[centersL, radii, ~] = imfindcircles(EyeImageLeft, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
centersL(1)=centersL(1)-1;
centersR(1)=centersR(1)+1;
[r1 c1] = size (EyeImageRight);X1=abs(centersR(1));Y1=centersR(2);
[r2 c2] = size (EyeImageLeft);X2=abs(centersL(1)); Y2=centersL(2);
std_R= std2(EyeImageRight);mean_R=mean2(EyeImageRight);entropy_R=entropy(EyeImageRight);
std_L= std2(EyeImageLeft);mean_L=mean2(EyeImageLeft);entropy_L=entropy(EyeImageLeft);
output1=[output1;r1 c1 X1 Y1 r2 c2 X2 Y2  std_R std_L mean_R mean_L entropy_R entropy_L ];
Labal = [Labal  ;  str2num(name(1))  str2num(name(2))];

% saveas(gcf,['res/' name '.jpg']);
% imwrite(EyeImageRight,['TestEyeImageRight/3/' name  '.bmp'])
% imwrite(EyeImageLeft,['TestEyeImageLeft/1/' name '.bmp'])
% catch
%  imwrite(I1,['delet/33/' name '.jpg'])
%  delete(F);
% end
end
% save TestResult1  Labal output1
save TrainResult1  Labal output1
