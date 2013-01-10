% Function headHunter(segmented)
% segmented - segmented DIPimage with person segments.
% Returns: Approximation of number of people in image.
% Pre: The image is the exact bounding box of the segments contained
% within.
function count = headHunter(segmented)
    % Function pattern(n, minSize)
    % n - An 1xN matrix containing elements from the set {1,0}
    % minSize - A positive integer.
    % Returns: A compressed version of n, where repeated streaks longer
    % than minSize are treated as one single digit.
    % Example: pattern([0 0 0 1 1 0 1 1 1 1 1 0 0 0], 3) = [0 1 0]
    function p = pattern(n, minSize)
        p = -1;
        % Indices of transitions between 1's and 0's:
        indices = find(diff([double(n), 2]));  % 2 in the end so we can
                                               % identify the last streak
        prev = 0;
        for k=1:length(indices)
            lastP = p(size(p, 2));
            index = indices(k);
            if index - prev >= minSize && ...
              (n(index) ~= lastP || lastP == -1)
                    p = [p, n(index)];
            end
            prev = index;
        end
        p = p(1, 2:size(p, 2));  % Get rid of the dummy -1 at the start
    end
    
    % Get approximate head-section of the image
    [width, height] = imsize(segmented);
    heads = segmented(:, 1:height / 3);
    
    % Solidify the image a bit for optimal results
    se = repmat([0;1;0], 1, 11);
    se = dip_image(se, 'bin');
    solid = closing_se(heads, se);
    solid = fillholes(solid);
    
    
    % Cycle through scan-lines and count zig-zags in each row's pattern:
    numRows = imsize(solid, 2) - 1;
    numCols = imsize(solid, 1) - 1;
    samples = zeros(1, round(numRows / 2));
    data = dip_array(solid);
    for ri=1:2:numRows  % Skipping every other row for performance boost
        rowdata = data(ri, :);
        headscan = (sum(rowdata) / numCols) < 0.8;
        p = pattern(rowdata, 10);
        if headscan   % Prevents thin lines to be counted as heads
            samples(ri) = sum(p);
        end
    end
    
    % Ignore air above heads:
    if nnz(samples) / length(samples) > 0.2
        average = sum(samples) / nnz(samples);
    else
        average = sum(samples) / length(samples);
    end
    
    count = round(average);
end