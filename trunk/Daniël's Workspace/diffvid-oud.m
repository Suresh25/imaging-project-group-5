function varargout = diffvid(varargin)
% DIFFVID MATLAB code for diffvid.fig
%      DIFFVID, by itself, creates a new DIFFVID or raises the existing
%      singleton*.
%
%      H = DIFFVID returns the handle to a new DIFFVID or the handle to
%      the existing singleton*.
%
%      DIFFVID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIFFVID.M with the given input arguments.
%
%      DIFFVID('Property','Value',...) creates a new DIFFVID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before diffvid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to diffvid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help diffvid

% Last Modified by GUIDE v2.5 12-Nov-2012 11:44:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @diffvid_OpeningFcn, ...
                   'gui_OutputFcn',  @diffvid_OutputFcn, ...
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


% --- Executes just before diffvid is made visible.
function diffvid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to diffvid (see VARARGIN)

% Choose default command line output for diffvid
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% video init:
vid = videoinput('winvideo');
set(vid, 'TriggerRepeat', Inf);
set(vid, 'FrameGrabInterval', 1);

% add video stream object as a new field
handles.vid = vid;
% save the change you made to the structure
guidata(hObject,handles);

% UIWAIT makes diffvid wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = diffvid_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start(handles.vid);

% Switches focus to axes1
axes(handles.axes1);
% Display image in current axes
image(getdata(handles.vid, 1));
while 1
    % Grab 2 frames
    data = getdata(handles.vid, 2);
    % Obtain absolute difference
    diff_im = imabsdiff(data(:,:,:,1), data(:,:,:,2));
    
    h = get(handles.axes1, 'Children');
    set(h, 'CData', diff_im);
end


% --- Executes on button press in pushbutton2.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.vid);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stop the video stream
stop(handles.vid);

% Hint: delete(hObject) closes the figure
delete(hObject);
