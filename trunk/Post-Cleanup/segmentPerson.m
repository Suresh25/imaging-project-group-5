% segmentPerson(img)
% img = Normalised DIPImage.
% gui_handle = the handles of a GUI.
% Returns: Segmented image (with person segments)

function segmented = segmentPerson(img, gui_handle)
    liftBackground = gui_handle.calib_img;
    diff = img - liftBackground;
    diff_thres = 5;
    
    r = diff{1} > diff_thres;
    g = diff{2} > diff_thres;
    b = diff{3} > diff_thres;
    
    temp = r + g + b;
    %temp = erosion (temp, 5, 'elliptic');
    %temp = dilation(temp, 5, 'elliptic');
    
    segmented = temp;