% enhance(img_data)
% img_data = 3D RGB matrix containing pixel data
% gui_handle = the handles of a GUI.
% Returns: normalised & segmented image with lift- and person-segments.

function update = enhance(gui_handle)
    gui_handle.nframe = normalise(gui_handle);
    
    mirko = 0;
    if mirko
        gui_handle.persons_segmented = segmentPerson2(gui_handle);
    else
        gui_handle.persons_segmented = segmentPerson(gui_handle);
    end
    
    update = gui_handle;