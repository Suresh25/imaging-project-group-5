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
    
    % Constants
    handles.OPEN = 1;
    handles.CLOSED = 2;
    handles.UNKNOWN = 3;
    handles.DOOR_DELAY = 1.2;  % In seconds
    
    % Init our custom global properties
    handles.vid = videoinput('winvideo');
    set(handles.vid, 'TriggerRepeat', inf);
    set(handles.vid, 'ReturnedColorSpace','RGB');
    
    handles.analyze = false;
    handles.input_source = 'camera';
    handles.fps = 5;
    handles.frame_index = 1;
    handles.loaded_video = 0;
    handles.lv_frame_index = 1;
    handles.lv_fps_helper = tic;
    handles.history = [0, 0, handles.UNKNOWN];
    handles.history_cap = 30;
    handles.door_status = handles.UNKNOWN;
    handles.last_open = 0;
    handles.traffic_total = 0;
    handles.traffic_out = 0;
    handles.traffic_in = 0;
    handles.traffic_inview = 0;
    handles.snapshot = [-1, -1, -1];
    handles.output = hObject;
    handles.debug = '';
    handles.lift_bounds = [0, 0; 100, 100];
    handles.current_frame = 0;  % Matrix form
    handles.last_frame = 0;  % Matrix form
    handles.cframe = 0;  % RGB DIPimage
    handles.calib_img = 0;
    handles.lift_segmented = 0;
    handles.lift_labeled = 0;
    handles.lift_msr = 0;
    handles.persons_segmented = 0;
    handles.persons_labeled = 0;
    handles.persons_msr = 0;
    handles.persons_l2c = zeros(1, 10);
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
function update = getFrame(handles)
    if strcmp(handles.input_source, 'camera')
        frame = getdata(handles.vid, 1);
    elseif strcmp(handles.input_source,'file') && handles.loaded_video ~= 0
        % Maintain frame-rate
        duration = toc(handles.lv_fps_helper);
        t = 0;
        delay = (1 / handles.loaded_video.FrameRate);
        if duration < delay
            t = delay - duration;
        end
        pause(t);
        handles.lv_fps_helper = tic;
        % End frame-rate maintenance
        
        frame = read(handles.loaded_video, handles.lv_frame_index);
        if handles.lv_frame_index < handles.loaded_video.NumberOfFrames
            handles.lv_frame_index = handles.lv_frame_index + 1;
            set(handles.slider1, 'Value', handles.lv_frame_index);
        end
    end   
    handles.last_frame = handles.current_frame;
    handles.current_frame = frame;
    handles.cframe = joinchannels('rgb', frame);
    handles.frame_index = handles.frame_index + 1;
    update = handles;
    
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

function displaySegmented(handles)
    lift = handles.lift_segmented;
    singles = newim(handles.persons_labeled);
    groups = newim(handles.persons_labeled);
    for i=1:size(handles.persons_msr, 1)
        if handles.persons_l2c(i) > 1
            groups = groups + (handles.persons_labeled == i);
        else
            singles = singles + (handles.persons_labeled == i);
        end
    end
    frame = toMatrix(3, lift, singles, groups);
    displayFiltered(handles, frame);

function displayAnalysis(handles)
    bg = handles.cframe;
    decor = decorateLift(bg, handles);
    decor = decoratePersons(decor, handles);
    frame = dip_array(decor);
    displayMain(handles, frame);
 
% Update the statistics on the GUI
function displayStats(handles)
    stat = handles.door_status;
    if stat == handles.OPEN
        statstr = 'open';
    elseif stat == handles.CLOSED
        statstr = 'closed';
    else
        statstr = 'unknown';
    end
    
    set(handles.Stats1, 'String', ...
        ['Ingoing: ', num2str(handles.traffic_in), char(10), ...
         'Outgoing: ', num2str(handles.traffic_out), char(10), ...
         'Total: ', num2str(handles.traffic_total), char(10), ...
         'In view: ', num2str(handles.traffic_inview), char(10), ...
         'Status: ', statstr, char(10), ...
         'Debug: ', handles.debug]);
    
    histLen = size(handles.history, 1);
    frames = 5;
    if histLen < frames
        frames = histLen - 1;
    end
%     set(handles.axes4, 'XLimMode', 'manual');
%     set(handles.axes4, 'YLimMode', 'manual');
%     set(handles.axes4, 'YTickLabelMode', 'manual');
%     set(handles.axes4, 'XLim', [0, frames]);
%     set(handles.axes4, 'YLim', [0, 5]);
    bar(handles.axes4, handles.history(histLen - frames + 1:histLen, 1:2), 1.2);
    drawnow
 
% --- Executes on button press in startAnalyse.
function startAnalyse_Callback(hObject, eventdata, handles)
    % hObject    handle to startAnalyse (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
   
    global last_frame last_frame_temp;
    
    % Flag analysis start
    handles.analyze = true;
    guidata(hObject, handles);
    
    % Start video retrieval and initialise viewports
    if strcmp(handles.input_source, 'camera')
        start(handles.vid);
    end
  
    handles = captureCalib(handles);
    %handles = guidata(hObject);
    handles = getFrame(handles);
    %handles = guidata(hObject);
    initViewports(handles, handles.current_frame);
    
    while handles.analyze
        tic;
        handles = getFrame(handles);
        %flushdata(handles.vid);
        
        %handles = guidata(hObject);
        handles = enhance(handles);
        handles = analyze(handles);
        %handles = guidata(hObject);
        
        %original = joinchannels('rgb', dip_image(frame));
        %decor = decoratePersons(original, handles);
        
        %displayMain(handles, dip_array(decor));
        displayOriginal(handles, handles.current_frame);
        displaySegmented(handles);
        displayAnalysis(handles);
        %displayFiltered(handles, toMatrix(3, enhanced{1}));
        %displayProcessed(handles, toMatrix(3, enhanced{2}, enhanced{2}));
        %displayProcessed(handles, handles.current_frame - handles.last_frame);
        displayStats(handles);
        
        % Update handles
        updates = guidata(hObject);
        handles.analyze = updates.analyze;
        %guidata(hObject, handles);
        
        
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
function update = captureCalib(handles)
    handles = getFrame(handles);
    handles.calib_img = handles.cframe;
    handles.lift_segmented = segmentLift(handles.calib_img);
    handles.lift_labeled = labelLift(handles.lift_segmented);
    handles.lift_msr = measure(handles.lift_labeled, [], {'Minimum', 'Maximum'}, [], ...
                               1, 300, 0);
    msr = handles.lift_msr; 
    if size(msr, 1) > 0
        minX = msr(1).Minimum(1);
        minY = msr(1).Minimum(2);
        maxX = msr(1).Maximum(1);
        maxY = msr(1).Maximum(2);
        handles.lift_bounds = [minX, minY; maxX, maxY];
    end
    update = handles;

% Returns a cell array containing the bounding-box of each label in the
% given image.
function boxes = getPersonBoundries(handles)
    msr = handles.persons_msr;
    nP = nnz(handles.persons_l2c);
    pIndices = find(handles.persons_l2c);
    boxes = cell(1, nP);
    for j=1:nP
        i = pIndices(j);
        minX = msr(i).Minimum(1);
        minY = msr(i).Minimum(2);
        maxX = msr(i).Maximum(1);
        maxY = msr(i).Maximum(2);
        box = [minX, minY; maxX, maxY];
        boxes{j} = box;
    end

% Draw rectangle representing the bounding-box around detected lift
% on a given img.
function decorated = decorateLift(img, handles)
    box = handles.lift_bounds;
    topleft = [box(1,1), box(1,2)];
    topright = [box(2,1), box(1,2)];
    botleft = [box(1,1), box(2,2)];
    botright = [box(2,1), box(2,2)];
    coords = [topleft; topright; botright; botleft];
    img{1} = drawpolygon(img{1}, coords, 255, 'closed');
    decorated = img;

% Draw rectangles representing the bounding-box around detected persons
% on a given img.
function decorated = decoratePersons(img, handles)
    bounding_boxes = getPersonBoundries(handles);
    for i=1:size(bounding_boxes, 2),
        box = bounding_boxes{i};
        topleft = [box(1,1), box(1,2)];
        topright = [box(2,1), box(1,2)];
        botleft = [box(1,1), box(2,2)];
        botright = [box(2,1), box(2,2)];
        coords = [topleft; topright; botright; botleft];
        img{2} = drawpolygon(img{2}, coords, 255, 'closed');
    end
    decorated = img;

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
    handles.fps = handles.loaded_video.FrameRate;
    handles.history = [0, 0, handles.UNKNOWN];
    handles.lv_frame_index = 1;
    set(handles.slider1, 'Min', 0, 'Max', ...
        handles.loaded_video.NumberOfFrames, 'SliderStep', ...
        [1 /(handles.loaded_video.NumberOfFrames/10), ...
         1 /(handles.loaded_video.NumberOfFrames/10)]);
    
    handles = captureCalib(handles);
    
    guidata(hObject, handles);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    handles.lv_frame_index = round(get(hObject,'Value'));
    if handles.lv_frame_index == 0
        handles.lv_frame_index = 1;
    end

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

