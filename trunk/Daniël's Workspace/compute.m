% compute(info, gui_handle)
% info = Integer array of length 2. The first element is the # of persons
%        in the lift. The second element is the # of persons out the lift.
% gui_handle = the handles of a GUI.
% Returns: An updated GUI handle.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed on it.

function handle = compute(info, gui_handle)
    deltaIn = 0;
    deltaOut = 0;
    currentIn = info(1);
    currentOut = info(2);
    currentInView = info(3);
    
    gui_handle.traffic_inview = currentInView;
    
    approxIn = mode(gui_handle.history(:, 1, :));
    
    if approxIn > 0 && currentIn == 0
        deltaIn = approxIn;
    elseif currentIn > 0
        deltaOut = approxIn;
    end
    
    gui_handle.traffic_in = gui_handle.traffic_in + deltaIn;
    gui_handle.traffic_out = gui_handle.traffic_out + deltaOut;
    gui_handle.traffic_total = gui_handle.traffic_total + ... 
                               deltaIn + deltaOut;
    gui_handle.debug = num2str(size(gui_handle.history, 1));
    
    if deltaIn || deltaOut
        gui_handle.history = [0, 0, 0];
    end
    
    gui_handle.history = [gui_handle.history; info];
    
    % Keep history in a fixed size:
    cache_size = 30;  % Has to be >= 2
    history_size = size(gui_handle.history, 1);
    if history_size > cache_size
        gui_handle.history = gui_handle.history(2: history_size, :, :);
    end
    
    handle = gui_handle;