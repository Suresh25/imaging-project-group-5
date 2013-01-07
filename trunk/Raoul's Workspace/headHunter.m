function count = headHunter(segmented)
    function p = pattern(n, minSize)
       p = -1;
       streak = 1;
       for k=2:size(n, 2)
           %current = n(k);
           lastN = n(k-1);
           lastP = p(size(p, 2));
           if n(k) == lastN
               streak = streak + 1;
           else
               streak = 1;
           end
           if n(k) ~= lastP || lastP == -1
               if streak >= minSize
                   p = [p,n(k)];
                   streak = 1;
               end
           end
       end
       p = p(1, 2:size(p, 2));
    end

    function b = isZigzag(n)
        b = true;
        for i=2:size(n, 2)
            if n(i) == n(i - 1)
                b = false;
                return;
            end
        end
    end

    cFilterSize = 11;
    [width, height] = imsize(segmented);
    heads = segmented(:, 1:height / 3);
    % Solidify the image a bit for optimal results
    se = repmat([0;1;0], 1, cFilterSize);
    se = dip_image(se, 'bin');
    solid = closing_se(heads, se);
    solid = fillholes(solid);
    
    
    % Cycle through scan-lines and find zig-zag patterns:
    numRows = imsize(solid, 2) - 1;
    numCols = imsize(solid, 1) - 1;
    samples = zeros(1, numRows);
    data = dip_array(solid);
    for ri=1:numRows
        rowdata = data(ri, :);
        headscan = (sum(rowdata) / numCols) < 0.8;
        p = pattern(rowdata, 10);
        if isZigzag(p) && headscan
            samples(ri) = sum(p);
        end
    end
    
    
    if nnz(samples) / (numRows) > 0.2
        average = sum(samples) / nnz(samples);
    else
        average = sum(samples) / (numRows);
    end
    
    count = round(average); %round(average - 0.3);
    %display(cropped);
    %disp(average);
    %disp(count);
end