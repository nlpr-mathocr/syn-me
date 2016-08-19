clear; clc
datalist = {'1-', '2-', '3-', '4-', '5-', '61-', '62-', '7-', '8-', '91-', '92-', '93-', '94-', '95-'};
% numlist = [10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000];
for i = 1 : length(datalist)
    datanum = datalist{i};
    imnum = 10000;
    % convert_im2uint8(datanum, imnum);
    % regular_imageformat(datanum, imnum, 1);
    % extract_origin_boundingbox(datanum, imnum);
    % adjust_boundingbox(datanum, imnum);
    projective_formulas(datanum, imnum); % distort_formulas(datanum, imnum);
end
