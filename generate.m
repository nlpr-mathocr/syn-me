clear all
clc
convert_im2uint8;
regular_imageformat;
extract_origin_boundingbox;
adjust_boundingbox;
distort_formulas;
clear; close all; clc
colorstyle = 0;
graystyle = 1;
binstyle = 2;
im_num = length(dir('color-tex-distort/*.png'));
[im_h, im_w, ~] = size(imread(strcat('color-tex-distort/1.png')));
half_h = floor(im_h / 2);
half_w = floor(im_w / 2);
% images
output_style = uint8(graystyle);
if output_style < 0 || output_style > 2
    disp('illegal color scheme');
    return
end

if output_style == graystyle
	if ~isdir('gray-tex-images/')
		mkdir('gray-tex-images');
	end
elseif output_style == binstyle
    if ~isdir('binary-tex-images/')
        mkdir('binary-tex-images');
    end
elseif output_style == colorstyle
    if ~isdir('color-tex-images/')
		mkdir('color-tex-images');
    end
end

%im_num = length(dir('color-tex-distort/*.png'));

bklib_num = length(dir('background/*.jpg'));

gray_contrast = 60;

sigma = 1; 
gausFilter = fspecial('gaussian',[3 3],sigma);
parfor i = 1 : im_num
    im_ori = imread(strcat('color-tex-distort/', num2str(i), '.png'));
    im_ori = double(rgb2gray(im_ori));
	if output_style == colorstyle
        bk = imread(strcat('background/', num2str(ceil(rand(1) * bklib_num)), '.jpg'));
        bk_mean = [mean(mean(bk(:,:,1))), mean(mean(bk(:,:,2))), mean(mean(bk(:,:,3)))];
        im1 = ((bk_mean(1) - gray_contrast) * rand(1)) * double(im_ori > 0);
        im2 = ((bk_mean(2) - gray_contrast) * rand(1)) * double(im_ori > 0);
        im3 = ((bk_mean(3) - gray_contrast) * rand(1)) * double(im_ori > 0);
        im = zeros(im_h, im_w, 3);
        im(:, :, 1) = im1;
        im(:, :, 2) = im2;
        im(:, :, 3) = im3;
        
		im = im + double(im == 0) .* double(bk);
		im = imfilter(im, gausFilter, 'replicate');
		im = uint8(im);
		imwrite(im, strcat('color-tex-images/', num2str(i), '.jpg'), 'jpg');
    elseif output_style == binstyle
        im = 255 * double(im_ori > 0);
		im = uint8(im);
		imwrite(im, strcat('binary-tex-images/', num2str(i), '.jpg'), 'jpg');
    elseif output_style == graystyle
        bk = rgb2gray(imread(strcat('background/', num2str(ceil(rand(1) * bklib_num)), '.jpg')));
        bk_mean = mean(bk(:));
        im = ((bk_mean - gray_contrast) * rand(1)) * double(im_ori > 0);
        im = im + double(im == 0) .* double(bk);
        im = imfilter(im, gausFilter, 'replicate');
		im = uint8(im);
		imwrite(im, strcat('gray-tex-images/', num2str(i), '.jpg'), 'jpg');
	end
	
    
    
end	