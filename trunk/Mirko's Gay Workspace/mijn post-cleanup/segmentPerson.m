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
    %temp = erosion (temp, 7, 'elliptic');
    %temp = dilation(temp, 7, 'elliptic');
    
    %segment a part based on motion between 2 frames
    global last_frame;
    diffS = abs(img - last_frame);
    %diffS = diffS > 50;
    
    %diff = dip_image(diffS .* temp);
    r = diffS{1} > 25;
    g = diffS{2} > 25;
    b = diffS{3} > 25;
    diff = r | g | b;
    
    %NC = [0 0 1 0 0; 0 0 1 0 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 1 1 1 1 1; 1 1 1 1 1; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 0 1 0 0; 0 0 1 0 0];
    NC = [0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0;  0 0 1 1 1 0 0;  0 0 1 1 1 0 0;  0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0];
    %diff = convolve(diff, NC .* 1/38);
    diff = dilation_se(diff, dip_image(NC, 'bin'));
    %diff = dilation(diff, 10, 'elliptic');
    diff = erosion(diff, 20, 'elliptic');
    
    temp = dip_image(diff .* temp, 'bin');
    %temp = brmedgeobjs(temp,1);
    
    %temp = dilation(temp, 7, 'elliptic');
    temp = fillholes(temp, 2);
    
    
    segmented = temp;