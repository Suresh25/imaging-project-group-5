% Returns a segmented image with lift-segments.
function res = segmentLift(img)
    thres = 3;
    img = dip_image(rgb2gray(dip_array(img)));
    derY = dyy(img);
    derX = dxx(img);
%     
%     derYR = derY{1} > thres;
%     derXR = derX{1} > thres;
%     
%     derYG = derY{2} > thres;
%     derXG = derX{2} > thres;
%     
%     derXB = derX{3} > thres;
%     derYB = derY{3} > thres;
%     
%     
%     resX = derXR & derXG & derXB;
%     resY = derYR & derYG & derYB;
    resX = derX > thres;
    resY = derY > thres;
    res = resX | resY;