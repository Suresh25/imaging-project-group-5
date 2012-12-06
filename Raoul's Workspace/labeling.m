% labeling(img, gui_handle)
% imgs = Array with 2 Post-normalization & segmentation DIPImages.
%        Lift-segments at index 1.
%        Person-segments at index 2.
% gui_handle = the handles of the GUI.
% Returns: DIPImage with lift and persons labeled.
function labeled_img = labeling(imgs, gui_handle)
    % PLACEHOLDER:
    labeled_img = labelLift(imgs(1)) + labelPerson(imgs(2));