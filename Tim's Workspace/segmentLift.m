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
    
    res = resX & resY;
    
    %res = rgb2gray(dip_array(img));
    %res = dip_image(res);
    
    %img = derR | derG | derB;
    %img = berosion(img,1,1,1); 
    %res = derXG | derYG;
    %res = derX > 10;
    %res = berosion(res,1,1,0);
    %res = bdilation(res,5,2,0);
    