% classify(img, gui_handle)
% img = Labeled DIPImage with persons labeled
% gui_handle = the handles of the GUI.
% Returns: Int array of length 2. First element is the # of persons in
%          the lift. Second element is the # of persons out the lift
function info = classify(img, gui_handle, objectList)
    inside = 0;
    outside = 0;
    timesShrunk = [];
    timesGrown = [];
    
    % Calculate geometric center per person:
    msr = measure(img, [], {'size', 'center'}, [], 1, 0, 0);
    
    % Retrieve the elevator boundry-box from the main-app:
    east = 270; % gui_handle.lift_bounds(1)
    west = 50;
    north = 20;
    south = 200;
    
    for i = 1 : size(msr, 1)
        for j = 1 : size(objectList, 1)
%         if( personObject within lift boundary)
%             if(area gets smaller && objectarea nears 0)        
%               personObjectsTotal decrease (automated already through labeling)
%               inside++
%             end
%         end
% 
%        if( personObject within lift boundary)
%             if(area gets bigger)
%               personObjectsTotal increase (automated already through labeling)
%               outside++
%             end
%        end
            x = msr(i).center(1);
            y = msr(i).center(2);
            %Check if object is situated at the same position as the
            %elevator
            if(west<= x <= east && north <= y <= south)
                %~~~if(msr(i).size < objectList(j).size && currentObjSizes(i) == 0) [original if-statement]~~~
                %Check if the object's size has decreased since the previous iteration
                if(msr(i).size < objectList(j).size)
                    timesShrunk(i) = timesShrunk(i) + 1;
                    %This if-statement might need to check how many times
                    %an object has grown in the meantime aswell for possibly
                    %better results
                    if(timesShrunk(i) >= 2)
                        inside = inside + 1;
                        disp('Person entered lift, current value of inside: ' + inside)
                    end
                end
            %~~~else if(msr(i).size > objectList(j).size && currentObjSizes(i) > 0) [original if-statement]~~~
            %Check if the object's size has increased since the previous iteration
            else if(msr(i).size > objectList(j).size)
                    timesGrown(i) = timesGrown(i) + 1;
                    %This if-statement might need to check how many times
                    %an object has shrunk in the meantime aswell for possibly
                    %better results
                    if(timesGrown(i) >= 2)
                        outside = outside + 1;
                        disp('Person left lift, current value of outside: ' + outside)
                    end
                end
            end
        end
    end
   
    handles.classificationPreviousObjectList = msr;
    
    info = [inside, outside];