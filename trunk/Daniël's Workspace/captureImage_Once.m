start(vid)
data_color = getdata(vid, 1);
stop(vid)
a = joinchannels('rgb', dip_image(data_color))