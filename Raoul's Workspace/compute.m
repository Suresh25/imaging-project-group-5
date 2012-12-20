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
        endIndex = size(gui_handle.history, 1);
        startIndex = endIndex - frames;
        if startIndex < 1
            startIndex = 1;
        end
        
        disp(gui_handle.history(startIndex:endIndex, i));
        n = mode(gui_handle.history(startIndex:endIndex, i));
    end
    
    deltaIn = 0;
    deltaOut = 0;
    currentIn = mostCommon(0.5, 'in');
    currentOut = mostCommon(0.5, 'out');
    currentTotal = currentIn + currentOut;
    
    gui_handle.traffic_inview = info(1) + info(2);
    
    approxIn = mostCommon(6, 'in');
    approxOut = mostCommon(6, 'out');
    approxTotal = approxIn + approxOut;
    
    %if approxIn > 0 && currentIn == 0 && approxTotal > currentTotal
    %    deltaIn = approxIn;
    %end
    if currentIn < approxIn && currentOut > approxOut
        deltaOut = approxIn - currentIn;
    end
    
    gui_handle.traffic_in = gui_handle.traffic_in + deltaIn;
    gui_handle.traffic_out = gui_handle.traffic_out + deltaOut;
    gui_handle.traffic_total = gui_handle.traffic_total + ... 
                               deltaIn + deltaOut;
    gui_handle.debug = mat2str([currentIn, currentOut;
                                approxIn, approxOut]);
    
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