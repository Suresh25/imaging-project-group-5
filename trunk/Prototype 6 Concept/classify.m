% classify(img, gui_handle)
% img = Labeled DIPImage array with persons labeled
% gui_handle = the handles of the GUI.
% Returns: Int array of length 2. First element is the # of persons in
%          the lift. Second element is the # of persons out the lift
function [info, update] = classify(gui_handle) 
%     function b = doorsAreOpen
%         timeSinceOpen = (gui_handle.frame_index - gui_handle.last_open) ...
%                          / gui_handle.fps;
%         b = timeSinceOpen >= gui_handle.DOOR_DELAY;
%     end

    inside = 0;
    outside = 0;
    
    msr = gui_handle.persons_msr;
    gui_handle.persons_l2c = zeros(1, size(msr, 1));
    
    east = gui_handle.lift_bounds(2, 1);
    west = gui_handle.lift_bounds(1, 1);
    north = gui_handle.lift_bounds(1, 2);
    south = gui_handle.lift_bounds(2, 2);
    
%     checkStatus = false;
    
    % Check per person if its box lies inside the boundries of the elevator: 
    for i = 1 : size(msr, 1)
        minX = msr(i).Minimum(1);
        minY = msr(i).Minimum(2);
        maxX = msr(i).Maximum(1);
        maxY = msr(i).Maximum(2);
        width = maxX - minX;
        height = maxY - minY;
        [figW, figH] = imsize(gui_handle.persons_segmented);
        % Conditions to check if labeled object is a false-positive:
        % 1. Width/height ratio is too thin.
        % 2. Bounding box is too small.
        % 3. Top edge of bounding box is located too low.
        % 4. Bottom edge of bounding box is located too high.
        if (width / height) < 0.2 || ...
           (width + height) < 100 || ...
            minY > figH * 0.6 || ...
            maxY < figH * 0.25
              continue;
        end
        
        % Shrink the box a bit to compensate for shadow-segmentation:
        ratio = 0.1;
        dx = maxX - minX;
        dy = maxY - minY;
        minXs = minX + dx * ratio;
        maxXs = maxX - dx * ratio;
        minYs = minY + dy * ratio;
        maxYs = maxY - dy * ratio;
        
        % If ratio is suspeciously wide check to see if 
        % more than one person is hiding in the segmented blob: 
        count = 1;
        if (width / height) > 0.7 || width > 80
            isolated = gui_handle.persons_labeled == i;
            cropped = isolated(minX:maxX, minY:maxY);
            count = headHunter(cropped);
        end
        gui_handle.persons_l2c(i) = count;
        w = maxXs - minXs;
        for j=minXs : w/count : maxXs - w/count
            shardWest = j;
            shardEast = shardWest + w/count;

            if west < shardWest && north < minYs && east > shardEast && south > maxYs
                inside = inside + 1;
%                 checkStatus = prevStatus == gui_handle.CLOSED;
            else
                outside = outside + 1;
            end
        end
    end
    
%     checkStatus = checkStatus || ...
%                   prevStatus == gui_handle.UNKNOWN || ...
%                  (prevStatus == gui_handle.OPEN && ...
%                   mod(gui_handle.lv_frame_index, 4) == 0);
%     if checkStatus
%         status = liftStatus(gui_handle);
%     else
%         status = prevStatus;
%     end
    [status gui_handle] = liftStatus(gui_handle);
    
    gui_handle.prev_door_status = gui_handle.door_status;
    gui_handle.door_status = status;
    
    if status == gui_handle.CLOSING || status == gui_handle.CLOSED
        inside = 0;
    end
%     if status == gui_handle.OPEN && prevStatus == gui_handle.OPENING
%         gui_handle.last_open = gui_handle.frame_index;
%     end
    
    info = [inside, outside, status];
    update = gui_handle;
end