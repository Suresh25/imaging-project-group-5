% enhance(img_data)
% img_data = 3D RGB matrix containing pixel data
% gui_handle = the handles of a GUI.
% Returns: normalised & segmented image with lift- and person-segments.

function update = enhance(gui_handle)
    %normalised = normalise(img_data, gui_handle);
    
    %save normalised frame
    %global last_frame_temp;
    %last_frame_temp = normalised;
    
    %segments = segment(gui_handle., gui_handle);
    gui_handle.persons_segmented = segmentPerson(gui_handle);
    update = gui_handle;