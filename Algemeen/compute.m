% compute(info, gui_handle)
% img = Labeled DIPImage with lift & persons labeled.
% info = Integer array of length 2. The first element is the # of persons
%        in the lift. The second element is the # of persons out the lift.
% gui_handle = the handles of a GUI.
% Returns: Nothing.
% Effects: Uses gui_handle to change properties of the GUI, so that
%          relevant statistics will be displayed on it.
function compute(img, info, gui_handle)
    % TODO