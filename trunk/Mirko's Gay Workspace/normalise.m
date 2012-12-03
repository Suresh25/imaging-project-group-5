function res = normalise(in, back, backN)
%global waar;

%i = rgb2hsv(i);

%j = rgb2hsv(in);
j = in;
%in = dip_image(j);
%a = dip_image(j(:,:,1));
%b = dip_image(j(:,:,2));
%c = dip_image(j(:,:,3));

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

%=== last normalize, with 2 background images===
if back ~= 'a'
    in = dip_image(in);
    backN = backN .* 255;
    
    %sum(sum(sum(in)))/(size(backN, 1) * size(backN, 2) * 3);
    
    nor = ~(abs(backn - in) > 20);
    j = back .* nor;
    l = in .* nor;
    totp = sum(sum(sum(nor)));
    gemj = sum(sum(sum(j))) / totp;
    geml = sum(sum(sum(l))) / totp;
    gemp = (gemj.*255) - geml;
    
    j = double((in + gemp)./255);
else
    j = j ./ 255;
    totp = size(j, 1) * size(j, 2) * 3;
    gemp = sum(sum(sum(j))) / totp;
    
    in = dip_image(in);
    tot = (125/255) / gemp;
    j = double((in.*tot)./255);
end

%j = double((in.*tot)./255);
j(j > 1) = 1;
j(j < 0) = 0;

%== older
%totm = sum(j,3)./375;

%a = dip_image((a.*tot));
%b = dip_image((b.*tot));
%c = dip_image((c.*tot));

%a = (a.*tot);
%b = (b.*tot);
%c = (c.*tot);

%a(a > 1) = 1;
%b(b > 1) = 1;
%c(c > 1) = 1;

    %a = a/255;
    %b = b/255;
    %c = c/255;

%dm = zeros(size(j, 1), size(j, 2), 3);
%dm(:,:,1) = a;
%dm(:,:,2) = b;
%dm(:,:,3) = c;


%res = double(in./255);
res = j;