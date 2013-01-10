function Y = posterize(x, N)
%
% POSTERIZE   Reduces number of colors in an image.
%
%    Y = POSTERIZE(X,N) creates the image Y by reduncing the number
%    of different colors of X to N. The N color values of Y are evenly
%    spaced in the same range as the values of X, however Y has only N 
%    different values. The values of X are rounded to the closet allowed
%    values of Y.
%
%   Function taken from:
%   http://www.mathworks.nl/matlabcentral/fileexchange/1362-posterize/content/posterize.m
%
%   Edited to what we only need

% Change to double
if ~isa(x,'double')
   x = double(x);
end

% Get the max and min values in the frame
M = max(x(:));
m = min(x(:));

Y = round((x-m)/(M-m) * (N-1)); % Separete in N levels from 0 to N-1

Y = Y/(N-1); % Scales/normalize value back to 0 to 1

Y = Y*255;  % Scale to 0 to 255

Y = round(Y); % Rounds to ints