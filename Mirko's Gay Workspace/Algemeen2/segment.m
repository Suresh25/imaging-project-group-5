% segment(img)
% img = Normalised DIPImage
% gui_handle = the handles of the GUI.
% Returns: Array with 2 segmented images lift-segments at index 1 and 
%          person-segments at index 2.

function segments = segment(img, gui_handle)
    segments = newimar(2);
    segments{1} = gui_handle.lift_segmented;
    segments{2} = segmentPerson(img, gui_handle);