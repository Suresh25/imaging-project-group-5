% Returns a segmented image with lift-segments.
function res = segmentLift(img)
    thres = 2;
    derY = dyy(img);
    derX = dxx(img);
    
    derYR = derY{1} > thres;
    derXR = derX{1} > thres;
    
    derYG = derY{2} > thres;
    derXG = derX{2} > thres;
    
    derXB = derX{3} > thres;
    derYB = derY{3} > thres;
    
    
    resX = derXR & derXG & derXB;
    resY = derYR & derYG & derYB;
    
    res = resX | resY;