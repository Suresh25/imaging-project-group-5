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

    % Last Modified by GUIDE v2.5 03-Dec-2012 10:32:31

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

    % Reset the image-aquisition toolkit
    imaqreset;

    % Init our video-input and its properties:
    vid = videoinput('winvideo');
    set(vid, 'TriggerRepeat', inf);
    set(vid, 'FrameGrabInterval', 3);
    set(vid, 'ReturnedColorSpace','RGB');
    % vid = videoinput('winvideo', 1, 'RGB24_320x240');
    % set(vid, 'ReturnedColorSpace', 'grayscale');
    
    % Init our custom global properties
    handles.vid = vid;
    handles.analyze = false;
    handles.input_source = 'camera';
    handles.loaded_video = 0;
    handles.lv_frame_index = 1;
    handles.calib_img = 0;
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    % Init DIPLib
    dipstart;

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


function initViewports(handles, frame)
    ports = [ handles.axes1, ... 
              handles.axes2, ... 
              handles.axes3, ... 
              handles.axes4 ];
    for i = 1:size(ports, 2)
        axes(ports(i));
        image(frame);
    end

function frame = getFrame(hObject, handles)
    if strcmp(handles.input_source, 'camera')
        frame = getdata(handles.vid, 1);
    end
    if strcmp(handles.input_source,'file') && handles.loaded_video ~= 0
         frame = read(handles.loaded_video, handles.lv_frame_index);
         if handles.lv_frame_index < handles.loaded_video.NumberOfFrames
            handles.lv_frame_index = handles.lv_frame_index + 1;
            guidata(hObject, handles);
         end
         % Maintain frame-rate
         pause(1 / handles.loaded_video.FrameRate);
    end    
        
function displayFrame(axes, frame)
    h = get(axes, 'Children');
    set(h, 'CData', frame);
    
function displayMain(handles, frame)
    displayFrame(handles.axes1, frame);

function displayOriginal(handles, frame)
    displayFrame(handles.axes2, frame);

function displayFiltered(handles, frame)
    displayFrame(handles.axes3, frame);

function displayProcessed(handles, frame)
    displayFrame(handles.axes4, frame);

% --- Executes on button press in startAnalyse.
function startAnalyse_Callback(hObject, eventdata, handles)
    % hObject    handle to startAnalyse (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
   
    % Flag analysis start
    handles.analyze = true;
    guidata(hObject, handles);
    
    % Start video retrieval and initialise viewports
    start(handles.vid);
    % captureCalib(hObject, handles);
    frame = getFrame(hObject, handles);
    initViewports(handles, frame);
   
    while handles.analyze
        frame = getFrame(hObject, handles);
        
        enhanced = enhance(frame, handles);
        % analyze(enhanced, handles);
        
        displayMain(handles, frame);
        displayOriginal(handles, frame);
        displayFiltered(handles, toMatrix(3, enhanced{1}));
        displayProcessed(handles, toMatrix(3, enhanced{2}, enhanced{2}));
        
        % Update handles
        handles = guidata(hObject);
    end 

    stop(handles.vid);


% --- Executes on button press in stopAnalyse.
function stopAnalyse_Callback(hObject, eventdata, handles)
    % hObject    handle to stopAnalyse (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    clear handles.vid;
    handles.analyze = false;
    guidata(hObject, handles);




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to figure1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: delete(hObject) closes the figure

    % Stop the video stream
    handles.analyze = false;
    guidata(hObject, handles);
    stop(handles.vid);

    delete(hObject);

function captureCalib(hObject, handles)
    handles.calib_img = normalise(getdata(handles.vid, 1));
    guidata(hObject, handles);

% --- Executes on button press in backgroundCatch.
function backgroundCatch_Callback(hObject, eventdata, handles)
    % hObject    handle to backgroundCatch (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    captureCalib(hObject, handles);
    

% --- Executes on button press in loadVideoButton.
function loadVideoButton_Callback(hObject, eventdata, handles)
    % hObject    handle to loadVideoButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    [FileName, PathName, FilterIndex] = uigetfile('*.wmv;*.mpeg4;','Select a video to process');
    loadedVideo = videoLoader(FileName);

    handles.input_source = 'file';
    handles.loaded_video = loadedVideo;
    guidata(hObject, handles);