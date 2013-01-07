function p = patchpat2(a, t)
    avg = zeros(length(a), 1);
    m = zeros(length(a), 1);
    m2 = zeros(length(a), 1);
    for g=1:length(a)
        from = g - t;
        to = g + t;
        if from < 1
            from = 1;
        end
        if to > length(a)
            to = length(a);
        end
        avg(g) = mean(a(from:to));
       
        %avg(g) = mean(a(from:to)); %mean([mean(a(from:to)), mode()]);
        
    end
    p = round(avg); 
    %p = round((a + p) / 2);
    %disp([a avg m p]);
end