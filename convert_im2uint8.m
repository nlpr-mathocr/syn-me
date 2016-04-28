function [  ] =zhuanhua( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
im_num = length(dir('color-tex/*.png'));
mkdir('color-tex-uint8');
for i=1:im_num
    im = imread(strcat('color-tex/', num2str(i), '.png'));
    imagD = double(im);
    m = max(imagD(:)) ; 
    n = min(imagD(:)) ; 
    K = uint8((imagD-n)*255/(m-n));
    imwrite(K, strcat('color-tex-uint8/', num2str(i), '.png'), 'png');
end
end

