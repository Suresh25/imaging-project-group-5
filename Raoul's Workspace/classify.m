% classify(img, gui_handle)
% img = Labeled DIPImage array with persons labeled
% gui_handle = the handles of the GUI.
% Returns: Int array of length 2. First element is the # of persons in
%          the lift. Second element is the # of persons out the lift
function info = classify(img, gui_handle)
    inside = 0;
    outside = 0;
    
    % Calculate geometric center per person:
    msr = measure(img, [], {'Minimum', 'Maximum'}, [], ...
                  1, 0, 0);
    
    % Retrieve the elevator boundry-box from the main-app:
    east = gui_handle.lift_bounds(2, 1);
    west = gui_handle.lift_bounds(1, 1);
    north = gui_handle.lift_bounds(1, 2);
    south = gui_handle.lift_bounds(2, 2);
    
    % Check per person if its box lies inside the boundries of the elevator: 
    for i = 1 : size(msr, 1)
        minX = msr(i).Minimum(1);
        minY = msr(i).Minimum(2);
        maxX = msr(i).Maximum(1);
        maxY = msr(i).Maximum(2);
        % Shrink the box a bit to compensate for shadow-segmentation:
        ratio = 0.2;
        dx = maxX - minX;
        dy = maxY - minY;
        minX = minX + dx * ratio;
        maxX = maxX - dx * ratio;
        minY = minY + dy * ratio;
        maxY = maxY - dy * ratio;
        
        if west < minX && north < minY && east > maxX && south > maxY
            inside = inside + 1;
        else
            outside = outside + 1;
        end
    end
    
    info = [inside, outside];