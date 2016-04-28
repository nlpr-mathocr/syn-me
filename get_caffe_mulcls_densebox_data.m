clear; close all; clc
colorstyle = 0;
im_num = length(dir('color-tex-distort/*.png'));
[im_h, im_w, ~] = size(imread(strcat('color-tex-distort/1.png')));

if ~isdir('color-tex-distort-jpg')
    mkdir('color-tex-distort-jpg');
end

if ~isdir('densebox-label')
    mkdir('densebox-label');
end

ratio_train_samples = 0.9;
num_train_sample = floor(ratio_train_samples * im_num);
fobj_densebox_label_train = fopen('densebox-label/train-mulcls.txt', 'w');
fobj_densebox_label_test  = fopen('densebox-label/test-mulcls.txt',  'w');
for i = 1 : im_num
    distorted_boxes = load(['distort-adjust-bbox-config/bbox_' num2str(i) '.config']);
    cls      = distorted_boxes(:, 1);
    tops     = min (distorted_boxes(:,2:2:8), [], 2);
    bottoms  = max (distorted_boxes(:,2:2:8), [], 2);
    lefts    = min (distorted_boxes(:,3:2:9), [], 2);
    rights   = max (distorted_boxes(:,3:2:9), [], 2);
    cxs      = (lefts + rights ) / 2;
    cys      = (tops + bottoms ) / 2;
    
    if (i <= num_train_sample)
        fobj_densebox_output = fobj_densebox_label_train;
    else
        fobj_densebox_output = fobj_densebox_label_test;
    end
    fprintf(fobj_densebox_output, '%d', i);
    for j = 1:length(tops)
        for k = 1:32
            fprintf(fobj_densebox_output, ' -1.00');
        end
        fprintf(fobj_densebox_output, ' %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f', ...
                lefts(j), tops(j), rights(j), tops(j), rights(j), bottoms(j), lefts(j), bottoms(j), cxs(j), cys(j));
        fprintf(fobj_densebox_output, ' 0 0 %d %d', cls(j), cls(j));
        fprintf(fobj_densebox_output, ' %d %d', im_w, im_h);
    end
    fprintf(fobj_densebox_output, '\n');
        
end
fclose(fobj_densebox_label_train);
fclose(fobj_densebox_label_test);





















