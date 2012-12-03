% classify(img)
% img = Labeled DIPImage with persons labeled
% gui_handle = the handles of a GUI.
% Returns: Int array of length 2. First element is the # of persons in
%          the lift. Second element is the # of persons out the lift
function info = classify(img, gui_handle)
    inside = 0;
    outside = 0;
    
    % Calculate geometric center per person:
    msr = measure(img, [], {'Center'}, [], 1, 0, 0);
    
    % Retrieve the elevator boundry-box from the main-app:
    east = 270; % gui_handle.lift_bounds(1)
    west = 50;
    north = 20;
    south = 200;
    
    % Check per person if its center lies inside the boundries of the elevator: 
    for i = 1 : size(msr, 1)
        x = msr(i).center(1);
        y = msr(i).center(2);
        if west <= x <= east && north <= y <= south
            inside = inside + 1;
        else
            outside = outside + 1;
        end
    end
    
    info = [inside, outside];