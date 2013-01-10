% normalise(img, gui_handle)
% img = 3D RGB matrix
% gui_handle = the handles of the GUI.
% Returns: A normalised DIPImage version of the input matrix.

function norm = normalise(gui_handle)
    j = gui_handle.current_frame;
    
    j(:,:,1) = posterize(j(:,:,1),32);
    j(:,:,2) = posterize(j(:,:,2),8);
    j(:,:,3) = posterize(j(:,:,3),16);
    
    norm = joinchannels('rgb', j);
   