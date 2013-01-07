function count = headHunter(segmented)
    function se = repeatSE(mode, n, filterSize)
        se = 0;
        if strcmp(mode, 'h')
            se = zeros(size(n, 1), filterSize);
            for j=1:filterSize
                se(:, j) = n;
            end
        elseif strcmp(mode, 'v')
            se = zeros(filterSize, size(n, 2));
            for j=1:filterSize
                se(j, :) = n;
            end
        end
        
        se = dip_image(se, 'bin');
    end

    cFilterSize = 11;
    oFilterSize = 99;
    
    % Solidify the image a bit for optimal results
    se = repeatSE('h', [0;1;0], cFilterSize);
    solid = closing_se(segmented, se);
    solid = fillholes(solid);
    
    % Use the 'valley' between people's heads to forge our head-cutting
    % structuring element:
    se = repeatSE('v', [0,1,0], oFilterSize);
    
    cut = opening_se(solid, se);
    msr = measure(cut);
    
    sizeThreshold = 2500;
    count = 0;
    for i=1:size(msr, 1)
        if msr(i).Size > sizeThreshold
            count = count + 1;
        end
    end
    if count == 0
        count = 1;
    end
end