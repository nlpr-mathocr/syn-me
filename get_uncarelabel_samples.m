clear; close all; clc
uncarelabel = 31;
files = dir('tex-labels/*.png');
%% Ö»Õë¶ÔlabelµÄÍ¼Ïñ, only process label images
if ~isdir('uncare-labels/')
    mkdir('uncare-labels');
end
for i = 1 : length(files)
    ori_im = double(imread(strcat('tex-labels/', num2str(i), '.png')));
    exp_im = double(imread(strcat('expand-labels/', num2str(i), '.png')));
    dif_im = exp_im - ori_im;
    uncare_im = uint8(ori_im + double(dif_im > 0) * uncarelabel);
    imwrite(uncare_im, strcat('uncare-labels/', num2str(i), '.png'), 'png');
end












