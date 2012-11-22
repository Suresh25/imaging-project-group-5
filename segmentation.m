function res = segmentation(a)
aDIPimage = joinchannels('rgb', dip_image(a));
res1 = liftDetect(aDIPimage);
res = uint8(res1);

