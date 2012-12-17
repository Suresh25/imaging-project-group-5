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

    % Last Modified by GUIDE v2.5 06-Dec-2012 11:22:26

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
    
    % Init DIPLib
    dipstart;
    
    global last_frame;
    
    % Init our custom global properties
    %handles.vid = videoinput('winvideo');
    %set(handles.vid, 'TriggerRepeat', inf);
    %set(handles.vid, 'ReturnedColorSpace','RGB');
    
    handles.analyze = false;
    handles.input_source = 'video';
    handles.loaded_video = 0;
    handles.lv_frame_index = 1;
    handles.calib_img = 0;
    handles.lift_segmented = 0;
    handles.history = [0, 0];
    handles.traffic_total = 0;
    handles.traffic_out = 0;
    handles.traffic_in = 0;
    handles.traffic_inview = 0;
    handles.output = hObject;
    handles.debug = '';
    handles.lift_bounds = [0, 0; 100, 100];
    last_frame = 0;
    
    %%%%%%%%% Removed because propably not used anymore
    %Init empty array that will contain list of previous objects in image
    %for classification
    %handles.classificationPreviousObjectList = [];
    %%%%%%%%%
    
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

% Initializes all the viewports on the GUI by placing an initial image
% in them.
function initViewports(handles, frame)
    ports = [ handles.axes1, ... 
              handles.axes2, ... 
              handles.axes3, ... 
              handles.axes4 ];
    for i = 1:size(ports, 2)
        axes(ports(i));
        image(frame);
    end

% Retrieves a single frame from source (camera or file) as specified by 
% the handles.input_source variable.
function frame = getFrame(hObject, handles)
    if strcmp(handles.input_source, 'camera')
        frame = getdata(handles.vid, 1);
    elseif strcmp(handles.input_source,'file') && handles.loaded_video ~= 0
         frame = read(handles.loaded_video, handles.lv_frame_index);
         if handles.lv_frame_index < handles.loaded_video.NumberOfFrames
            handles.lv_frame_index = handles.lv_frame_index + 1;
            
            set(handles.slider1, 'Value', handles.lv_frame_index);
         end
         % Maintain frame-rate
         pause(1 / handles.loaded_video.FrameRate);
    end   
    
    guidata(hObject, handles);

% Displays a given frame on given viewport.
function displayFrame(axes, frame)
    h = get(axes, 'Children');
    set(h, 'CData', frame);

% Displays a frame on the main (and largest) viewport.
function displayMain(handles, frame)
    displayFrame(handles.axes1, frame);

% Displays a frame on the 'original image' viewport.
function displayOriginal(handles, frame)
    displayFrame(handles.axes2, frame);

% Displays a frame on the 'post-filtering' viewport.
function displayFiltered(handles, frame)
    displayFrame(handles.axes3, frame);

% Displays a frame on the 'post-processing' viewport.
function displayProcessed(handles, frame)
    displayFrame(handles.axes4, frame);

% Update the statistics on the GUI
function displayStats(handles)
    set(handles.Stats1, 'String', ...
        ['Ingoing: ', num2str(handles.traffic_in), char(10), ...
         'Outgoing: ', num2str(handles.traffic_out), char(10), ...
         'Total: ', num2str(handles.traffic_total), char(10), ...
         'In view: ', num2str(handles.traffic_inview), char(10), ...
         'Debug: ', handles.debug]);
    drawnow
 
% --- Executes on button press in startAnalyse.
function startAnalyse_Callback(hObject, eventdata, handles)
    % hObject    handle to startAnalyse (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
   
    global last_frame last_frame_temp;
    
    % Flag analysis start
    handles.analyze = true;
    
    % Start video retrieval and initialise viewports
    if strcmp(handles.input_source, 'camera')
        start(handles.vid);
    end
  
    captureCalib(hObject, handles);
    handles = guidata(hObject);
    frame = getFrame(hObject, handles);
    handles = guidata(hObject);
    initViewports(handles, frame);
    
    minX = handles.lift_bounds(1,1);
    minY = handles.lift_bounds(1,2);
    maxX = handles.lift_bounds(2,1);
    maxY = handles.lift_bounds(2,2);
    
    img = handles.lift_segmented;
    new = dip_image(zeros(240,320));
    x = drawpolygon(new,[minX,minY; maxX,minY; maxX,maxY; minX,maxY],255,'closed');
    x = dilation((x > 1),8,'rectangular');
    x = img | x;
    displayFiltered(handles, toMatrix(3,x,x,x));
    
    while handles.analyze
        tic;
        frame = getFrame(hObject, handles);
        %flushdata(handles.vid);
        
        handles = guidata(hObject);
        enhanced = enhance(frame, handles);
        %analyze(enhanced, hObject, handles);
        handles = guidata(hObject);
        
        displayMain(handles, frame);
        displayOriginal(handles, frame);
        displayProcessed(handles, toMatrix(3, enhanced{2}, enhanced{2}));
        displayStats(handles);
        
        % Update handles
        handles = guidata(hObject);
        
        %save frame for next itteration
        last_frame = last_frame_temp;
        toc;
    end
    
    if strcmp(handles.input_source, 'camera')
        stop(handles.vid);
    end

% --- Executes on button press in stopAnalyse.
function stopAnalyse_Callback(hObject, eventdata, handles)
    % hObject    handle to stopAnalyse (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
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

% Capture calibration image and save it.
function captureCalib(hObject, handles)
    frame = getFrame(hObject, handles);
    handles = guidata(hObject);
    handles.calib_img = normalise(frame, handles);
    handles.lift_segmented = segmentLift(handles.calib_img);
    handles.lift_labeled = labelLift(handles.lift_segmented);
    
    msr = measure(handles.lift_labeled, [], {'Minimum', 'Maximum'}, [], ...
                  1, 300, 0);
    if size(msr, 1) > 0
        minX = msr(1).Minimum(1);
        minY = msr(1).Minimum(2);
        maxX = msr(1).Maximum(1);
        maxY = msr(1).Maximum(2);
        handles.lift_bounds = [minX, minY; maxX, maxY];
    end
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
   
    handles.input_source = 'file';
    handles.loaded_video = videoLoader(FileName);
    handles.lv_frame_index = 1;
    set(handles.slider1, 'Min', 0, 'Max', ...
        handles.loaded_video.NumberOfFrames, 'SliderStep', ...
        [1 /(handles.loaded_video.NumberOfFrames/10), ...
         1 /(handles.loaded_video.NumberOfFrames/10)]);
    captureCalib(hObject, handles);
    
    guidata(hObject, handles);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    handles.lv_frame_index = round(get(hObject,'Value'));

    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

