function res = label(a)
labeled_img = label(a, Inf, 400, 0);
res = uint8(labeled_img);