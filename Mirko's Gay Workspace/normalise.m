function res = normalise(in, back)
global waar;

%i = rgb2hsv(i);

%j = rgb2hsv(in);
j = in;

a = dip_image(j(:,:,1));
b = dip_image(j(:,:,2));
c = dip_image(j(:,:,3));

%d = zeros(size(a,1), size(a,2), 3);
%d(:,:,0) = double(a);
%d(:,:,1) = double(b);
%d(:,:,2) = double(c);

%as = (a > 30) & (a < 250);
%bs = (c > 30) & (c < 250);

%d = as * bs;

%dm = zeros(size(j, 1), size(j, 2), 3);
%dm(:,:,1) = d;
%dm(:,:,2) = d;
%dm(:,:,3) = d;

%d = times(double(in*255), double(dm));
%d = dip_image(double(in(:,:,1)))*255;
%high = double(i + 0.1 < 255);
%out = ((100 < in(:,:,1) < 200) .* (100 < in(:,:,2) < 200));
%out = double(d);

%waar = false;

%b = b > 255;
%c = c > 125;

totp = size(j, 1) * size(j, 2);
gemp = sum(sum(sum(j))) / totp / 3;
tot = 125 / gemp;
if tot > 1
    tot = 1;
end
tot = 1;
%totm = sum(j,3)./375;

a = dip_image((a.*tot));
b = dip_image((b.*tot));
c = dip_image((c.*tot));

%if back ~= 'a'
%    a = histeq(double(a./255),imhist(back(:,:,1)));
%    b = histeq(double(b./255),imhist(back(:,:,2)));
%    c = histeq(double(c./255),imhist(back(:,:,3)));
%else
    a = a/255;
    b = b/255;
    c = c/255;
%end

dm = zeros(size(j, 1), size(j, 2), 3);
dm(:,:,1) = a;
dm(:,:,2) = b;
dm(:,:,3) = c;


res = dm;