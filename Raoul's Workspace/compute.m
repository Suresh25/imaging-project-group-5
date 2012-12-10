% compute(info, gui_handle)
% img = Labeled DIPImage with lift & persons labeled.
% info = Integer array of length 2. The first element is the # of persons
%        in the lift. The second element is the # of persons out the lift.
% gui_handle = the handles of a GUI.
% Returns: Nothing.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed on it.

function compute(img, info, gui_handle)
    deltaIn = 0;
    deltaOut = 0;
    currentIn = info(1);
    currentOut = info(2);
    
    approxIn = mode(gui_handle.history(:, 1));
    
    if approxIn > 0 && currentIn == 0
        deltaIn = approxIn;
    elseif currentIn > 0
        deltaOut = approxIn;
    end
    
    gui_handle.traffic_in = gui_handle.traffic_in + deltaIn;
    gui_handle.traffic_out = gui_handle.traffic_out + deltaOut;
    gui_handle.traffic_total = gui_handle.traffic_total + ... 
                               deltaIn + deltaOut;
    
    if deltaIn || deltaOut
        gui_handle.history = [];
    end
    