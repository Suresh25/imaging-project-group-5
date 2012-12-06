function visible = liftVisible(labeled_img)
    % Some constants:
    % fractionLimit - More than this many labeled objects means the lift
    %                 is not visible.
    % minPerim - The minimum object's perimeter to be considered a lift.
    fractionLimit = 1;  
    minPerim = 1000;
    
    % Begin measurements:
    msr = measure(labeled_img, [], {'Size', 'Minimum', 'Maximum',... 
                                    'Perimeter'}, [], 1, 0, 0);
    numDetected = size(msr, 1);
    
    % Check for extreme fractions:
    if fractionLimit > numDetected
        visible = false;
        'fractionLimit breached.'
        return;
    end
    
    % Check largest object's perimeter:
    maxPerim = max(msr.perimeter);
    if maxPerim < minPerim
        visible = false;
        return;
    end
    
    visible = true;