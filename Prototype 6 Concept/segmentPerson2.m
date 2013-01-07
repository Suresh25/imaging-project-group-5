% segmentPerson(img)
% img = Normalised DIPImage.
% gui_handle = the handles of a GUI.
% Returns: Segmented image (with person segments)

function segmented = segmentPerson2(gui_handle)
   % calculate difference between frame and saved background
    img = gui_handle.nframe;
    liftBackground = gui_handle.calib_img; 
    diff1 = img - liftBackground;
    diff2 = liftBackground - img;
    diff_thres = 70;
    
    r = diff1{1} > diff_thres;
    g = diff1{2} > diff_thres;
    b = diff1{3} > diff_thres;
    r2 = diff2{1} > diff_thres;
    g2 = diff2{2} > diff_thres;
    b2 = diff2{3} > diff_thres;
    
    temp = r | g | b | r2 | g2 | b2;
    %temp = erosion (temp, 7, 'elliptic');
    %temp = dilation(temp, 7, 'elliptic');
        
    % calculate movements
    %global last_frame;
    diffS = abs(img - joinchannels('rgb',gui_handle.last_frame));
    
    move_thres = 40;
    r = diffS{1} > move_thres;
    g = diffS{2} > move_thres;
    b = diffS{3} > move_thres;
    diff = r | g | b;
    
    %NC = [0 0 1 0 0; 0 0 1 0 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 1 1 1 1 1; 1 1 1 1 1; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 0 1 0 0; 0 0 1 0 0];
    NC = [0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0];
    %NC = [0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0;  0 0 1 1 1 0 0;  0 0 1 1 1 0 0;  0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 1 1 1 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0];
    %NC = [0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;0 1 0;];
    %NC = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    
    diff = dilation_se(diff, dip_image(NC, 'bin'));
    %diff = erosion(diff, 20, 'elliptic');
    diff2 = dilation(diff, 15, 'elliptic');
    
    %combine both calculations
    temp = dip_image(diff2 .* temp, 'bin');
    
    if gui_handle.door_status == gui_handle.OPEN
        minX = gui_handle.lift_bounds(1,1);
        minY = gui_handle.lift_bounds(1,2);
        maxX = gui_handle.lift_bounds(2,1);
        maxY = gui_handle.lift_bounds(2,2);
        temp(minX:maxX,minY:maxY) = dip_image(diff(minX:maxX,minY:maxY), 'bin'); 
    end
    
    temp = erosion (temp, 7, 'elliptic');
    temp = dilation(temp, 7, 'elliptic');
    
    segmented = dip_image(temp, 'bin');