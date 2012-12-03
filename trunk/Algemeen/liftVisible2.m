function visible = liftVisible2(labeled_img)
    % Some constants:
    % minArea = The area of the lift when closed.
    % segmentThreshold = Only objects with their size >= this will be
    % processed.
    
    minArea = 28000;
    segmentThreshold = 7000; 
    
    % Begin measurements:
    msr = measure(labeled_img, [], {'Size'}, [], 1, 0, 0);
    
    % Filter out small object-segments:
    filtered_msr = zeros(1, size(msr, 1));
    for i = 1:size(msr.size, 2)
        if msr(i).size >= segmentThreshold
            filtered_msr(1,i) = msr(i).size;
        end
    end
    
    if sum(filtered_msr) < minArea
        visible = false;
        return
    end
    
    visible = true;