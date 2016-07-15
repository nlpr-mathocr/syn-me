function [  ] = convert_im2uint8(data_num,im_num)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%im_num = length(dir('color-tex/*.png'));
color_tex=[data_num,'color-tex/'];
color_uint8=[data_num,'color-tex-uint8/'];
mkdir(color_uint8);
parfor i=1:im_num
    im = imread([color_tex, num2str(i), '.png']);
    imagD = double(im);
    m = max(imagD(:)) ; 
    n = min(imagD(:)) ; 
    K = uint8((imagD-n)*255/(m-n));
    imwrite(K, [color_uint8, num2str(i), '.png'], 'png');
end
end

