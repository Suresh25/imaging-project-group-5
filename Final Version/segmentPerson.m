% segmentPerson(img)
% img = Normalised DIPImage.
% gui_handle = the handles of a GUI.
% Returns: Segmented image (with person segments)

function segmented = segmentPerson(gui_handle)
    gray_current = dip_image(rgb2gray(gui_handle.current_frame));
    gray_last = dip_image(rgb2gray(gui_handle.last_frame));
    
    delta_move = abs(gray_current - gray_last) > 15;
    delta_move = dilation(delta_move, 5, 'rectangular');
    
     
    segmented = delta_move;