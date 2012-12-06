% enhance(img_data)
% img_data = 3D RGB matrix containing pixel data
% gui_handle = the handles of a GUI.
% Returns: normalised & segmented image with lift- and person-segments.

function enhanced = enhance(img_data, gui_handle)
    % PLACEHOLDER:
    normalised = normalise(img_data, gui_handle);
    segments = segment(normalised, gui_handle);
    enhanced = segments;