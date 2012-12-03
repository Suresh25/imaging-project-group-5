% toMatrix(n, img1, ...)
% n = Positive integer.
% imgX = A dipimage.
% Pre: all argument-images have the same dimensions. n >=  number of imgX
%      arguments.
% Returns: An AxBxN array where AxB is the dimension of the input arguments
% and N is equals to the first input argument n.
function matrixForm = toMatrix(varargin)
    n = varargin{1};
    sample = dip_array(varargin{2}, 'uint8');
    matrixForm = zeros(size(sample, 1), size(sample, 2), n);
    for i = 1:nargin - 1
        matrixForm(:,:,i) = dip_array(varargin{i + 1}, 'uint8');
    end