% labeling(img, gui_handle)
% imgs = Array with 2 Post-normalization & segmentation DIPImages.
%        Lift-segments at index 1.
%        Person-segments at index 2.
% gui_handle = the handles of the GUI.
% Returns: DIPImage array with lift and persons labeled.
function labels = labeling(imgs, gui_handle)
    labels = newimar(2);
    labels{1} = gui_handle.lift_labeled; %labelLift(imgs{1});
    labels{2} = labelPerson(imgs{2});