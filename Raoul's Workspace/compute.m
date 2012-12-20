% compute(info, gui_handle)
% info = Integer array of length 2. The first element is the # of persons
%        in the lift. The second element is the # of persons out the lift.
% gui_handle = the handles of a GUI.
% Returns: An updated GUI handle.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed on it.

function handle = compute(info, gui_handle)
    function n = mostCommon(seconds, m)
        if strcmp(m, 'in')
            i = 1;
        else
            i = 2;
        end
        fps = 5;
        frames = round(fps * seconds);
        if frames > size(gui_handle.history, 1)
            frames = size(gui_handle.history, 1);
        end
        n = mode(gui_handle.history(1:frames, i));
    end
    
    deltaIn = 0;
    deltaOut = 0;
    currentIn = mostCommon(0.5, 'in');
    currentOut = mostCommon(0.5, 'out');
    
    gui_handle.traffic_inview = info(1) + 0.1 * info(2);
    
    approxIn = mostCommon(6, 'in');
    approxOut = mostCommon(6, 'out');
    
    if approxIn > 0 && currentIn == 0
        deltaIn = approxIn;
    elseif approxIn == 0 && currentIn > 0
        deltaOut = currentIn;
    end
    
    gui_handle.traffic_in = gui_handle.traffic_in + deltaIn;
    gui_handle.traffic_out = gui_handle.traffic_out + deltaOut;
    gui_handle.traffic_total = gui_handle.traffic_total + ... 
                               deltaIn + deltaOut;
    gui_handle.debug = num2str(size(gui_handle.history, 1));
    
    if deltaIn || deltaOut
        gui_handle.history = [0, 0];
    end
    
    gui_handle.history = [gui_handle.history; info];
    
    % Keep history in a fixed size:
    cache_size = 30;  % Has to be >= 2
    history_size = size(gui_handle.history, 1);
    if history_size > cache_size
        gui_handle.history = gui_handle.history(2: history_size, :);
    end
    
    handle = gui_handle;
end