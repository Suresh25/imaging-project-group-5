% segmentPerson(img)
% img = Normalised DIPImage.
% gui_handle = the handles of a GUI.
% Returns: Segmented image (with person segments)

function segmented = segmentPerson(img, gui_handle)
    grayCurrent = dip_image(rgb2gray(gui_handle.current_frame));
    grayPrev = dip_image(rgb2gray(gui_handle.prev_frame));
    grayCalib = dip_image(rgb2gray(dip_array(gui_handle.calib_img)));
    delta = grayCurrent - grayCalib;
    delta2 = grayCalib - grayCurrent;
    movement = grayCurrent - grayPrev;
    movement2 = grayPrev - grayCurrent;
    thres = 120;
    moveThres = 15;
    
    post_thres = movement > moveThres | movement2 > moveThres;
    dilated = dilation(post_thres, 10, 'diamond');
    segmented = closing(dilated, 14, 'elliptic');
    