function statTest(img, gui_handle)
    msr = measure(img,[],{'Size','Minimum','CartesianBox'},[],Inf,2000,0);
    c = size(msr);
    area = '-';
    ratios = '-';
    numObjects = num2str(c(1));
    if c(1) > 0
        area = num2str(msr.size);
        ratios = num2str(msr.CartesianBox(1));
    end
    
    set(gui_handle.Stats1, 'String', ...
        ['Oppervlakte: ', area, char(10), ...
         'Verhoudingen: ', ratios, char(10), ...
         'Aantalobjects: ', numObjects]);

    drawnow