function varargout = ImageEnhancement(varargin)
% ImageEnhancement MATLAB code for ImageEnhancement.fig
%      ImageEnhancement, by itself, creates a new ImageEnhancement or raises the existing
%      singleton*.
%
%      H = ImageEnhancement returns the handle to a new ImageEnhancement or the handle to
%      the existing singleton*.
%
%      ImageEnhancement('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ImageEnhancement.M with the given input arguments.
%
%      ImageEnhancement('Property','Value',...) creates a new ImageEnhancement or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageEnhancement_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageEnhancement_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageEnhancement

% Last Modified by GUIDE v2.5 16-Jul-2020 13:38:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageEnhancement_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageEnhancement_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before ImageEnhancement is made visible.
function ImageEnhancement_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageEnhancement (see VARARGIN).
axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes4)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes5)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

% Choose default command line output for ImageEnhancement
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageEnhancement wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageEnhancement_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Im_target
global Im_source

global med
global mean
global gauss
global Br
global dr
global MSE1
global MSE2
global MSE3
global MSE4
global MSE5
global RMSE1
global RMSE2
global RMSE3
global RMSE4
global RMSE5
global PSNR1
global PSNR2
global PSNR3
global PSNR4
global PSNR5

%Reading the  image from the directory
T=imread(Im_target);
S=imread(Im_source);
Im_trg_d = im2double(T);
Im_src_d = im2double(S);
%% Correlated Color Space : RGB 
tic,
IR1= ColorTransfer(Im_trg_d,Im_src_d);  %Call the C-Color Transfer function ( source,target )
time=toc;
%% Results : 
[row,col,~] = size(IR1);

%% applying noise
Img_noise = imnoise(IR1,'salt & pepper',0.2);

%% applying the gaussian filter
gauss = imgaussfilt(Img_noise,2);

%% applying the mean filter

h = fspecial('average', [3 3]);
mean = imfilter(Img_noise, h);

%% applying grayscale
Im = rgb2gray(IR1);

%% Adjust Contrast
%Increase
Br = imadjust(IR1,[.2 .3 0; .6 .7 1],[]);
%Decrease
dr = imadjust(IR1,[.1 .1 0; .3 .4 1],[]);

%% Applying median filter
med = MedianFilter(Img_noise);

%% Image Scoring

MSE1 = sum(sum((IR1-med).^2))/(row*col);
RMSE1 = sqrt(MSE1);
PSNR1 = 10*log10(256*256/MSE1);

MSE2 = sum(sum((IR1-mean).^2))/(row*col);
RMSE2 = sqrt(MSE2);
PSNR2 = 10*log10(256*256/MSE2);

MSE3 = sum(sum((IR1-gauss).^2))/(row*col);
RMSE3 = sqrt(MSE3);
PSNR3 = 10*log10(256*256/MSE3);

MSE4 = sum(sum((IR1-Br).^2))/(row*col);
RMSE4 = sqrt(MSE4);
PSNR4 = 10*log10(256*256/MSE4);

MSE5 = sum(sum((IR1-dr).^2))/(row*col);
RMSE5 = sqrt(MSE5);
PSNR5 = 10*log10(256*256/MSE5);

%% display output
axes(handles.axes3)
imshow(IR1)
title('Enhanaced Color Image')

axes(handles.axes4)
imshow(Img_noise)
title('Noisy Image')

%% Write File
if exist('folder\Converted_Image', 'file')
   delete('folder\Converted_Image.jpg')        
end
imwrite(IR1,'Results\Converted_Image.jpg');

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global med
global mean
global gauss
global Br
global dr
global MSE1
global MSE2
global MSE3
global MSE4
global MSE5
global RMSE1
global RMSE2
global RMSE3
global RMSE4
global RMSE5
global PSNR1
global PSNR2
global PSNR3
global PSNR4
global PSNR5

val1 = get(handles.popupmenu1,'Value');

switch val1
        case 1
            Img_filter = med;
            set(handles.text7,'String',MSE1)
            set(handles.text8,'String',RMSE1)
            set(handles.text9,'String',PSNR1)
        case 2
            Img_filter = mean;
            set(handles.text7,'String',MSE2)
            set(handles.text8,'String',RMSE2)
            set(handles.text9,'String',PSNR2)
        case 3
            Img_filter = gauss;
            set(handles.text7,'String',MSE3)
            set(handles.text8,'String',RMSE3)
            set(handles.text9,'String',PSNR3)
        case 4
            Img_filter = Br;
            set(handles.text7,'String',MSE4)
            set(handles.text8,'String',RMSE4)
            set(handles.text9,'String',PSNR4)
        case 5
            Img_filter = dr;
            set(handles.text7,'String',MSE5)
            set(handles.text8,'String',RMSE5)
            set(handles.text9,'String',PSNR5)
    end

axes(handles.axes5)
imshow(Img_filter)
title('Enhanced Image')

%% Write File
if exist('folder\MedianFiltered_Image', 'file')
   delete('folder\MedianFiltered_Image.jpg')        
end
imwrite(med,'Results\MedianFiltered_Image.jpg');

if exist('folder\MeanFiltered_Image', 'file')
   delete('folder\MeanFiltered_Image.jpg')        
end
imwrite(mean,'Results\MeanFiltered_Image.jpg');

if exist('folder\GaussianFiltered_Image', 'file')
   delete('folder\GaussianFiltered_Image.jpg')        
end
imwrite(med,'Results\GaussianFiltered_Image.jpg');

if exist('folder\ContrastIncreased_Image', 'file')
   delete('folder\ContrastIncreased_Image.jpg')        
end
imwrite(Br,'Results\ContrastIncreased_Image.jpg');

if exist('folder\ContrastDecreased_Image', 'file')
   delete('folder\ContrastDecreased_Image.jpg')        
end
imwrite(dr,'Results\ContrastDecreased_Image.jpg');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Im_source
    [S,Im_source,~]=uigetfile('*.jpg','Pick Reference Image');
    Im_source=strcat(Im_source,S);
    axes(handles.axes2);
    imshow(Im_source)
    set(handles.reference_edit,'string',Im_source);


function reference_edit_Callback(hObject, eventdata, handles)
% hObject    handle to reference_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reference_edit as text
%        str2double(get(hObject,'String')) returns contents of reference_edit as a double


% --- Executes during object creation, after setting all properties.
function reference_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reference_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Im_target
    [T,Im_target,~]=uigetfile('*.jpg', 'Pick Target Image');
    Im_target = strcat(Im_target,T);
    axes(handles.axes1);
    imshow(Im_target)
    set(handles.source_edit,'string',Im_target);



function source_edit_Callback(hObject, eventdata, handles)
% hObject    handle to source_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of source_edit as text
%        str2double(get(hObject,'String')) returns contents of source_edit as a double


% --- Executes during object creation, after setting all properties.
function source_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to source_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Im_target
global med
global mean
global gauss
global Br
global dr
global MSE1
global MSE2
global MSE3
global MSE4
global MSE5
global RMSE1
global RMSE2
global RMSE3
global RMSE4
global RMSE5
global PSNR1
global PSNR2
global PSNR3
global PSNR4
global PSNR5

IR1=imread(Im_target);

[row,col,~] = size(IR1);
%% applying noise
Img_noise = imnoise(IR1,'salt & pepper',0.2);

%% applying the gaussian filter
gauss = imgaussfilt(Img_noise,2);

%% applying the mean filter

h = fspecial('average', [3 3]);
mean = imfilter(Img_noise, h);

%% applying grayscale
Im = rgb2gray(IR1);

%% Adjust Contrast
%Increase
Br = imadjust(IR1,[.2 .3 0; .6 .7 1],[]);
%Decrease
dr = imadjust(IR1,[.1 .1 0; .3 .4 1],[]);

%% Applying median filter
med = MedianFilter(Img_noise);

%% Image Scoring

MSE1 = sum(sum((IR1-med).^2))/(row*col);
RMSE1 = sqrt(MSE1);
PSNR1 = 10*log10(256*256/MSE1);

MSE2 = sum(sum((IR1-mean).^2))/(row*col);
RMSE2 = sqrt(MSE2);
PSNR2 = 10*log10(256*256/MSE2);

MSE3 = sum(sum((IR1-gauss).^2))/(row*col);
RMSE3 = sqrt(MSE3);
PSNR3 = 10*log10(256*256/MSE3);

MSE4 = sum(sum((IR1-Br).^2))/(row*col);
RMSE4 = sqrt(MSE4);
PSNR4 = 10*log10(256*256/MSE4);

MSE5 = sum(sum((IR1-dr).^2))/(row*col);
RMSE5 = sqrt(MSE5);
PSNR5 = 10*log10(256*256/MSE5);

%% display output
axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes4)
imshow(Img_noise)
title('Noisy Image')
