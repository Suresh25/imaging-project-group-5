function res = segmentation(a,liftBackground)

dif = abs(liftBackground-a);
%b = joinchannels('rgb',dif);

tres = 5;

temp = (dif(:,:,1) > tres) | (dif(:,:,2) > tres) | (dif(:,:,3) > tres);
res = dip_image(temp)*255;

%res = dip_image(dif > 0);
%res = difr | difg | difb;
%  || (difg > 5) || (difb > 5)


%hsvImage = rgb2hsv(dif);  %# Convert the image to HSV space
%hsvImage(:,:,2) = 1;           %# Maximize the saturation
%res = hsv2rgb(hsvImage);  %# Convert the image back to RGB space

