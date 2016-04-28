%%
clear; close all; clc
im = imread('tex-labels/1.png');
[im_h, im_w] = size(im);
im_num = length(dir('tex-labels/*.png'));
expplate = ones(3, 3);

%% images
filename = 'expand-images';
if ~isdir(filename)
    mkdir(filename)
end

parfor i = 1 : im_num
    im = imread(strcat('gray-tex-images/', num2str((i-1) * 500 + 1), '.png'));
    im_exp = imdilate(im, expplate);
    imwrite(im_exp, strcat(filename, '/', num2str((i-1) * 500 + 1), '.png'), 'png');
end





%% labels 
filename = 'expand-labels';
if ~isdir(filename)
    mkdir(filename)
end

parfor i = 1 : im_num
    im = imread(strcat('tex-labels/', num2str((i-1) * 500 + 1), '.png'));
    ori_lbl = unique(im);
    im_exp = imdilate(im, expplate);
    exp_lbl = unique(im_exp);
    if sum(ori_lbl ~= exp_lbl) > 0
        disp('fatal error');
        i
        break
    end
    %imwrite(im_exp, strcat(filename, '/', num2str((i-1) * 500 + 1), '.png'), 'png');
end





