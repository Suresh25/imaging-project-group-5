function res = liftStatus(gui_handle, img_data)
    minX = gui_handle.lift_bounds(1,1);
    minY = gui_handle.lift_bounds(1,2);
    maxX = gui_handle.lift_bounds(2,1);
    
    res = '';
    
    g = img_data(minY:minY+30, minX:maxX,2) < 50;
    g = erosion(g,4,'rectangular');
    msr = measure(g, [], {'size'}, [], ...
          1, 50, 0);
    if size(msr, 1) == 2
        global doors;
        %disp(doors);
        %disp(msr.Size);
        if isequal(doors,[-1,-1])
            doors = msr.Size;
        else
            thres = 50;
            dif = doors-msr.Size;
            doors = msr.Size;
            %disp(dif);
            if any(dif > thres)
                res = 'opening';
            else if any(dif < -thres)
                    res = 'closing';
                else
                    res = 'closed';
                end
            end
        end
    else
        res = 'open';
    end