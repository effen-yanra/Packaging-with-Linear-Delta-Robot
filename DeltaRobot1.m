function varargout = DeltaRobot1(varargin)
% DELTAROBOT1 MATLAB code for DeltaRobot1.fig
%      DELTAROBOT1, by itself, creates a new DELTAROBOT1 or raises the existing
%      singleton*.
%
%      H = DELTAROBOT1 returns the handle to a new DELTAROBOT1 or the handle to
%      the existing singleton*.
%
%      DELTAROBOT1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELTAROBOT1.M with the given input arguments.
%
%      DELTAROBOT1('Property','Value',...) creates a new DELTAROBOT1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DeltaRobot1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DeltaRobot1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DeltaRobot1

% Last Modified by GUIDE v2.5 12-Jan-2020 16:14:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DeltaRobot1_OpeningFcn, ...
    'gui_OutputFcn',  @DeltaRobot1_OutputFcn, ...
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


% --- Executes just before DeltaRobot1 is made visible.
function DeltaRobot1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DeltaRobot1 (see VARARGIN)

% Choose default command line output for DeltaRobot1
handles.output = hObject;

set(handles.uipanel6, 'visible', 'on');
handles.VidObj = videoinput('winvideo', 2, 'I420_160x120');

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes DeltaRobot1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = DeltaRobot1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in START.
function START_Callback(hObject, eventdata, handles)
% hObject    handle to START (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Starting PLC using OPC
da = opcda('localhost', 'OPC.SimaticNET');
connect(da);
pause(.5)
grp = addgroup(da, 'DemoGroup');
itm8 = additem(grp,'S7-1200 station_1.PLC_1.gui_start');
start(grp);

write(itm8,'True');
pause(.5);
write(itm8,'False');
pause(.5);

set(handles.START,'Enable','off')
set(handles.CalibrateCamera,'Enable','off');
set(handles.StartLocateOrigin,'Enable','off');
set(handles.STOP,'Enable','on');
set(handles.HOMING,'Enable','on');
set(handles.uipanel6, 'visible', 'off');

% Opening camera
VidROI = get(handles.VidObj, 'ROIPosition');
nBands = get(handles.VidObj, 'NumberofBands');
handles.hImage  = image(zeros(VidROI(4), VidROI(3), nBands));
axes(handles.axes1);
preview(handles.VidObj, handles.hImage);


% --- Executes on button press in STOP.
function STOP_Callback(hObject, eventdata, handles)
% hObject    handle to STOP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stopping PLC using OPC
da = opcda('localhost', 'OPC.SimaticNET');
connect(da);
pause(.5)
grp = addgroup(da, 'DemoGroup');
itm9 = additem(grp,'S7-1200 station_1.PLC_1.gui_stop');
start(grp);

write(itm9,'False');
pause(.5);
write(itm9,'True');
pause(.5);

set(handles.START,'Enable','ON')
set(handles.CalibrateCamera,'Enable','ON');
set(handles.StartLocateOrigin,'Enable','ON');
set(handles.STOP,'Enable','OFF');
set(handles.HOMING,'Enable','OFF');
set(handles.TakeCoordinate,'Enable','OFF');
set(handles.StartPackaging,'Enable','OFF');

% Closing Camera
closepreview(handles.VidObj);
set(handles.uipanel6, 'visible', 'on');


% --- Executes on button press in HOMING.
function HOMING_Callback(hObject, eventdata, handles)
% hObject    handle to HOMING (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.HOMING,'Enable','OFF');
% Star Homing PLC using OPC
da = opcda('localhost', 'OPC.SimaticNET');
connect(da);
pause(.5)
grp = addgroup(da, 'DemoGroup');
itm10 = additem(grp,'S7-1200 station_1.PLC_1.gui_homing');
start(grp);

write(itm10,'True');
pause(.5);
write(itm10,'False');
pause(5);

set(handles.TakeCoordinate,'Enable','ON');

% --- Executes on button press in TakeCoordinate.
function TakeCoordinate_Callback(hObject, eventdata, handles)
% hObject    handle to TakeCoordinate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel6, 'visible', 'off');
set(handles.TakeCoordinate,'Enable','OFF');
%% getting all the parameters needed from camera calibration ----------------------
load('C:\Users\ASUS\Desktop\BitirmeTezi_140207098_EffenciogaPutraYanra\samplesImages\CalibrationData.mat');
cameraParams = cameraParams;
R = RotationalMatrix;
t = TranslationVectors;

%% getting an image --------------------------------------------------------
set(handles.VidObj, 'ReturnedColorspace', 'rgb');
handles.VidObj.FrameGrabInterval = 0.5;
% start image aquisition
start(handles.VidObj);
% get a snapshot image
imOrig = getsnapshot(handles.VidObj);
% stop image aquisition
stop(handles.VidObj);
flushdata(handles.VidObj);
%% color tresholding -------------------------------------------------------
% set color to be detected
color = '5'; % 1. Yellow, 2. Green, 3. Red, 4. Purple, 5. Blue
% Undistort the Image
[im, newOrigin] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');

hsvIm = rgb2hsv(im);    % Convert RGB to HSV
hIm = hsvIm(:,:,1); % Get the hue
sIm = hsvIm(:,:,2); % Get the saturation
vIm = hsvIm(:,:,3); % Get the value
% Get hue, saturation, value masks
[hThresholdLow, hThresholdHigh, sThresholdLow, sThresholdHigh, ...
    vThresholdLow, vThresholdHigh] = GetThresholds(color);

% Apply masks
mask = (sIm >= sThresholdLow) & (sIm <= sThresholdHigh);
mask = mask & (vIm >= vThresholdLow) & (vIm <= vThresholdHigh);
if hThresholdLow < 0 % If hue is red
    mask = mask & (hIm <= hThresholdHigh);
    mask = mask | ((hIm >= -hThresholdLow) & (hIm <= 1));
else
    mask = mask & (hIm >= hThresholdLow) & (hIm <= hThresholdHigh);
end

mask = double(medfilt2(mask, [3 3])); % filter the noise
imBW = imbinarize(mask); % convert to binary image
imBW = bwareaopen(imBW,120); % delete all pixels under 120
imBW = bwlabel(imBW, 8);
% boundaries of an object are searched diagonally(in 8 connected pixels)

%% BLOB Analysis
% Finding Center
center = regionprops(imBW, 'Centroid');
bc = zeros(length(center),2);
center = struct2cell(center);
center = cell2mat(center);
a = 1;
for i = 1:(length(center)/2)
    for j = 1:2
        bc(i,j) = center(a); % imagepoints in pixels
        a = a+1;
    end
end

% Finding BoundingBox
box = regionprops(imBW, 'BoundingBox');
bb = zeros(length(box),4);
box = struct2cell(box);
box = cell2mat(box);
c = 1;
for i = 1:(length(box)/4)
    for j = 1:4
        bb(i,j) = box(c);
        c = c+1;
    end
end
bb(:,1:2) = bsxfun(@plus, bb(:,1:2), newOrigin);

%% Calculating worldPoints--------------------------------------------------
requiredPoints = [45.3561   39.9882];
imagePoints = bsxfun(@plus, bc, newOrigin);
worldPoints = pointsToWorld(cameraParams, R, t, imagePoints);
worldPoints = round((worldPoints - requiredPoints))/29*6.15% worldPoints in millimeters
Coordinates.data = worldPoints;
save('DeltaRobot1.mat', '-struct', 'Coordinates');

%% Showing center and boundingbox of detected objects
text_strl = cell(1,1);
if isempty(worldPoints)
    for i = 1:1
        text_strl{i} = ['0'];
    end
else
    for i = 1:(length(center)/2)
        text_strl{i} = ['X: ' num2str(round(worldPoints(i,1)),'%0.2f') 'mm; '...
            'Y: ' num2str(round(worldPoints(i,2)),'%0.2f') 'mm'];
    end
end
imOrig = insertMarker(imOrig,imagePoints,'color','black','size',5);
imOrig = insertText(imOrig,imagePoints,text_strl,'FontSize',16,'BoxColor',...
    'white','BoxOpacity',0.2,'TextColor','black');
imOrig = insertShape(imOrig,'rectangle',bb,'color','black','LineWidth',2);
axes(handles.axes1);
cla;
imshow(imOrig)

% %% Kinematic Analysis-------------------------------------------------------
% delta robot parameters
a = 43.5;
b = 25.11;
c = -50.22;
l = 110;

% Getting all the coordinates
box = [8 0]; % set the coordinate of box
z1 = -76.8; % set z value for picking
z2 = -90; % set z value for lifting
test = size(worldPoints);
if ( test(1,1) == 1) %if theres only one object
    for i = 1:3
        x(i) = worldPoints(1,1);
        y(i) = worldPoints(1,2);
    end
    for i = 4:6
        x(i) = box(1,1);
        y(i) = box(1,2);
    end
    for i = 1:6
        if((i == 2) || (i == 5))
            z(i) = z1;
        else
            z(i) = z2;
        end
    end
else
    x = zeros(1,length(worldPoints)*4);
    y = zeros(1,length(worldPoints)*4);
    z = zeros(1,length(worldPoints)*4);
    k = 1;m = 2;n = 3;o = 4; p=5;q=6;
    for i = 1:(length(worldPoints))
        x(k) = worldPoints(i,1);
        y(k) = worldPoints(i,2);
        z(k) = z2;
        k = k + 6;
        x(m) = worldPoints(i,1);
        y(m) = worldPoints(i,2);
        z(m) = z1;
        m = m + 6;
        x(n) = worldPoints(i,1);
        y(n) = worldPoints(i,2);
        z(n) = z2;
        n = n + 6;
    end
    for i = 1:(length(worldPoints))
        x(o) = box(1,1);
        y(o) = box(1,2);
        z(o) = z2;
        o = o + 6;
        x(p) = box(1,1);
        y(p) = box(1,2);
        z(p) = z1;
        p = p + 6;
        x(q) = box(1,1);
        y(q) = box(1,2);
        z(q) = z2;
        q = q + 6;
    end
end

% showing all the coordinates needed
points = [ x' y' z' ];

% invers kinematics
C1 = x.^2 + y.^2 + z.^2 + a^2 + + b^2 + 2*a*x + 2*b*y - l^2;
C2 = x.^2 + y.^2 + z.^2 + a^2 + + b^2 - 2*a*x + 2*b*y - l^2;
C3 = x.^2 + y.^2 + z.^2 + c^2 + 2*c*y - l^2;

L1 = -z-sqrt(z.^2-C1);
L2 = -z-sqrt(z.^2-C2);
L3 = -z-sqrt(z.^2-C3);

L11 = L1;
L21 = L2;
L31 = L3;
V1=[];V2=[];V3=[];

% creating arrays of velocity and position that will be sent to OPC Data
V3=[0,V3,zeros(1,(100 - length(L11)))];
V2=[0,V2,zeros(1,(100 - length(L11)))];
V1=[0,V1,zeros(1,(100 - length(L11)))];
L1=[0,L1,zeros(1,(100 - length(L11)))];
L2=[0,L2,zeros(1,(100 - length(L11)))];
L3=[0,L3,zeros(1,(100 - length(L11)))];

% getting all the velocity needed
for k=1:(length(L1)-1)
    V1(k+1)= abs((L1(k+1) - L1(k))/4);
    V2(k+1)= abs((L2(k+1) - L2(k))/4);
    V3(k+1)= abs((L3(k+1) - L3(k))/4);
end
V1(2)=V1(2)/2;
V2(2)=V2(2)/2;
V3(2)=V3(2)/2;
V1(length(L11)+2) = V1(length(L11)+2)/2;
V2(length(L11)+2) = V2(length(L11)+2)/2;
V3(length(L11)+2) = V3(length(L11)+2)/2;

[max(V1) max(V2) max(V3) min(V1) min(V2) min(V3)];

M = zeros(1,101); % all values for vacum
for i= 1:6:length(L11)
    for j= 1:1:3
        M(i+(j-1)) = 0;
    end
    for k= 4:1:6
        M(i+(k-1)) = 1;
    end
end

% showing L1 L2 L3 V1 V2 V3 M values
position = [L1' L2' L3' V1' V2' V3' M'];

%% Transferring data from matlab to OPC Data in PLC
% Sending all position and velocity needed to OPC Data in Siemens S7-1200
% PLC

da = opcda('localhost', 'OPC.SimaticNET');
connect(da);
pause(.5)
grp = addgroup(da, 'DemoGroup');
itm1 = additem(grp,'S7-1200 station_1.PLC_1.OPC_DATA.x1_pos');
itm2 = additem(grp,'S7-1200 station_1.PLC_1.OPC_DATA.x2_pos');
itm3 = additem(grp,'S7-1200 station_1.PLC_1.OPC_DATA.x3_pos');

itm4 = additem(grp,'S7-1200 station_1.PLC_1.OPC_DATA.x1_vlcty');
itm5 = additem(grp,'S7-1200 station_1.PLC_1.OPC_DATA.x2_vlcty');
itm6 = additem(grp,'S7-1200 station_1.PLC_1.OPC_DATA.x3_vlcty');
itm7 = additem(grp,'S7-1200 station_1.PLC_1.OPC_DATA.vakum');
itm8 = additem(grp,'S7-1200 station_1.PLC_1.gui_reset');

start(grp);

L1=single(L1);
L2=single(L2);
L3=single(L3);

V1=single(V1);
V2=single(V2);
V3=single(V3);

write(itm1,L1);
pause(.5);
write(itm2,L2);
pause(.5);
write(itm3,L3);
pause(.5);
write(itm4,V1);
pause(.5);
write(itm5,V2);
pause(.5);
write(itm6,V3);
pause(.5);
write(itm7,M);
pause(.5);
write(itm8,'True');
pause(.5);
write(itm8,'False');
pause(.5);

set(handles.StartPackaging,'Enable','ON');


% --- Executes on button press in StartPackaging.
function StartPackaging_Callback(hObject, eventdata, handles)
% hObject    handle to StartPackaging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('C:\Users\ASUS\Desktop\BitirmeTezi_140207098_EffenciogaPutraYanra\MATLAB GUI v1\DeltaRobot1.mat');

set(handles.StartPackaging,'Enable','OFF');
set(handles.uipanel6, 'visible', 'off');

% Opening camera
VidROI = get(handles.VidObj, 'ROIPosition');
nBands = get(handles.VidObj, 'NumberofBands');
axes(handles.axes1);
handles.hImage  = image(zeros(VidROI(4), VidROI(3), nBands));
preview(handles.VidObj, handles.hImage);

% Start Packaging using OPC
da = opcda('localhost', 'OPC.SimaticNET');
connect(da);
pause(.5)
grp = addgroup(da, 'DemoGroup');

itm11 = additem(grp,'S7-1200 station_1.PLC_1.gui_startpackaging');
itm12 = additem(grp,'S7-1200 station_1.PLC_1.ind');
start(grp);

write(itm11,'True');
pause(.5);
write(itm11, 'False');
pause(.5);
test = size(data);
while(itm12.Value < test(1,1)*6+1)
    read(itm12);
    pause(.5);
end
set(handles.HOMING, 'Enable', 'on');

% --- Executes on button press in CalibrateCamera.
function CalibrateCamera_Callback(hObject, eventdata, handles)
% hObject    handle to CalibrateCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.CalibrateCamera,'String'),'Calibrate the camera')
    set(handles.CalibrateCamera,'String','Stop the calibration');
    set(handles.StartLocateOrigin,'Enable','off');
    set(handles.START,'Enable','off');
    CalibratetheCamera;
else
    set(handles.CalibrateCamera,'String','Calibrate the camera');
    set(handles.StartLocateOrigin,'Enable','on');
    set(handles.START,'Enable','on');
end


% --- Executes on button press in TakeCoordinate.
function StartLocateOrigin_Callback(hObject, eventdata, handles)
% hObject    handle to TakeCoordinate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.START,'Enable','off');
set(handles.StartLocateOrigin,'Enable','off');
set(handles.StopLocateOrigin,'Enable','ON');
set(handles.CalibrateCamera,'Enable','off');
set(handles.uipanel6, 'visible', 'off');
%% getting all the parameters needed
load('C:\Users\ASUS\Desktop\BitirmeTezi_140207098_EffenciogaPutraYanra\samplesImages\CalibrationData.mat');
cameraParams = cameraParams;
R = RotationalMatrix;
t = TranslationVectors;
%% getting an image
VidROI = get(handles.VidObj, 'ROIPosition');
nBands = get(handles.VidObj, 'NumberofBands');
handles.hImage  = image(zeros(VidROI(4), VidROI(3), nBands));
axes(handles.axes1);
set(handles.VidObj, 'ReturnedColorspace', 'rgb');
%start image aquisition
start(handles.VidObj);
imOrig = getsnapshot(handles.VidObj);
% Undistort the Image
[im, newOrigin] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');
%% Finding origin on the board ( image )
imagePoints = worldToImage(cameraParams, R,t, [45.3561   39.9882 0])+ newOrigin;
text_strl = ['X = 0 mm; Y = 0 mm'];
% showing origin on the board
while(1)
    imOrig = getsnapshot(handles.VidObj);
    imOrig = insertMarker(imOrig,imagePoints,'color','black','size',20);
    imOrig = insertText(imOrig,imagePoints,text_strl,'FontSize',16,'BoxColor',...
        'white','BoxOpacity',0.2,'TextColor','black');   
    set(handles.hImage,'CData',imOrig);    
    set(gca,'XTick',[], 'YTick', []);
    drawnow;
    stop_state = get(handles.StopLocateOrigin, 'Value');
    if stop_state
        stop(handles.VidObj);
        msgbox('You can start the packaging process');
        break;
    end
end
%% stop image aquisition
stop(handles.VidObj);


% --- Executes on button press in StopLocateOrigin.
function StopLocateOrigin_Callback(hObject, eventdata, handles)
% hObject    handle to StopLocateOrigin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel6, 'visible', 'on');
set(handles.START,'Enable','on');
set(handles.StartLocateOrigin,'Enable','on');
set(handles.StopLocateOrigin,'Enable','off');
set(handles.CalibrateCamera,'Enable','on');
stop(handles.VidObj);
VidROI = get(handles.VidObj, 'ROIPosition');
nBands = get(handles.VidObj, 'NumberofBands');
handles.hImage  = image(zeros(VidROI(4), VidROI(3), nBands));
axes(handles.axes1);
preview(handles.VidObj, handles.hImage);
closepreview(handles.VidObj);
msgbox('You can start the packaging process');
