% analyze(img)
% imgs = Array with 2 Post-normalization & segmentation DIPImages.
%        Lift-segments at index 1.
%        Person-segments at index 2.
% gui_handle = the handles of a GUI.
% Returns: Nothing.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed.

function analyze(imgs, gui_handle)
    labeled_img = labeling(imgs);
    info = classify(labeled_img, gui_handle);
    compute(info, gui_handle);