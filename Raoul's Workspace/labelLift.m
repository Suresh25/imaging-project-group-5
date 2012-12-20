% labelLift(img)
% img = DIPImage with lift segments
% Returns: a labeled DIPImage with lift labeled.

function labeled = labelLift(img)
    % PLACEHOLDER:
    labeled = label(img, inf, 1500, 0);