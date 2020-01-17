function varargout = CalibratetheCamera(varargin)
% CALIBRATETHECAMERA MATLAB code for CalibratetheCamera.fig
%      CALIBRATETHECAMERA, by itself, creates a new CALIBRATETHECAMERA or raises the existing
%      singleton*.
%
%      H = CALIBRATETHECAMERA returns the handle to a new CALIBRATETHECAMERA or the handle to
%      the existing singleton*.
%
%      CALIBRATETHECAMERA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATETHECAMERA.M with the given input arguments.
%
%      CALIBRATETHECAMERA('Property','Value',...) creates a new CALIBRATETHECAMERA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalibratetheCamera_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalibratetheCamera_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalibratetheCamera

% Last Modified by GUIDE v2.5 11-Jan-2020 19:35:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalibratetheCamera_OpeningFcn, ...
                   'gui_OutputFcn',  @CalibratetheCamera_OutputFcn, ...
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


% --- Executes just before CalibratetheCamera is made visible.
function CalibratetheCamera_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalibratetheCamera (see VARARGIN)

% Choose default command line output for CalibratetheCamera
handles.output = hObject;

set(handles.uipanel2, 'visible', 'on');
handles.VidObj = videoinput('winvideo', 2, 'I420_160x120');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CalibratetheCamera wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CalibratetheCamera_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in StartStopCamera.
function StartStopCamera_Callback(hObject, eventdata, handles)
% hObject    handle to StartStopCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
samples = str2double(get(handles.edit1, 'String'));
times = str2double(get(handles.edit3, 'String'));
if strcmp(get(handles.StartStopCamera,'String'),'Start Camera')
    set(handles.StartStopCamera,'String','Stop Camera')
    set(handles.uipanel2, 'visible', 'off');
    set(handles.edit1,'Enable','on');
    set(handles.edit3,'Enable','on');
    set(handles.TakeSampleImages,'Enable','on');
    set(handles.edit4,'Enable','off');
    set(handles.StartCalibration,'Enable','off');    
    VidROI = get(handles.VidObj, 'ROIPosition');
    nBands = get(handles.VidObj, 'NumberofBands');
    axes(handles.axes1);
    handles.hImage  = image(zeros(VidROI(4), VidROI(3), nBands));
    preview(handles.VidObj, handles.hImage);
else
    set(handles.StartStopCamera,'String','Start Camera')
    set(handles.uipanel2, 'visible', 'on');
    set(handles.edit1,'Enable','off');
    set(handles.edit3,'Enable','off');
    set(handles.TakeSampleImages,'Enable','off');
    if (samples > 0 && times > 0)
        set(handles.edit4,'Enable','on');
        set(handles.StartCalibration,'Enable','on');
    end    
    closepreview(handles.VidObj);
end 


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in TakeSampleImages.
function TakeSampleImages_Callback(hObject, eventdata, handles)
% hObject    handle to TakeSampleImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start(handles.VidObj);
set(handles.VidObj, 'ReturnedColorspace', 'rgb');
handles.VidObj.FrameGrabInterval = 0.5;
folder = 'C:\Users\ASUS\Desktop\BitirmeTezi_140207098_EffenciogaPutraYanra\sampleImages';  % set the folder
nametemplate = 'image_%d.png';  %name pattern
imnum = 0;        %starting image number
samples = str2double(get(handles.edit1, 'String')); %specify how many samples you need
times = str2double(get(handles.edit3, 'String')); % set timer in second
if(samples > 0 && times > 0)
    set(handles.StartStopCamera,'Enable','off');
    for K = 1 : samples 
        imgOrig = getsnapshot(handles.VidObj);
        imnum = imnum + 1;
        thisfile = sprintf(nametemplate, imnum);  %create filename
        fullname = fullfile(folder, thisfile);  %folder and all
        imwrite( imgOrig, fullname);  %write the image there as PNG
        pause(times); 
        warndlg(num2str(K), 'Captured Images');
    end
    if(K == samples)
        set(handles.StartStopCamera,'Enable','on');
    end
    % close preview
    closepreview(handles.VidObj);
    % stop the aquisition
    stop(handles.VidObj);
    pause(2);
    msgbox('All samples are succesfully taken, calibration can be started');
else
    stop(handles.VidObj);
    warndlg('Number of samples and capturing interval must be greater than 0');   
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


% --- Executes on button press in StartCalibration.
function StartCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to StartCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
squareSize = str2double(get(handles.edit4, 'String')); % in millimeters
if (squareSize > 0)
    set(handles.StartStopCamera,'Enable','off');
end;
calibration = 0;
if(squareSize > 0)
    set(handles.StartStopCamera,'Enable','off');
    set(handles.uipanel2, 'visible', 'on');
    % *Create a set of calibration images* .
    images = imageDatastore(fullfile('C:\Users\ASUS\Desktop\BitirmeTezi_140207098_EffenciogaPutraYanra\samplesImages'));

    % Detect the checkerboard corners in the images.
    [imagePoints, boardSize] = detectCheckerboardPoints(images.Files);
   
    % Generate the world coordinates of the checkerboard corners in the
    % pattern-centric coordinate system, with the upper-left corner at (0,0).
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
   
    % Calibrate the camera.
    I = readimage(images,1);
    imageSize = [size(I, 1), size(I, 2)];
    cameraParams = estimateCameraParameters(imagePoints, worldPoints, 'ImageSize', imageSize);
            
    % Undistort image.
    [im, newOrigin] = undistortImage(I, cameraParams, 'OutputView', 'full');
   
    % Find reference object in new image.
    [imagePoints, boardSize] = detectCheckerboardPoints(im);
   
    % Compensate for image coordinate system shift.
    imagePoints = bsxfun(@plus, imagePoints, newOrigin);
   
    % Compute new extrinsics.
    [R,t] = extrinsics(imagePoints, worldPoints, cameraParams);

    % Show Intrinsic and Extrinsic Parameters
    set(handles.text6, 'visible', 'on');
    set(handles.uitable2, 'visible', 'on', 'Data', cameraParams.IntrinsicMatrix);
    set(handles.text7, 'visible', 'on');
    set(handles.uitable3, 'visible', 'on', 'Data', R);
    set(handles.text8, 'visible', 'on');
    set(handles.uitable4, 'visible', 'on', 'Data', t);

    % save the file
    CalibrationData1.IntrinsicMatrix = cameraParams;
    CalibrationData1.RotationalMatrix = R;
    CalibrationData1.TranslationVectors = t;
    save(fullfile('C:\Users\ASUS\Desktop\BitirmeTezi_140207098_EffenciogaPutraYanra\CalibrationData'));

    msgbox('Camera calibration has been succesfully done, intrinsic and extrinsic parameters are saved');
    calibration = 1;    
    if(calibration == 1)
        set(handles.StartStopCamera,'Enable','on');
    end
else
    warndlg('Square size must be greater than 0');
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
