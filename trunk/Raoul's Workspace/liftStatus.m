% liftstatus(gui_handle)
% gui_handle = the handles of a GUI.
% Returns: current lift-status and an updated GUI handle.
% Effects: updates the doors' size in gui_handle.
function [status, update] = liftStatus(gui_handle)
    % get the boundingbox
    minX = gui_handle.lift_bounds(1,1);
    minY = gui_handle.lift_bounds(1,2);
    maxX = gui_handle.lift_bounds(2,1);
    maxY = gui_handle.lift_bounds(2,2);
    
    height = int8(0.2 *(maxY-minY));
    
    % default status: unknown
    status = gui_handle.UNKNOWN;
    
    % use color green for thresholding (2nd layer in current_frame)
    g = gui_handle.current_frame(minY:minY+height, minX:maxX, 2) < 50;
    % use an erosion to get rid of noise
    g = erosion(g,4,'rectangular');
    
    msr = measure(g, [], {'size'}, [], ...
          1, 100, 0);
      
    % check if there are two doors visible
    if size(msr, 1) == 2
        if ~isequal(gui_handle.doors,[-1,-1])
            thres = 70;
            
            % calculate the difference between the previous doors' size and
            % the current size
            dif = gui_handle.doors - msr.Size;

            % if the previous doors are more visible than the current
            % doors, the doors are opening
            if any(dif >= thres)
                status = gui_handle.OPENING;
                
            % if the previous doors are less visible than the current
            % doors, the doors are closing
            elseif any(dif < -thres)
                status = gui_handle.CLOSING;
                    
            % if the doors are large enough, the doors must be closed
            elseif any(msr.Size > 500)
                status = gui_handle.CLOSED;
                    
            % .. the doors must be open otherwise
            else
                status = gui_handle.OPEN;
            end
        end
        % update the doors' size to the current size for next iterations
        gui_handle.doors = msr.Size;
    else
        % if no doors are detected, the doors must be open
        status = gui_handle.OPEN;
        gui_handle.doors = [100,100];
    end
    
    % update gui_handle
    update = gui_handle;