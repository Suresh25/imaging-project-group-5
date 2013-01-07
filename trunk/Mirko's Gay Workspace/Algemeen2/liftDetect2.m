function seg_img = liftDetect2(img)
    thres = 15;
    delta = dx(img, 1);
    
    dxr = delta{1};
    dxg = delta{2};
    dxb = delta{3};
    
    post_thres = (dxr + dxg + dxb) > thres;
    post_cleanup = opening(post_thres, 3, 'elliptic');
    labeled = label(post_cleanup,Inf,100,0);
    msr = measure(labeled, [], {'Minimum', 'Maximum'});
    xMin = min(msr.Minimum(1,:));
    yMin = min(msr.Minimum(2,:));
    xMax = max(msr.Maximum(1,:));
    yMax = max(msr.Maximum(2,:));
    empty = newim(imsize(labeled));
    poly = drawpolygon(empty, [xMin, yMin; xMax, yMin;
                               xMax, yMax; xMin, yMax], ...
                       255, 'closed');
    seg_img = dilation(poly, 7, 'rectangular');
    
    