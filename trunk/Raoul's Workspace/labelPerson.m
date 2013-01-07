% labelPerson(img)
% img = DIPImage with person segments
% Returns: a labeled DIPImage with lift labeled.

function labeled = labelPerson(img)
    %labeled = label(img, 2, 10000, 0);
%     temp = label(img, 2, 2000, 0);
%     msr = measure(temp, [], {'CartesianBox'}, [], 2, 2000, 0);
%     keep = [];  % Array of objectID's to keep in final image
%     i = 1;
%     while i <= size(msr, 1)
%         width = msr(i).CartesianBox(1);
%         height = msr(i).CartesianBox(2);
% 
% 
%         % If ratio is too thin do not keep:
%         if (width / height) >= 0.25
%             keep = [keep, i];
%         end
% 
%         i = i + 1;
%     end
%    
%     % Filter image and keep only ID's in 'keep':
%     %temp = temp > 0;
%     labeled = newim(imsize(temp), '');  
%     
%     for i=1:size(keep, 2)
%         labeled = labeled | (temp == keep(i));
%     end
   
    labeled = label(img, 2, 1600, 20000);