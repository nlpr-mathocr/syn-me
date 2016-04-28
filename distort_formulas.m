clear; close all; clc
if ~isdir('color-tex-distort/')
    mkdir('color-tex-distort')
end

if ~isdir('distort-bbox-config/')
    mkdir('distort-bbox-config');
end

if ~isdir('distort-adjust-bbox-config/')
    mkdir('distort-adjust-bbox-config');
end

im_num = length(dir('color-tex-regular/*.png'));

target_h = 256;
target_w = 512;

template1 = [1 0; 0 1];
template2 = [1, 1; 1 1];
template3 = [1 1; 1 1];
tic

global_scale = 0.3333;

parfor i = 1 : im_num
    im = imread(strcat('color-tex-regular/', num2str(i), '.png'));
%     im = imdilate(im, template1);
    
    [ori_h, ori_w, ~] = size(im);
    target_im = zeros(target_h, target_w, 3);
    
    %% get tmp distort image
    
    scale = global_scale * max(min(normrnd(1, 0.1, 1, 2), 1.25), 0.75);
    theta = max(min(normrnd(0, 0.1, 1), pi / 36), -pi / 36); %(rand(1) - 0.5) * pi / 3;
    tmp_h0 = round(scale(1) * ori_h);
    tmp_w0 = round(scale(2) * ori_w);
    tmp_h = round(tmp_w0 * sin(abs(theta)) + tmp_h0 * cos(abs(theta)));
    tmp_w = round(tmp_w0 * cos(abs(theta)) + tmp_h0 * sin(abs(theta)));

    tmp_im = zeros(tmp_h, tmp_w, 3);
    
    [hh, ww] = meshgrid(1 : ori_h, 1 : ori_w);
    hh = hh(:);
    ww = ww(:);
    orix = ww - ori_w / 2;
    oriy = hh - ori_h / 2;
    tmpx = orix * scale(2);
    tmpy = oriy * scale(1);
    tarx = tmpx * cos(theta) - tmpy * sin(theta);
    tary = tmpy * cos(theta) + tmpx * sin(theta);
    tarx = min(max(round(tarx + tmp_w / 2), 1), tmp_w);
    tary = min(max(round(tary + tmp_h / 2), 1), tmp_h);
    
    tar_index0 = tary + (tarx - 1) * tmp_h;
    tar_index = [tar_index0, tar_index0 + tmp_h * tmp_w, tar_index0 + 2 * tmp_h * tmp_w];
    ori_index0 = hh + (ww - 1) * ori_h;
    ori_index = [ori_index0, ori_index0 + ori_h * ori_w, ori_index0 + 2 * ori_h * ori_w];
    
    tmp_im(tar_index) = im(ori_index);
    tmp_im = imdilate(tmp_im, template2);
    
    rh = max(ceil(rand(1) * (target_h - tmp_h)), 1);
    rw = max(ceil(rand(1) * (target_w - tmp_w)), 1);
    rhe = min(rh + tmp_h - 1, target_h);
    rwe = min(rw + tmp_w - 1, target_w);
    
    hh = rh : rhe;
    ww = rw : rwe;
    
    target_im(hh, ww, :) = tmp_im(max(min(round((hh - rh + 1) / (rhe - rh + 1) * tmp_h), tmp_h), 1), max(min(round((ww - rw + 1) / (rwe - rw + 1) * tmp_w), tmp_w), 1), :);
    
    target_im = uint8(target_im);
    target_im = imerode(target_im, template2);
    imwrite(target_im, strcat('color-tex-distort/', num2str(i), '.png'), 'png');
    
    %% distort bounding box
    bbox_config = load(strcat('bbox-config/bbox_', num2str(i), '.config'));
    labels = bbox_config(:, 1);
    hh = [bbox_config(:, 2), bbox_config(:, 2), bbox_config(:, 4), bbox_config(:, 4)];
    ww = [bbox_config(:, 3), bbox_config(:, 5), bbox_config(:, 5), bbox_config(:, 3)];
    
    orix = ww - ori_w / 2;
    oriy = hh - ori_h / 2;
    
    tmpx = orix * scale(2);
    tmpy = oriy * scale(1);
    
    tarx = tmpx * cos(theta) - tmpy * sin(theta);
    tary = tmpy * cos(theta) + tmpx * sin(theta);
    
    tarx = min(max(round(tarx + tmp_w / 2), 1), tmp_w);
    tary = min(max(round(tary + tmp_h / 2), 1), tmp_h);
% 
    tarx = min(max(round(tarx / tmp_w * (rwe - rw + 1)) + rw - 1, 1), rwe);
    tary = min(max(round(tary / tmp_h * (rhe - rh + 1)) + rh - 1, 1), rhe);
    
    distort_config = zeros(length(labels), 9);
    distort_config(:, 1) = labels;
    distort_config(:, 2 : end) = [tary(:, 1), tarx(:, 1), tary(:, 2), tarx(:, 2), tary(:, 3), tarx(:, 3), tary(:, 4), tarx(:, 4)]; % top left -> top right -> bottom right -> bottom left
    
    dlmwrite(strcat('distort-bbox-config/bbox_', num2str(i), '.config') ,distort_config, 'delimiter', '\t');
    
   %% distort adjust bounding box
    bbox_config = load(strcat('adjust-bbox-config/bbox_', num2str(i), '.config'));
    labels = bbox_config(:, 1);
    hh = [bbox_config(:, 2), bbox_config(:, 2), bbox_config(:, 4), bbox_config(:, 4)];
    ww = [bbox_config(:, 3), bbox_config(:, 5), bbox_config(:, 5), bbox_config(:, 3)];
    
    orix = ww - ori_w / 2;
    oriy = hh - ori_h / 2;
    
    tmpx = orix * scale(2);
    tmpy = oriy * scale(1);
    
    tarx = tmpx * cos(theta) - tmpy * sin(theta);
    tary = tmpy * cos(theta) + tmpx * sin(theta);
    
    tarx = min(max(round(tarx + tmp_w / 2), 1), tmp_w);
    tary = min(max(round(tary + tmp_h / 2), 1), tmp_h);
% 
    tarx = min(max(round(tarx / tmp_w * (rwe - rw + 1)) + rw - 1, 1), rwe);
    tary = min(max(round(tary / tmp_h * (rhe - rh + 1)) + rh - 1, 1), rhe);
    
    distort_config = zeros(length(labels), 9);
    distort_config(:, 1) = labels;
    distort_config(:, 2 : end) = [tary(:, 1), tarx(:, 1), tary(:, 2), tarx(:, 2), tary(:, 3), tarx(:, 3), tary(:, 4), tarx(:, 4)]; % top left -> top right -> bottom right -> bottom left
    
    dlmwrite(strcat('distort-adjust-bbox-config/bbox_', num2str(i), '.config') ,distort_config, 'delimiter', '\t');
end
toc



























