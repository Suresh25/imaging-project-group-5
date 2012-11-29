function labeled_img = liftDetect(img)
% liftDetect(img)
% img = Joined rgb dipimage.
% Returns labeled image (with lifts labeled)

r = img{1};
g = img{2};
b = img{3};
% Color-range of lift in normalised images:
r_thres = [70, 200];
g_thres = [40,  100];
b_thres = [40,  100];

% Generate rgb channels post threshold filter:
rt = threshold(r,'double',r_thres);
gt = threshold(g,'double',g_thres);
bt = threshold(b,'double',b_thres);

filtered_img = rt & gt & bt;

% Closing and re-label:
filtered_img = dilation(filtered_img,12, 'elliptic');
filtered_img = erosion(filtered_img, 12, 'elliptic');

labeled_img = label(filtered_img, Inf, 200, 0);
