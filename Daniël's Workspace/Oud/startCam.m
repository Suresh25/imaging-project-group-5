vid = videoinput('winvideo', 1, 'RGB24_320x240');
get(vid);
src = getselectedsource(vid);
preview(vid)