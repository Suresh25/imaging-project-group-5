% compute(info, gui_handle)
% info = Integer array of length 2. The first element is the # of persons
%        in the lift. The second element is the # of persons out the lift.
% gui_handle = the handles of a GUI.
% Returns: An updated GUI handle.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed on it.

function update = compute2(info, gui_handle)
    deltaIn = 0;
    deltaOut = 0;
    deltaGone = 0;
   
    gui_handle.traffic_inview = info(1) + info(2);
    
    currentStatus = info(3);
    prevStatus = gui_handle.history(size(gui_handle.history, 1), 3);
    
    nowOpen = currentStatus == gui_handle.OPEN;
    justClosed = currentStatus == gui_handle.CLOSED ...
                 && prevStatus == gui_handle.OPEN;
    
    
    if nowOpen
        gui_handle.history = [gui_handle.history; info];
    elseif justClosed
        inStream = patchpat(gui_handle.history(:, 1), 2);
        outStream = patchpat(gui_handle.history(:, 2), 2);
        
        ignore = round(gui_handle.DOOR_DELAY * gui_handle.fps);
        din = diff(inStream(ignore : length(inStream) - ignore));
        dout = diff(outStream(ignore : length(outStream) - ignore));
        
        inPeeks = find(din);
        outPeeks = find(dout);
        s = 10;  % sensitivity
        for i=1:length(outPeeks)
            j = outPeeks(i);
            from = max([1, j - s]);
            to = min([length(dout), j + s]); 
            stip = din(from:to);
            if dout(j) < 0 && all(~(dout(j) + stip == 0))
                deltaGone = deltaGone - dout(j);
                dout(j) = -dout(j);
            end
        end
        disp(deltaGone);
        disp([din dout]);
        for i=1:length(inPeeks)
            j = inPeeks(i);
            from = max(1, j - s);
            to = min(length(dout), j + s); 
            stip = dout(from:to);
            if din(j) ~= 0 && any(din(j) + stip == 0) 
                if din(j) > 0
                    deltaIn = deltaIn + din(j);
                else
                    deltaOut = deltaOut - din(j);
                end
            end
        end
        
        gui_handle.history = info;
        gui_handle.debug = mat2str([deltaIn, deltaOut, deltaGone]);
    end
    
    
       
    gui_handle.traffic_in = gui_handle.traffic_in + deltaIn;
    gui_handle.traffic_out = gui_handle.traffic_out + deltaOut;
    gui_handle.traffic_total = gui_handle.traffic_total + ... 
                               deltaIn + deltaOut;
    
    
    update = gui_handle;
end