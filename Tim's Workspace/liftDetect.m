function res = myLiftDetect(img)
    thres = 6;
    derY = dyy(img);
    derX = dxx(img);
    
    derYR = derY{1} > thres;
    derXR = derX{1} > thres;
    derYG = derY{2} > thres;
    derXG = derX{2} > thres;
    derXB = derX{3} > thres;
    derYB = derY{3} > thres;
    
    %img = derR | derG | derB;
    %img = berosion(img,1,1,1); 
    %res = derXG | derYG;
    res =  derXG | derYG | derXB | derYB;
    res = berosion(res,1,1,0);
    res = bdilation(res,5,2,0);