function res = labeling(a)
labeled_img = label(a, Inf, 200, 0);
res = uint8(labeled_img);