% enhance(img_data)
% img_data = 3D RGB matrix containing pixel data
% gui_handle = the handles of a GUI.
% Returns: normalised & segmented image with lift- and person-segments.

function enhanced = enhance(img_data, gui_handle)
    normalised = normalise(img_data, gui_handle);
    
    %save normalised frame
    global last_frame_temp;
    last_frame_temp = normalised;
    
    segments = segment(normalised, gui_handle);
    enhanced = segments;