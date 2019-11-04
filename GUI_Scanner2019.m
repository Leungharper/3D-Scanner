function varargout = GUI_Scanner2019(varargin)
% GUI_SCANNER2019 MATLAB code for GUI_Scanner2019.fig
%      GUI_SCANNER2019, by itself, creates a new GUI_SCANNER2019 or raises the existing
%      singleton*.
%
%      H = GUI_SCANNER2019 returns the handle to a new GUI_SCANNER2019 or the handle to
%      the existing singleton*.
%
%      GUI_SCANNER2019('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SCANNER2019.M with the given input arguments.
%
%      GUI_SCANNER2019('Property','Value',...) creates a new GUI_SCANNER2019 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Scanner2019_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Scanner2019_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Scanner2019

% Last Modified by GUIDE v2.5 04-Nov-2019 01:04:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Scanner2019_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Scanner2019_OutputFcn, ...
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


% --- Executes just before GUI_Scanner2019 is made visible.
function GUI_Scanner2019_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Scanner2019 (see VARARGIN)

% Choose default command line output for GUI_Scanner2019
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Scanner2019 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.radiobutton_auto,'Value',1)
set(handles.checkbox_Color,'Value',1)
%{
time = date; %获取年月日
time = [time,'-',num2str(hour(now)),num2str(minute(now)),num2str(fix(second(now)))];%添加时间
global folder;
% folder = time;
folder = [pwd,'\',time]; %当前路径+文件夹名
mkdir(folder); %新建文件夹
%}
if ~get(handles.checkbox_Warning,'Value') %是否关闭命令行警告
    warning off;
else
    warning on;
end
global Switch;  Switch = 1; %激光开关状态变量


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Scanner2019_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_View.
function pushbutton_View_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
camera_type = get(handles.popupmenu_camera,'Value');
camera_type = 3 - camera_type;
global vid;
if isempty(vid) == 0
    delete(vid)
end
resolution = get(handles.popupmenu_resolution,'String');
res_num = get(handles.popupmenu_resolution,'Value');
vid = videoinput('winvideo',camera_type,['MJPG_',resolution{res_num}]);
% vid = videoinput('winvideo',camera_type,'MJPG_640x480'); %【2是USB摄像头，1是笔记本摄像头】
vid.FramesPerTrigger = 1;%每隔帧取一幅图像
VidRes=get(vid,'videoResolution');%视频分辨率
nBands=get(vid,'NumberOfBands');%色彩数目
axes(handles.axes_camera)
hImage=imshow(zeros(VidRes(2),VidRes(1),nBands));
% hImage：视频预览窗口对应的句柄，也就是说在指定的句柄对象中预览视频，
% 该参数可以空缺。至于预览窗口的关闭和停止可以使用colsepreview和stoppreview函数
preview(vid,hImage)


% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(instrfindall) %自动解除所有串口占用（instrfindall可以找到所有的串口）

clc; close all; %clear all


% --- Executes on selection change in popupmenu_camera.
function popupmenu_camera_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_camera contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_camera


% --- Executes during object creation, after setting all properties.
function popupmenu_camera_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_3D.
function pushbutton_3D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global folder
global ptCloud
%
color_FLAG = get(handles.checkbox_Color,'Value');
FocalLength = get(handles.edit_FocalLength,'String');  FocalLength = str2double(FocalLength);
interp_FLAG = get(handles.checkbox_Interp,'Value');
if get(handles.radiobutton_common,'Value')
    [ptCloud,CalTime] = fun_build3D(folder,[],FocalLength,color_FLAG,interp_FLAG);
end
set(handles.text_CalTime,'String',num2str(CalTime))
if get(handles.checkbox_BigFigure,'Value')
    figure, pcshow(ptCloud)
else
    axes(handles.axes_3D), pcshow(ptCloud)
end
%}



function edit_angle_Callback(hObject, eventdata, handles)
% hObject    handle to edit_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_angle as text
%        str2double(get(hObject,'String')) returns contents of edit_angle as a double
angle = get(handles.edit_angle,'String');	angle = str2double(angle);
if angle > 20
    angle = 20;
end
if angle < -20
    angle = -20;
end
data = uint8( 255/40 * (angle + 20) );
data = num2str(data);	set(handles.edit_IOdata,'String',data);


% --- Executes during object creation, after setting all properties.
function edit_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_IOdata_Callback(hObject, eventdata, handles)
% hObject    handle to edit_IOdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_IOdata as text
%        str2double(get(hObject,'String')) returns contents of edit_IOdata as a double
data = get(handles.edit_IOdata,'String');	data = str2double(data);
if data > 255
    data = 255;
end
if data < 0
    data = 0;
end
angle = (-8.99/252 * (data-3) + 4.44) / 5*20;
angle = num2str(angle);    set(handles.edit_angle,'String',angle);


% --- Executes during object creation, after setting all properties.
function edit_IOdata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_IOdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Action.
function pushbutton_Action_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Action (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Port;    global vid;
global folder;  global itv;

if get(handles.radiobutton_manual,'Value')
    data = get(handles.edit_IOdata,'String');
    data = str2double(data);	%data = uint8(data);
    fwrite(Port, uint8('A'));%指明控制AD模块
    fwrite(Port, uint8(data));
else
    original = pwd;
    time = date; %获取年月日
    time = [time,'-',num2str(hour(now)),num2str(minute(now)),num2str(fix(second(now)))];%添加时间
    % folder = time;
    folder = [pwd,'\',time]; %当前路径+文件夹名
    mkdir(folder); %新建文件夹
    cd(folder) %指定文件夹
%———————无激光拍照——————
    fwrite(Port, uint8('L'));%关闭激光
	fwrite(Port, uint8(0));
        pause(0.2)
	im = getsnapshot(vid);
	im_name = 'NoLaser';
	imwrite(im,[im_name,'.png'])
%———————有激光拍照——————
    fwrite(Port, uint8('L'));%开激光
	fwrite(Port, uint8(1));
        pause(0.5)
    interval = str2double( get(handles.edit_interval,'String') );
    itv = 3:interval:255; %itv = 0:interval:255;
    for i = 255:-interval:3
        fwrite(Port, uint8('A'));%指明控制AD模块
        fwrite(Port, uint8(i));
            pause(0.25)
        im = getsnapshot(vid);
        im_name = num2str(i);
        imwrite(im,[im_name,'.png'])
    end
    if get(handles.checkbox_Cut,'Value')
        figure; suptitle('点击裁剪区域的左上角和右上角确定区域！')
        axes(handles.axes_3D)
        set(handles.text_tips,'String','点击裁剪区域的左上角和右上角确定区域')
        imshow(im)
        global cut;
        cut = fix( ginput(2) ) %用鼠标点击裁剪区域（点击2个对角）
        imshow( im(cut(1,2):cut(2,2),cut(1,1):cut(2,1),:) )
    end
    cd(original) %返回原工作目录
    set(handles.text_tips,'String','准备建模………')
end


% --- Executes on button press in pushbutton_TakePhoto.
function pushbutton_TakePhoto_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TakePhoto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid;
global folder;
original = pwd;
im = getsnapshot(vid);
cd(folder) %指定文件夹
im_name = get(handles.edit_IOdata,'String');
imwrite(im,[im_name,'.png']); %imwrite(im,[folder,'\']);
cd(original) %返回原工作目录



% --- Executes on button press in checkbox_serial.
function checkbox_serial_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_serial
if get(handles.checkbox_serial,'Value');
    global Port;
    Ports = instrhwinfo('serial'); %获取可用串口号
    Com = Ports.AvailableSerialPorts{1}; %Com = 'COM13';
    Port = serial(Com);
    BaudAll = get(handles.popupmenu_BaudRate,'String');
    BaudNum = get(handles.popupmenu_BaudRate,'Value');
    BaudRate = str2double( BaudAll{BaudNum} );
    set(Port,'BaudRate',BaudRate);  %设置波特率
    set(Port,'DataBits',8); %8位数据位
    set(Port,'StopBits',1);  %1位停止位
    Port.parity='none';  %设置校验位无奇偶校验
    fprintf( ['\n串口：',Com,';   波特率：%d','\n\n'],BaudRate );
    fopen(Port); %打开串口
else
    delete(instrfindall)
end



function edit_interval_Callback(hObject, eventdata, handles)
% hObject    handle to edit_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_interval as text
%        str2double(get(hObject,'String')) returns contents of edit_interval as a double


% --- Executes during object creation, after setting all properties.
function edit_interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_DisCamera_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DisCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DisCamera as text
%        str2double(get(hObject,'String')) returns contents of edit_DisCamera as a double


% --- Executes during object creation, after setting all properties.
function edit_DisCamera_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DisCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_BigFigure.
function checkbox_BigFigure_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BigFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BigFigure
global ptCloud
if ~isempty(ptCloud) && get(handles.checkbox_BigFigure,'Value')
    figure, pcshow(ptCloud)
elseif ~isempty(ptCloud)
    axes(handles.axes_3D), pcshow(ptCloud)
end


% --- Executes on selection change in popupmenu_resolution.
function popupmenu_resolution_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_resolution contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_resolution


% --- Executes during object creation, after setting all properties.
function popupmenu_resolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_DisLaser_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DisLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DisLaser as text
%        str2double(get(hObject,'String')) returns contents of edit_DisLaser as a double


% --- Executes during object creation, after setting all properties.
function edit_DisLaser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DisLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_DisCMOS_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DisCMOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DisCMOS as text
%        str2double(get(hObject,'String')) returns contents of edit_DisCMOS as a double


% --- Executes during object creation, after setting all properties.
function edit_DisCMOS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DisCMOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_CloseCamera.
function pushbutton_CloseCamera_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_CloseCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
delete(vid)


% --- Executes on button press in pushbutton_SaveData.
function pushbutton_SaveData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global folder
global cut
global itv
compress = get(handles.edit_compress,'String'); compress = str2double(compress);
save([folder '\data.mat'],'compress','cut','itv')
% save('data.mat','compress','cut') %或：save data copress cut



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global folder
folder = uigetdir('*.*','选择文件夹') %弹框选择文件夹
%  [filename folder] = uigetfile('.*','选择文件'); %弹框选择文件



function edit_compress_Callback(hObject, eventdata, handles)
% hObject    handle to edit_compress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_compress as text
%        str2double(get(hObject,'String')) returns contents of edit_compress as a double


% --- Executes during object creation, after setting all properties.
function edit_compress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_compress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_AngleOfDepression_Callback(hObject, eventdata, handles)
% hObject    handle to edit_AngleOfDepression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_AngleOfDepression as text
%        str2double(get(hObject,'String')) returns contents of edit_AngleOfDepression as a double


% --- Executes during object creation, after setting all properties.
function edit_AngleOfDepression_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_AngleOfDepression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rotate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rotate as text
%        str2double(get(hObject,'String')) returns contents of edit_rotate as a double


% --- Executes during object creation, after setting all properties.
function edit_rotate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Laser.
function pushbutton_Laser_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Laser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Port
global Switch
if Switch==0
    set(handles.pushbutton_Laser,'String','开');
else
    set(handles.pushbutton_Laser,'String','关');
end
Switch = 1 - Switch;

fwrite( Port, uint8('L') ); %指明控制激光【MATLAB的char类型是2字节，很坑！】
fwrite( Port, uint8(Switch) ); %激光状态


% --- Executes on selection change in popupmenu_BaudRate.
function popupmenu_BaudRate_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_BaudRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_BaudRate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_BaudRate


% --- Executes during object creation, after setting all properties.
function popupmenu_BaudRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_BaudRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_Cut.
function checkbox_Cut_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Cut


% --- Executes on button press in checkbox_Color.
function checkbox_Color_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Color


% --- Executes on button press in checkbox_CUTwhenBUILD.
function checkbox_CUTwhenBUILD_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_CUTwhenBUILD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_CUTwhenBUILD


% --- Executes on button press in checkbox_Interp.
function checkbox_Interp_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Interp


% --- Executes on button press in checkbox_Smooth.
function checkbox_Smooth_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Smooth


% --- Executes on button press in radiobutton_common.
function radiobutton_common_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_common (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_common


% --- Executes during object creation, after setting all properties.
function pushbutton_3D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_3Dquick.
function pushbutton_3Dquick_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_3Dquick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton_Action_Callback(hObject, eventdata, handles)
pushbutton_3D_Callback(hObject, eventdata, handles)



function edit_FocalLength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FocalLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_FocalLength as text
%        str2double(get(hObject,'String')) returns contents of edit_FocalLength as a double


% --- Executes during object creation, after setting all properties.
function edit_FocalLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_FocalLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_SavePtcloud.
function pushbutton_SavePtcloud_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SavePtcloud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global folder
global ptCloud
if ~isempty(ptCloud)
    if get(handles.checkbox_Interp,'Value')
        pcwrite(ptCloud,[folder,'_Interp.ply']);
    else
        pcwrite(ptCloud,[folder,'.ply']);
    end
end


% --- Executes on button press in checkbox_Warning.
function checkbox_Warning_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Warning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Warning
if ~get(handles.checkbox_Warning,'Value') %是否关闭命令行警告
    warning off;
else
    warning on;
end
