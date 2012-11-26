a = readim('c:\users\daniël\documents\tu delft\imaging project\svn\lift fotos\Lift_BG_1Persoon.tif','')
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
rghCombo_labeled = label(rghCombo,Inf,1000,0)
clear vid;