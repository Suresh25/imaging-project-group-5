% analyze(img)
% imgs = Array with 2 Post-normalization & segmentation DIPImages.
%        Lift-segments at index 1.
%        Person-segments at index 2.
% gui_handle = the handles of a GUI.
% Returns: Nothing.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed.

function update = analyze(gui_handle)
    gui_handle.persons_labeled = labelPerson(gui_handle.persons_segmented);
    gui_handle.persons_msr = measure(gui_handle.persons_labeled, [], ...
                                     {'Minimum', 'Maximum'}, [], ...
                                     2, 0, 0);
    
    [info, gui_handle] = classify(gui_handle);
    gui_handle = compute(info, gui_handle);
    
    % Update handles and history:
    update = gui_handle;