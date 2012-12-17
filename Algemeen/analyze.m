% analyze(img)
% imgs = Array with 2 Post-normalization & segmentation DIPImages.
%        Lift-segments at index 1.
%        Person-segments at index 2.
% gui_handle = the handles of a GUI.
% Returns: Nothing.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed.

function info = analyze(imgs, hObject, gui_handle)
    labels = labeling(imgs, gui_handle);
    info = classify(labels{2}, gui_handle);
    updated_handle = compute(info, gui_handle);
    
    % Update handles and history:
    gui_handle = updated_handle;
    guidata(hObject, gui_handle);
    