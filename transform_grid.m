function [dst_im, T] = transform_grid(im) % boxes should be n x 2
% clear; close all; clc
% im = imread('9_90030.jpg');
% boxes = [1 1; 512 1; 512 512; 1 512];
[imh, imw, ~] = size(im);
% im = double(im);

src_pts = [-1 -1; 1 -1; 1 1; -1 1];
dst_pts = 0.5 * (rand(4, 2) - 0.5) + src_pts;
src_img_pts = [1 1; imw 1; imw imh; 1 imh];
dst_img_pts = dst_pts - repmat(min(dst_pts), [4, 1]);
dst_img_pts(:, 1) = round(dst_img_pts(:, 1) * imw / 2);
dst_img_pts(:, 2) = round(dst_img_pts(:, 2) * imh / 2) + 1;

% figure
% hold on
% plot(src_pts(:, 1), src_pts(:, 2), '.')
% plot(dst_pts(:, 1), dst_pts(:, 2), 'r.')
Tform_stn = maketform('projective', src_pts, dst_pts);
Tform_img = maketform('projective', src_img_pts, dst_img_pts);
T = Tform_stn.tdata.T;

% T = T';
[src_gridx, src_gridy] = meshgrid(1 : imw, 1 : imh);
src_gridx = src_gridx(:) / imw * 2 - 1;
src_gridy = src_gridy(:) / imh * 2 - 1;
src_grid = [src_gridx, src_gridy, ones(length(src_gridx), 1)];
% src_boxes_gridx = boxes(:, 1) / imw * 2 - 1;
% src_boxes_gridy = boxes(:, 2) / imh * 2 - 1;
% src_boxes_grid = [src_boxes_gridx, src_boxes_gridy, ones(length(src_boxes_gridx), 1)];

dst_grid = src_grid * T;
% dst_boxes_grid = src_boxes_grid * T;
dst_grid = dst_grid';
% figure
% hold on
% plot(src_gridx, src_gridy, '.')
% plot(dst_grid(1, :), dst_grid(2, :), 'r.')

% dst_boxes_grid = dst_boxes_grid';
dst_grid(1, :) = dst_grid(1, :) ./ dst_grid(3, :);
dst_grid(2, :) = dst_grid(2, :) ./ dst_grid(3, :);
dst_grid(3, :) = dst_grid(3, :) ./ dst_grid(3, :);
% dst_boxes_grid(1, :) = dst_boxes_grid(1, :) ./ dst_boxes_grid(3, :);
% dst_boxes_grid(2, :) = dst_boxes_grid(2, :) ./ dst_boxes_grid(3, :);
% dst_boxes_grid(3, :) = dst_boxes_grid(3, :) ./ dst_boxes_grid(3, :);

% dst_w = round((max(dst_grid(1, :)) - min(dst_grid(1, :))) / 2 * imw);
% dst_h = round((max(dst_grid(2, :)) - min(dst_grid(2, :))) / 2 * imh);
% 
% dst_boxes_grid(1, :) = dst_boxes_grid(1, :) - min(dst_grid(1, :));
% dst_boxes_grid(2, :) = dst_boxes_grid(2, :) - min(dst_grid(2, :));
% dst_grid(1, :) = dst_grid(1, :) - min(dst_grid(1, :));
% dst_grid(2, :) = dst_grid(2, :) - min(dst_grid(2, :));

[dst_im, ~, ~] = imtransform(im, Tform_img, 'nearest');
% figure
% imshow(uint8(dst_im))

% 
% dst_boxes = boxes;
% dst_boxes(:, 1) = round(dst_boxes_grid(1, :) * imw / 2)';
% dst_boxes(:, 2) = round(dst_boxes_grid(2, :) * imh / 2)';
% dst_im = bitmapplot([dst_boxes(:, 2); dst_boxes(1, 2)], [dst_boxes(:, 1); dst_boxes(1, 1)],...
%     dst_im, struct('LineWidth', 3, 'Color', [1 0 0 1]));
% 
