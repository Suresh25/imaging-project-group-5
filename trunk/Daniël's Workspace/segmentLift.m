% segmentLift(img)
% img = Normalised DIPImage.
% gui_handle = the handles of a GUI.
% Returns: Segmented image (with lift segments)

function segmented = segmentLift(img, gui_handle)
    r = img{1};
    g = img{2};
    b = img{3};
    
    % Color-range of lift in normalised images:
    r_thres = [70, 240];
    g_thres = [40, 100];
    b_thres = [40, 100];

    % Generate rgb channels post threshold filter:
    rt = threshold(r, 'double', r_thres);
    gt = threshold(g, 'double', g_thres);
    bt = threshold(b, 'double', b_thres);

    filtered_img = rt & gt & bt;

    % Closing and re-label:
    filtered_img = dilation(filtered_img, 4, 'elliptic');
    filtered_img = erosion(filtered_img, 4, 'elliptic');

    segmented = ~filtered_img;