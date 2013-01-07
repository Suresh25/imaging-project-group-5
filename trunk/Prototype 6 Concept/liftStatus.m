function [status, update] = liftStatus(gui_handle)
    minX = gui_handle.lift_bounds(1,1);
    minY = gui_handle.lift_bounds(1,2);
    maxX = gui_handle.lift_bounds(2,1);
    
    status = gui_handle.UNKNOWN;
    
    g = gui_handle.current_frame(minY:minY+30, minX:maxX,2) < 50;
    g = erosion(g,4,'rectangular');
    msr = measure(g, [], {'size'}, [], ...
          1, 100, 0);
    if size(msr, 1) == 2
        if ~isequal(gui_handle.doors,[-1,-1])
            thres = 70;
            dif = gui_handle.doors-msr.Size;

            if any(dif > thres)
                status = gui_handle.OPENING;
            else if any(dif < -thres)
                    status = gui_handle.CLOSING;
                else if any(msr.Size > 500)
                        status = gui_handle.CLOSED;
                    else
                        status = gui_handle.OPEN;
                    end
                end
            end
        end
        gui_handle.doors = msr.Size;
    else
        gui_handle.doors = [100,100];
        status = gui_handle.OPEN;
    end
    
    update = gui_handle;