function p = pattern(n, minSize)
       p = [-1];
       streak = 1;
       for k=2:size(n, 2)
           %current = n(k);
           lastN = n(k-1);
           lastP = p(size(p, 2));
           if n(k) == lastN
               streak = streak + 1;
           else
               streak = 1;
           end
           if n(k) ~= lastP || lastP == -1
               if streak >= minSize
                   p = [p,n(k)];
                   streak = 1;
               end
           end
       end
       p = p(1, 2:size(p, 2));
    end