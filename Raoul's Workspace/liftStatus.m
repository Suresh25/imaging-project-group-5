function status = liftStatus(handles)
    minX = handles.lift_bounds(1,1);
    maxX = handles.lift_bounds(2,1);
    minY = handles.lift_bounds(1,2);
    mid = round((maxX - minX) / 2);
    w = floor((maxX - minX) * 0.15);
    img = handles.cframe;
    cropped = segmentLift(img(minX:maxX, minY + 10:minY + 30));
    
    % No lift in sight
    if sum(cropped) == 0 
        status = handles.UNKNOWN;
        return;
    end
    
    midcrop = cropped(mid - w:mid + w, :);
    se = repmat([0,1,0],15,1);
    se = dip_image(se, 'bin');
    edges = erosion_se(midcrop, se);
    blob = closing(edges, 5, 'elliptic');
    count = size(measure(blob), 1);
    
    if count > 0
        status = handles.CLOSED;
    elseif count == 0
        status = handles.OPEN;
    else
        status = handles.UNKNOWN;
    end