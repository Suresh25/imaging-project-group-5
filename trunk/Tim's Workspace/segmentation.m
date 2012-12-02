function res = segmentation(a,liftBackground)
%a = uint8(a.*255);

dif1 = abs(liftBackground-a);
dif2 = abs(a-liftBackground);
%b = joinchannels('rgb',dif);

tres = 5/255;

temp = (dif1(:,:,1) > tres) | (dif1(:,:,2) > tres) | (dif1(:,:,3) > tres) | (dif2(:,:,1) > tres) | (dif2(:,:,2) > tres) | (dif2(:,:,3) > tres);
temp = berosion (temp,5,1,1);
temp = bdilation(temp,5,1,1);
%temp = berosion(temp,5,1,1);
res = dip_image(temp);

%res = dip_image(dif > 0);
%res = difr | difg | difb;
%  || (difg > 5) || (difb > 5)


%hsvImage = rgb2hsv(dif);  %# Convert the image to HSV space
%hsvImage(:,:,2) = 1;           %# Maximize the saturation
%res = hsv2rgb(hsvImage);  %# Convert the image back to RGB space

