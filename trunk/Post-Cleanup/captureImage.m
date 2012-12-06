vid = videoinput('winvideo', 1, 'RGB24_320x240');
start(vid)
data_color = getdata(vid, 1);
stop(vid)
a = joinchannels('rgb', dip_image(data_color))
b = a{1}
c = a{2}
d = a{3}
redThreshold = 130:70:200;
greenThreshold = 20:30:50;
blueThreshold = 20:30:50;
r = threshold(b,'double',redThreshold)
g = threshold(c,'double',greenThreshold)
h = threshold(d,'double',blueThreshold)
rghCombo = r&g&h
rghCombo_labeled = label(rghCombo,Inf,200,0)
clear vid;