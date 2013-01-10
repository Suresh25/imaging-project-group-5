% Function patchpat(a, t)
% a - An Nx1 matrix
% t - The maximum size of a 'hole' to be patched.
% Returns: a patched version of 'a'. Where holes in the sequence have been
% filled with either a neighbour, or average of neighbours.
% Example: patchpat([1; 1; 1; 0; 0; 1; 1; 0; 0; 0; 1; 2; 1; 2], 2) = 
% [1; 1; 1; 1; 1; 1; 1; 0; 0; 0; 1; 1; 1; 1]
function p = patchpat(a, t)
    %p = a;
    holes = diff(a);  % First derivative of 'a'.
    indices = find([0;holes;length(a)]);  % Indices of transitions
    i2 = 1;
    while i2 < length(indices)
        current = indices(i2);  % Index of current hole's start
        next = indices(i2 + 1);  % Index of next hole's start
        if next - current <= t  % If hole is small enough
            old = a(current : next-1);
            
            % If neighbour of hole is a long streak (relative to this
            % hole's length, the use it to fill the hole:
            if i2 > 1 && ...
             ((current - indices(i2 - 1)) / (next - current)) >= 4
                a(current : next-1) = a(current - 1);
            % Same for the other neighbour:   
            elseif i2 + 2 <= length(indices) && ...
             ((indices(i2 + 2) - next) / (next - current)) >= 4
                a(current : next-1) = a(next);
            
            % Otherwise use the average of the near area:
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
            
            % Sometimes after filling a hole, a new one is created before,
            % so it is advised to restart, but only if something was filled
            % in that previously was not:
            if ~isequal(old, a(current : next-1))
                holes = diff(a);
                indices = find([0;holes;length(a)]);
                i2 = 1;
            % Else just go on with the cycle:
            else
                i2 = i2 + 1;
            end
        else
            i2 = i2 + 1;
        end
    end
    p = a;
end