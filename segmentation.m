% segmentation(img_data)
% img_data = MxNx3 matrix containing pixel data
% Returns: segmented dipimage
function segmented = segmentation(img_data)
    img_joined = joinchannels('rgb', dip_image(img_data));
    
    % Get labeled image with lifts detected:
    img_lifts = liftDetect(img_joined);
    
    % Making segments (aka: lifts) visible using thresholding:
    segmented = threshold(img_lifts, 'fixed', 1);