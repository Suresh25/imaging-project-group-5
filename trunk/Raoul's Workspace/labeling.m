% labeling(img, gui_handle)
% imgs = Array with 2 Post-normalization & segmentation DIPImages.
%        Lift-segments at index 1.
%        Person-segments at index 2.
% gui_handle = the handles of the GUI.
% Returns: DIPImage array with lift and persons labeled.
function update = labeling(gui_handle)
    gui_handle.persons_labeled = labelPerson(gui_handle.persons_segmented);
    update = gui_handle;