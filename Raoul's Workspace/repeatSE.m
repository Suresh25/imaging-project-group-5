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
