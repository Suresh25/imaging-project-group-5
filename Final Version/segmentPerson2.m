% segmentPerson(img)
% img = Normalised DIPImage.
% gui_handle = the handles of a GUI.
% Returns: Segmented image (with person segments)

function segmented = segmentPerson2(gui_handle)
    % Calculate difference between frame and saved background
    img = gui_handle.nframe;
    liftBackground = gui_handle.calib_img; 
    diff1 = img - liftBackground;
    diff2 = liftBackground - img;
    diff_thres = 70;
    
    % Threshold all calculated differences
    r = diff1{1} > diff_thres;
    g = diff1{2} > diff_thres;
    b = diff1{3} > diff_thres;
    r2 = diff2{1} > diff_thres;
    g2 = diff2{2} > diff_thres;
    b2 = diff2{3} > diff_thres;
    
    % Combine to one binair image
    temp = r | g | b | r2 | g2 | b2;
        
    % Calculate movements
    diffS = abs(img - joinchannels('rgb',gui_handle.last_frame));
    
    % Threshold all movements layers
    move_thres = 40;
    r = diffS{1} > move_thres;
    g = diffS{2} > move_thres;
    b = diffS{3} > move_thres;
    diff = r | g | b;
    
    % Make a long vertical structured element
    NC = [0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0; 0 1 1 1 0];
    
    diff = dilation_se(diff, dip_image(NC, 'bin'));
    %diff = erosion(diff, 20, 'elliptic');
    diff2 = dilation(diff, 15, 'elliptic');
    
    % Combine both calculations
    temp = dip_image(diff2 .* temp, 'bin');
    
    % If the lift is open, replace the combined binair image
    % Do this only on the place where the lift is placed
    % Replace with only movements
    if gui_handle.door_status == gui_handle.OPEN
        minX = gui_handle.lift_bounds(1,1);
        minY = gui_handle.lift_bounds(1,2);
        maxX = gui_handle.lift_bounds(2,1);
        maxY = gui_handle.lift_bounds(2,2);
        temp(minX:maxX,minY:maxY) = dip_image(diff(minX:maxX,minY:maxY), 'bin'); 
    end
    
    % Final erostion/dilation
    temp = erosion (temp, 7, 'elliptic');
    temp = dilation(temp, 7, 'elliptic');
    
    segmented = dip_image(temp, 'bin');