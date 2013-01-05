function liftStatus(gui_handle, img_data, hObject)
    minX = gui_handle.lift_bounds(1,1);
    minY = gui_handle.lift_bounds(1,2);
    maxX = gui_handle.lift_bounds(2,1);
    
    status = '';
    
    g = img_data(minY:minY+30, minX:maxX,2) < 50;
    g = erosion(g,4,'rectangular');
    msr = measure(g, [], {'size'}, [], ...
          1, 100, 0);
    if size(msr, 1) == 2
        if ~isequal(gui_handle.doors,[-1,-1])
            thres = 70;
            dif = gui_handle.doors-msr.Size;
            gui_handle.doors = msr.Size;

            if any(dif > thres)
                status = 'opening';
            else if any(dif < -thres)
                    status = 'closing';
                else if any(msr.Size > 500)
                        status = 'closed';
                    else
                        status = 'open';
                    end
                end
            end
        end
        gui_handle.doors = msr.Size;
    else
        gui_handle.doors = [100,100];
        status = 'open';
    end
    
    gui_handle.lift_status = status;
    guidata(hObject, gui_handle);