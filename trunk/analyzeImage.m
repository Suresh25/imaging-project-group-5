%a = readim('c:\users\dani�l\documents\tu delft\imaging project\svn\lift fotos\Lift_BG_1Persoon.tif','')
a = readim('c:\users\dani�l\documents\tu delft\imaging project\svn\lift fotos\Lift_V3_0Personen.tif','')
%a = readim('c:\users\dani�l\documents\tu delft\imaging project\svn\lift fotos\Lift_V3_1Persoon.tif','')
b = a{1}
c = a{2}
d = a{3}
redThreshold = 130:70:200;
greenThreshold = 20:70:90;
blueThreshold = 40:40:80;
r = threshold(b,'double',redThreshold)
g = threshold(c,'double',greenThreshold)
h = threshold(d,'double',blueThreshold)
%rghCombo = r&g&h
rghCombo = r*g*h
n = 0;
while n < 8
rghComboEnhanced = dilation(rghCombo,7, 'elliptic');
n = n+1;
end
n = 0;
while n < 8
rghComboEnhanced = erosion(rghCombo, 7, 'elliptic');
n = n+1;
end
%rghCombo_labeled = label(rghCombo,Inf,400,0)
rghCombo_labeled = label(rghComboEnhanced,Inf,400,0)
%clear vid;