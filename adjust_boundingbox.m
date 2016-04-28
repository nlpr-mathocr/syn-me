clear; close all; clc
im_num = length(dir('color-tex-regular/*.png'));

if ~isdir('adjust-bbox-config')
    mkdir('adjust-bbox-config');
end

parfor i = 1 : im_num
    im = imread(strcat('color-tex-regular/', num2str(i), '.png'));
    [im_h, im_w, ~] = size(im);
    
    orig_label_bb = load(strcat('bbox-config/bbox_', num2str(i), '.config'));
    fp_adjt_bb = fopen(strcat('adjust-bbox-config/bbox_', num2str(i), '.config'), 'w');
    for j = 1 : size(orig_label_bb, 1)
        label = orig_label_bb(j, 1);
        bboxes_j = adjust_bb_basedon_label(label, orig_label_bb(j, 2:5));
        bboxes_j(:, 1) =  min( max(bboxes_j(:, 1), 1), im_h );
        bboxes_j(:, 2) =  min( max(bboxes_j(:, 2), 1), im_w );
        bboxes_j(:, 3) =  min( max(bboxes_j(:, 3), 1), im_h );
        bboxes_j(:, 4) =  min( max(bboxes_j(:, 4), 1), im_w );
        for k = 1 : size(bboxes_j, 1)
             fprintf(fp_adjt_bb, '%.0f %.0f %.0f %.0f %.0f\n', ... 
                                 label, bboxes_j(k, 1), bboxes_j(k, 2), bboxes_j(k, 3), bboxes_j(k, 4)); % top left bottom right
        end
    end 
    fclose(fp_adjt_bb);
end
