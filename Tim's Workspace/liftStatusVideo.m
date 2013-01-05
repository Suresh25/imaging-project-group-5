function res = liftStatusVideo(gui_handle, img_data)
    minX = gui_handle.lift_bounds(1,1);
    minY = gui_handle.lift_bounds(1,2);
    maxX = gui_handle.lift_bounds(2,1);
    
    res = img_data(minY:minY+30, minX:maxX,:);