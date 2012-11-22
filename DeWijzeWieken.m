function varargout = DeWijzeWieken(varargin)
% DEWIJZEWIEKEN MATLAB code for DeWijzeWieken.fig
%      DEWIJZEWIEKEN, by itself, creates a new DEWIJZEWIEKEN or raises the existing
%      singleton*.
%
%      H = DEWIJZEWIEKEN returns the handle to a new DEWIJZEWIEKEN or the handle to
%      the existing singleton*.
%
%      DEWIJZEWIEKEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEWIJZEWIEKEN.M with the given input arguments.
%
%      DEWIJZEWIEKEN('Property','Value',...) creates a new DEWIJZEWIEKEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DeWijzeWieken_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DeWijzeWieken_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DeWijzeWieken

% Last Modified by GUIDE v2.5 21-Nov-2012 15:55:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DeWijzeWieken_OpeningFcn, ...
                   'gui_OutputFcn',  @DeWijzeWieken_OutputFcn, ...
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


% --- Executes just before DeWijzeWieken is made visible.
function DeWijzeWieken_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DeWijzeWieken (see VARARGIN)
vid = videoinput('winvideo');
set(vid, 'TriggerRepeat', inf);
set(vid, 'FrameGrabInterval', 1);
handles.vid = vid;

% Choose default command line output for DeWijzeWieken
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DeWijzeWieken wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DeWijzeWieken_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startAnalyse.
function startAnalyse_Callback(hObject, eventdata, handles)
% hObject    handle to startAnalyse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
waar = true;

start(handles.vid);
axes(handles.axes1);
image(getdata(handles.vid, 1));
while waar
    n = normalise(getdata(handles.vid, 1));
    s = segmentation(n);
    l = label(s);
    p = property(l);
    c = classification(p);
    t = count(c);
    

    data = getdata(handles.vid, 2);
	% Obtain absolute difference
	diff_im = data(:,:,:,2);
    
	h = get(handles.axes1, 'Children');
	set(h, 'CData', diff_im);
    
end



% --- Executes on button press in stopAnalyse.
function stopAnalyse_Callback(hObject, eventdata, handles)
% hObject    handle to stopAnalyse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
waar = false;
stop(handles.vid);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

% Stop the video stream
stop(handles.vid);

delete(hObject);
