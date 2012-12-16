% labelPerson(img)
% img = DIPImage with person segments
% Returns: a labeled DIPImage with lift labeled.

function labeled = labelPerson(img)
    % PLACEHOLDER:
    labeled = label(img, 2, 200, 0);