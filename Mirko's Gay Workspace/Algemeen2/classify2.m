function info = classify2(img, gui_handles)
    inside = 0;
    outside = 0;
    
    % Calculate geometric center per person:
    msr = measure(img, [], {'Center'}, [], 1, 0, 0);
    
    % Retrieve the elevator boundry-box from the main-app:
    east = gui_handle.lift_bounds(2, 1);
    west = gui_handle.lift_bounds(1, 1);
    north = gui_handle.lift_bounds(1, 2);
    south = gui_handle.lift_bounds(2, 2);
    
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