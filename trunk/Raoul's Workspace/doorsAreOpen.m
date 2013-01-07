function b = doorsAreOpen(gui_handle)
    timeSinceOpen = (gui_handle.frame_index - gui_handle.last_open) ...
                     / gui_handle.fps;
    b = timeSinceOpen >= gui_handle.DOOR_DELAY;