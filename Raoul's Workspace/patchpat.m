function p = patchpat(a, t)
    p = a;
    holes = diff(a);
    indices = find([0;holes;length(a)]);
    visited = zeros(1,20);
    i2 = 1;
    counter = 0;
    while i2 < length(indices)
        current = indices(i2);
        next = indices(i2 + 1);
%         disp(a(current : next-1));
        if next - current <= t
            old = a(current : next-1);
            
            if i2 > 1 && ...
             ((current - indices(i2 - 1)) / (next - current)) >= 4
                a(current : next-1) = a(current - 1);
%                 i2 = i2 + 1;
            elseif i2 + 2 <= length(indices) && ...
             ((indices(i2 + 2) - next) / (next - current)) >= 4
                a(current : next-1) = a(next);
%                 i2 = i2 + 1;
            else
                sample = zeros(2, 1);
                if current - 1 >= 1
                    sample(1) = a(current - 1);
                end
                if next <= length(a)
                    sample(2) = a(next);
                end

                a(current : next-1) = round(mean(sample));
            end
            if ~isequal(old, a(current : next-1))  
                holes = diff(a);
                indices = find([0;holes;length(a)]);
                i2 = 1;
            else
                i2 = i2 + 1;
            end
        else
            i2 = i2 + 1;
        end
        counter = counter + 1;
    end
    p=a;
end