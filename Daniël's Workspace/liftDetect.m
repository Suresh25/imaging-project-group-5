function rgbCombo_labeled = liftDetect(img)
% Function liftDetect(img)
% img Is a RGB-color DIPImage object.
% Returns labeled binary image with lift and its doors labeled

%Split up the RGB image in the red channel, green channel and blue channel
%images.
img_red = img{1};
img_green = img{2};
img_blue = img{3};
%Set the threshold values for each type of channel
redThreshold = 70:130:200;
greenThreshold = 20:70:90;
blueThreshold = 40:40:80;
%Apply the thresholding to the red, green and blue channel image
redThresholded = threshold(img_red,'double',redThreshold);
greenThresholded = threshold(img_green,'double',greenThreshold);
blueThresholded = threshold(img_blue,'double',blueThreshold);
%Combine the images through a union to get the thresholding for the entire
%RGB-color image
rgbCombo = redThresholded&greenThresholded&blueThresholded;
%First part of the closing: dilation
rgbComboEnhanced = dilation(rgbCombo,2, 'elliptic');
%Second part of the closing: erosion
rgbComboEnhanced = erosion(rgbCombo, 2, 'elliptic');
%Apply a binary closing on the image to close small gaps in the objects
%instead of outside the objects
rgbComboEnhanced = bclosing(rgbComboEnhanced,20,-1,1);
%Label the objects that were found through the segmentation above and
%display the labeled image through DIPImage
rgbCombo_labeled = label(rgbComboEnhanced,Inf,200,0)