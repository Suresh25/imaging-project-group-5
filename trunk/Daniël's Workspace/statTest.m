function statTest(img, gui_handle)
    msr = measure(img,[],{'Size','Minimum','CartesianBox'},[],Inf,2000,0);
    c = size(msr);
    area = '-';
    ratio1 = '-';
    ratio2 = '-';
    numObjects = num2str(c(1));
    if c(1) > 0
        area = num2str(msr.size);
        ratio1 = num2str(msr.CartesianBox(1));
        ratio2 = num2str(msr.CartesianBox(2));
    end
    
    set(gui_handle.Stats1, 'String', ...
        ['Oppervlakte: ', area, char(10), ...
         'Verhoudingen: ', ratio1, ':', ratio2, char(10), ...
         'Aantalobjects: ', numObjects]);

    drawnow