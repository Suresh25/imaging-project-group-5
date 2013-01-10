% compute(info, gui_handle)
% info = Integer array of length 3. The first element is the # of persons
%        in the lift. The second element is the # of persons out the lift.
%        The last element is the lift-door status.
% gui_handle = the handles of a GUI.
% Returns: An updated GUI handle.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed on it.

function update = compute(info, gui_handle)
    deltaIn = 0;
    deltaOut = 0;
    deltaGone = 0;
    
    % Update the total traffic currently in view register:
    gui_handle.traffic_inview = info(1) + info(2);
    
    currentStatus = info(3);
    prevStatus = gui_handle.prev_door_status;
    
    nowOpen = currentStatus == gui_handle.OPEN;
    justClosed = currentStatus == gui_handle.CLOSED ...
                 && prevStatus == gui_handle.CLOSING;
    
    % If doors are open we need to register this frame's data:
    if nowOpen
        gui_handle.history = [gui_handle.history; info];
    % Else if the doors just closed, we need to process the data from last
    % round:
    elseif justClosed
        % Fix holes and smooth data using patchpat:
        inStream = patchpat(gui_handle.history(:, 1), 2);
        outStream = patchpat(gui_handle.history(:, 2), 2);
        
        din = diff(inStream);  % The first derivative of the stream.
        dout = diff(outStream);
        inPeeks = find(din);  % Indices of transitions in the stream.
        outPeeks = find(dout);
        s = 8;  % Sensitivity - more means more traffic will be detected.
        
        % People who left the frame will be shown as a -X in dout. Even
        % though they are technically still out the lift. We need to cycle
        % through the list and find those people and turn the -X to +X to
        % get a better approximation of outgoing traffic.
        for i=1:length(outPeeks)
            j = outPeeks(i);
            % The range-size to be searched in is dependent on the
            % Sensitivity variable:
            from = max([1, j - s]);
            to = min([length(dout), j + s]); 
            stip = din(from:to);
            if dout(j) < 0 && all(~(dout(j) + stip == 0)) && mean(stip) > 0.2
                deltaGone = deltaGone - dout(j);
                dout(j) = -dout(j);
            end
        end
        
        % Now we cycle through the din and try and match a transition +/-X
        % to a complementary transition in the dout +/-Y. Each transition
        % can be regarded as a person either exiting or entering the lift.
        for i=1:length(inPeeks)
            j = inPeeks(i);
    
            from = max(1, j - s);
            to = min(length(dout), j + s); 
            stip = dout(from:to);
            if din(j) ~= 0 && any(abs(din(j) + stip) < abs(din(j)))
                delta = max(sum(din(j) + stip == 0), abs(din(j)));
                if din(j) > 0
                    deltaIn = deltaIn + delta; % + din(j);
                else
                    deltaOut = deltaOut + delta; % - din(j);
                end
            end
        end
        
        % Reset the history in anticipation of next round:
        gui_handle.history = info;
        gui_handle.debug = mat2str([deltaIn, deltaOut, deltaGone]);
    end
    
    % Update the statistics registers:
    gui_handle.traffic_in = gui_handle.traffic_in + deltaIn;
    gui_handle.traffic_out = gui_handle.traffic_out + deltaOut;
    gui_handle.traffic_total = gui_handle.traffic_total + ... 
                               deltaIn + deltaOut;
    
    
    update = gui_handle;
end