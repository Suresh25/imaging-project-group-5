% compute(info, gui_handle)
% info = Integer array of length 2. The first element is the # of persons
%        in the lift. The second element is the # of persons out the lift.
% gui_handle = the handles of a GUI.
% Returns: An updated GUI handle.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed on it.

function update = compute(info, gui_handle)
    function n = mostCommon(m, sec_offset, sec_duration)
        if strcmp(m, 'in')
            i = 1;
        elseif strcmp(m, 'out')
            i = 2;
        else
            n = NaN;
            return;
        end
        fps = gui_handle.fps;
        offset = round(fps * sec_offset);
        frames = round(fps * sec_duration);
        endIndex = size(gui_handle.history, 1) - offset;
        startIndex = endIndex - frames + 1;
        if startIndex < 1
            startIndex = 1;
        end
       
        if startIndex >= endIndex
            n = 0;
        else
            sample = gui_handle.history(startIndex:endIndex, i);
            avg = sum(sample) / frames;
            if nnz(sample) / frames <= 0.2
                n = 0;
            else
                n = abs(round(avg - 0.1999));
            end
            disp(avg);
        end 
    end
    
    gui_handle.traffic_inview = info(1) + info(2);
     
    gui_handle.standby_in = gui_handle.standby_in + 1;
    gui_handle.standby_out = gui_handle.standby_out + 1;
    okIn = gui_handle.standby_in >= gui_handle.history_cap;
    okOut = gui_handle.standby_out >= gui_handle.history_cap;
    
    deltaIn = 0;
    deltaOut = 0;
   
    currentStatus = info(3);
    
    
%     lastOpen = find(gui_handle.history(:,3) == gui_handle.CLOSED, 1, 'last');
%     if size(gui_handle.history, 1) - lastOpen < 10
%         wasIn = nowIn;
%     else
%         wasIn = mostCommon('in', 0.4, 1);%mostCommon('in', 0, 3); 
%     end
    
    
%     delay = round(gui_handle.fps * gui_handle.DOOR_DELAY);
%     
%     tail = repmat(gui_handle.OPEN, delay, 1);
%     expected = [gui_handle.CLOSED; tail];
%     expected2 = [gui_handle.UNKNOWN; tail];
%     
%     to = size(gui_handle.history, 1);
%     from = to - delay;
%     if from <= 0
%         from = 1;
%     end
    timeSinceOpen = (gui_handle.frame_index - gui_handle.last_open) ...
                     / gui_handle.fps;
    if timeSinceOpen == gui_handle.DOOR_DELAY 
        inLiftAtStart = info(1); %mostCommon('in', 0, 0.8);
        gui_handle.snapshot = [inLiftAtStart, ...
                               gui_handle.traffic_in, ...
                               gui_handle.traffic_out];
    end
    
    inLiftAtStart = gui_handle.snapshot(1);
    inAtStart = gui_handle.snapshot(2);
    outAtStart = gui_handle.snapshot(3);
    inThisRound = -1;
    outThisRound = -1;
    
    nowOut = mostCommon('out', 0, 1);%mostCommon('out', 0, 1);
    wasOut = mostCommon('out', 1, 1);%mostCommon('out', 0, 2);
    nowIn = mostCommon('in', 0, 1); %mostCommon('in', 0, 1.5);
    if timeSinceOpen < gui_handle.DOOR_DELAY + 1.4
        wasIn = inLiftAtStart;
    else
        wasIn = mostCommon('in', 0.4, 1);%mostCommon('in', 0, 3);
    end
    nowTotal = nowIn + nowOut;
    wasTotal = wasIn + wasOut;
    
    if ~isequal(gui_handle.snapshot, [-1, -1, -1]);
        inThisRound = gui_handle.traffic_in - inAtStart;
        outThisRound = gui_handle.traffic_out - outAtStart;
        % Inaccuracy detected:
        %if outThisRound > inLiftAtStart
        %    gui_handle.snapshot(1) = outThisRound;
        %    inLiftAtStart = outThisRound;
        %end
        
        %if nowIn + outThisRound - inThisRound ~= inLiftAtStart
        %    gui_handle.snapshot(1) = nowIn + outThisRound - inThisRound;
        %    inLiftAtStart = nowIn + outThisRound - inThisRound;
        %end

        if currentStatus == gui_handle.OPEN && nowIn < wasIn ...
           && outThisRound < (max([wasIn, inLiftAtStart]) - nowIn) ...
           && nowOut > wasOut
            deltaOut = wasIn - nowIn;
        end
        if currentStatus == gui_handle.OPEN && nowIn > wasIn ...
           && inThisRound < (nowIn - wasIn)
            deltaIn = nowIn - wasIn;
        end
       
        if currentStatus == gui_handle.CLOSED
            gui_handle.snapshot = [-1, -1, -1];
        end
    end
       
    gui_handle.traffic_in = gui_handle.traffic_in + deltaIn;
    gui_handle.traffic_out = gui_handle.traffic_out + deltaOut;
    gui_handle.traffic_total = gui_handle.traffic_total + ... 
                               deltaIn + deltaOut;
    gui_handle.debug = mat2str([nowIn, nowOut;
                                wasIn, wasOut;
                          inLiftAtStart, inThisRound;
                          outThisRound, NaN]);
    
    if deltaIn
        gui_handle.standby_in = 0;
    end
    if deltaOut
        gui_handle.standby_out = 0;
    end
    
    gui_handle.history = [gui_handle.history; info];
    
    % Keep history in a fixed size:
    history_size = size(gui_handle.history, 1);
   
    if history_size > gui_handle.history_cap
        gui_handle.history = gui_handle.history(2: history_size, :);
    end
    
    update = gui_handle;
end