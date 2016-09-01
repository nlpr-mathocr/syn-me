clear; clc
datalist = {''};
numlist = 144;
for i = 1 : length(datalist)
    dataset_name = datalist{i};
    im_num = numlist(i);
%     regular_imageformat(dataset_name, im_num);
%     extract_origin_boundingbox(dataset_name, im_num);
%     adjust_boundingbox(dataset_name, im_num);
    projective_formulas(dataset_name, im_num, 'norm'); % projective_formulas(datanum, imnum, 'proj');
    merge_with_background(dataset_name, im_num);
end

batch_write_densebox_data
draw_gt_bboxes
