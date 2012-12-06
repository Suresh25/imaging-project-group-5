% segmentPerson(img)
% img = Normalised DIPImage.
% gui_handle = the handles of a GUI.
% Returns: Segmented image (with person segments)

function segmented = segmentPerson(img, gui_handle)
    liftBackground = gui_handle.calib_img;
    diff1 = img - liftBackground;
    diff2 = liftBackground - img;
    diff_thres = 25;
    
    r = diff1{1} > diff_thres;
    g = diff1{2} > diff_thres;
    b = diff1{3} > diff_thres;
    r2 = diff2{1} > diff_thres;
    g2 = diff2{2} > diff_thres;
    b2 = diff2{3} > diff_thres;
    
    temp = r | g | b | r2 | g2 | b2;
    temp = erosion (temp, 7, 'elliptic');
    temp = dilation(temp, 7, 'elliptic');
    
    segmented = temp;