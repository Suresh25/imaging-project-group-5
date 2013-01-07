function res = liftStatus(gui_handle, img_data)
    minX = gui_handle.lift_bounds(1,1);
    minY = gui_handle.lift_bounds(1,2);
    maxX = gui_handle.lift_bounds(2,1);
    
    res = '';
    
    global doors;    
    
    g = img_data(minY:minY+30, minX:maxX,2) < 50;
    g = erosion(g,4,'rectangular');
    msr = measure(g, [], {'size'}, [], ...
          1, 100, 0);
    if size(msr, 1) == 2
        if isequal(doors,[-1,-1])
            doors = msr.Size;
        else
            thres = 70;
            dif = doors-msr.Size;
            doors = msr.Size;
            
            if any(dif > thres)
                res = 'opening';
            else if any(dif < -thres)
                    res = 'closing';
                else if any(msr.Size > 500)
                        res = 'closed';
                    else
                        res = 'open';
                    end
                end
            end
        end
    else
        doors = [100,100];
        res = 'open';
    end