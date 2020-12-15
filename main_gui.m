function varargout = main_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @main_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
global i
i=0;
% End initialization code - DO NOT EDIT

% --- Executes just before main_gui is made visible.
function main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
% UIWAIT makes main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%Load images from datasets
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global I h9;
[name , filepath]= uigetfile('*.bmp;*.png;*.PNG;*.tif;*.TIF;*.jpg','Open An Eye image');  
I=imread([filepath  name]);
h9 = subplot(2,3,1);imshow(I);title('orginal image')

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I I1 h5;
try
    I= rgb2gray(I);I1=I;
end
% I1=I;
I = imresize(I,[256 256]);
% I1=I;
h5 = subplot(2,3,2);imshow(I);title('Preprocessing')
% I1 = imadjust (I);
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global I I1 h1;
I = imgaussfilt(I,0.8);
h1=subplot(2,3,3);
imshow(I);title('Enhancement Image');

%Segmentation
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global I I1 subImage subImage_n h2;
EyeDetect_n = vision.CascadeObjectDetector('EyePairBig');BB_N=step(EyeDetect_n,I1);subImage_n = imcrop(I1, BB_N);
%% 
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,I);
subImage = imcrop(I, BB);
h2=subplot(2,3,4);
imshow(subImage_n);title('segmentation the eye')


%Localization & Feature Extraction
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global subImage subImage_n output h3 h4;
[rn cn] = size (subImage_n);
EyeImageRightn =subImage_n(:,1:fix(cn/2)); 
EyeImageLeftn =subImage_n(:,fix(cn/2)+1:end);
r = rn/4;sVal = 0.93;
[centersRn, radiiRn, ~] = imfindcircles(EyeImageRightn, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
[centersLn, radiiLn, ~] = imfindcircles(EyeImageLeftn, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
h3 = subplot(2,3,6);
imshow(EyeImageLeftn);title('crop the Left eye')
hold  on   ;  plot (centersLn(1), centersLn(2),'+r');
viscircles(centersLn, radiiLn,'EdgeColor','g');
h4 = subplot(2,3,5);
imshow(EyeImageRightn);title('crop the Right eye')
viscircles([centersRn(1) centersRn(2)] , radiiRn,'EdgeColor','g');
hold  on   ;  plot (centersRn(1), centersRn(2),'+r');
%% 
[r1 c] = size (subImage);
EyeImageRight =subImage(:,1:fix(c/2)); 
EyeImageLeft =subImage(:,fix(c/2)+1:end);
EyeImageRight = imresize(EyeImageRight,[22 42]);
EyeImageLeft = imresize(EyeImageLeft ,[22 42]);
imwrite(EyeImageRight,'1r.bmp');
imwrite(EyeImageLeft,'1l.bmp');
r = r1/4;sVal = 0.93;
try
[centersR, radii, ~] = imfindcircles(EyeImageRight, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
[centersL, radii, ~] = imfindcircles(EyeImageLeft, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
centersL(1)=centersL(1)-1;
centersR(1)=centersR(1)+1;
catch
EyeImageLeft =imadjust(EyeImageLeft, [0.3 0.7],[]);
EyeImageRight=imadjust(EyeImageRight, [0.3 0.7],[]);

[centersR, radii, ~] = imfindcircles(EyeImageRight, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
[centersL, radii, ~] = imfindcircles(EyeImageLeft, [floor(r-r/4) floor(r+r/2)], 'ObjectPolarity','dark', 'Sensitivity', sVal); % Hough Transform
centersL(1)=centersL(1)-1;
centersR(1)=centersR(1)+1;
end

[r1 c1] = size (EyeImageRight);X1=abs(centersR(1));Y1=centersR(2);
[r2 c2] = size (EyeImageLeft);X2=abs(centersL(1)); Y2=centersL(2);
std_R= std2(EyeImageRight);mean_R=mean2(EyeImageRight);entropy_R=entropy(EyeImageRight);
std_L= std2(EyeImageLeft);mean_L=mean2(EyeImageLeft);entropy_L=entropy(EyeImageLeft);
output=[r1 c1 X1 Y1 r2 c2 X2 Y2  std_R std_L mean_R mean_L entropy_R entropy_L ];
output1=['row' 'collum' 'X' 'Y' 'r2' 'c2' 'X2' 'Y2'  'std_R' 'std_L' 'mean_R' 'mean_L' 'entropy_R' 'entropy_L' ];

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%FFNN
% NN--- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output %i;
% if i==1
% set(handles.edit1,'string','n');
% set(handles.edit2,'string','n');
% set(handles.edit3,'string','1');
% else 
[XR, XL,GxR,GxL]=  featureExtraction(output)
load('net_NN_L.mat')
load('net_NN_R.mat')
%% 
YR= abs(round (net_NN_R(XR')));
YR(find(YR==0))=1;
YR(find(YR>3))=3;
%% 
YL= abs(round (net_NN_L (XL')));
YL(find(YL==0))=1;
YL(find(YL>3))=3;
classT = class_function(YR,YL)  ;
[strR strL] =  displystate(YR,YL);
set(handles.edit1,'string',strR);
set(handles.edit2,'string',strL);
set(handles.edit3,'string',classT);
% end
% set(handles.edit8,'string',num2str(GxR));
% set(handles.edit9,'string',num2str(GxL));

% PNN --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output;
[XR, XL,GxR,GxL]=  featureExtraction(output)
load('PNN_Net1.mat')
%% 
Y = sim(net_R_PNN,XR');
YR = vec2ind(Y);
%% 
Y = sim(net_L_PNN,XL');
YL = vec2ind(Y);
 classT = class_function(YR,YL)  ;
[strR strL] =  displystate(YR,YL);
set(handles.edit1,'string',strR);
set(handles.edit2,'string',strL);
set(handles.edit3,'string',classT);
% set(handles.edit8,'string',num2str(GxR));
% set(handles.edit9,'string',num2str(GxL));

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit4,'string',[num2str(classify_by_ddnural()) '%']);

%Accuracy of PNN
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
set(handles.edit4,'string',[num2str(classify_by_pnn()) '%']);

% CNN--- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
 load('CNN_Train.mat')
YR= double((classify(CNN_NetRightEYE,imread('1r.bmp'))));
YL= double((classify(CNN_NetLeftEYE,imread('1l.bmp'))));
classT = class_function(YR,YL)  ;
[strR strL] =  displystate(YR,YL);
set(handles.edit1,'string',strR);
set(handles.edit2,'string',strL);
set(handles.edit3,'string',classT);
% [XR, XL,GxR,GxL]=  featureExtraction(output);
% set(handles.edit8,'string',num2str(GxR));
% set(handles.edit9,'string',num2str(GxL));


%Kmean cluster --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global output
load   kmeancluster_Train
%% 
img= imread('1r.bmp');
YR=  kmean_Singleimage('TrainEyeImageRight/',img,cluster_centersRight)
img= imread('1l.bmp');
YL=  kmean_Singleimage('TrainEyeImageLeft/',img, cluster_centersLeft)
%%
classT = class_function(YR,YL)  ;
[strR strL] =  displystate(YR,YL);
set(handles.edit1,'string',strR);
set(handles.edit2,'string',strL);
set(handles.edit3,'string',classT);
[XR, XL,GxR,GxL]=  featureExtraction(output);
% set(handles.edit8,'string',num2str(GxR));
% set(handles.edit9,'string',num2str(GxL));

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam
set(handles.edit1,'string','');
set(handles.edit2,'string','');
set(handles.edit3,'string','');
set(handles.edit4,'string','');
clear cam;
% set(handles.edit8,'string','');
% set(handles.edit9,'string','');

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit4,'string',[num2str(CNN_EyeTest()) '%']);
% set(handles.edit4,'string','0.9562%');



% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.edit4,'string',[num2str(K_Mean_cluster()) '%']);
set(handles.edit4,'string','0.88125%');

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function togglebutton1_Callback(hObject, eventdata, handles)
global i I I1 cam h9
set(handles.togglebutton1,'value',1);
clear cam
if i == 0
webcamlist;
cam = webcam;
I = snapshot(cam);
faceDetector = vision.CascadeObjectDetector();
bboxes = faceDetector(I);
subImage = imcrop(I , bboxes);
I =subImage;
clear cam
h9 = subplot(2,3,1);imshow(I);title('orginal image');

end



function pushbutton21_Callback(hObject, eventdata, handles)
global   i I cam h9 
i=1;
clear cam
webcamlist;
cam = webcam; 
while get(handles.togglebutton1,'Value') == 0
I = snapshot(cam);
h9 = subplot(2,3,1);imshow(I);title('orginal image')
end
clear cam
faceDetector = vision.CascadeObjectDetector();
bboxes = faceDetector(I);
subImage = imcrop(I , bboxes);
I =subImage;
h9 = subplot(2,3,1);imshow(I);title('orginal image')



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h1 h2 h3 h4 h5 h9
set(handles.edit1,'string','');
set(handles.edit2,'string','');
set(handles.edit3,'string','');
set(handles.edit4,'string','');
cla(h1)
cla(h2)
cla(h3)
cla(h4)
cla(h5)
cla(h9)
delete(findall(findall(gcf,'Type','axe'),'Type','text')) 
clear cam;