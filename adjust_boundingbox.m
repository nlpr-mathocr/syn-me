function adjust_boundingbox(data_num,im_num)
color_bbox=[data_num,'bbox-config/'];
color_adjust=[data_num,'adjust-bbox-config/'];
if ~isdir(color_adjust)
    mkdir(color_adjust);
end

parfor i = 1 : im_num
%     im = imread([color_regular, num2str(i), '.png']);
%     [im_h, im_w, ~] = size(im);
    
    orig_label_bb = load(strcat(color_bbox,'bbox_', num2str(i), '.config'));
    fp_adjt_bb = fopen(strcat(color_adjust,'bbox_', num2str(i), '.config'), 'w');
    for j = 1 : size(orig_label_bb, 1)
        label = orig_label_bb(j, 1);
        bboxes_j = adjust_bb_basedon_label(label, orig_label_bb(j, 2:5));
%         bboxes_j(:, 1) =  min( max(bboxes_j(:, 1), 1), im_h );
%         bboxes_j(:, 2) =  min( max(bboxes_j(:, 2), 1), im_w );
%         bboxes_j(:, 3) =  min( max(bboxes_j(:, 3), 1), im_h );
%         bboxes_j(:, 4) =  min( max(bboxes_j(:, 4), 1), im_w );
        for k = 1 : size(bboxes_j, 1)
             if label ~=98
             fprintf(fp_adjt_bb, '%.0f %.0f %.0f %.0f %.0f %g %g\n', ... 
                                 label, bboxes_j(k, 1), bboxes_j(k, 2), bboxes_j(k, 3), bboxes_j(k, 4),roundn((bboxes_j(k, 2)+bboxes_j(k, 4))/2,-1),roundn((bboxes_j(k, 1)+bboxes_j(k, 3))/2,-1)); % top left bottom right
             else
                  fprintf(fp_adjt_bb, '%.0f %.0f %.0f %.0f %.0f %g %g\n', ... 
                                 label, bboxes_j(k, 1), bboxes_j(k, 2), bboxes_j(k, 3), bboxes_j(k, 4),orig_label_bb(j,6),orig_label_bb(j,7)); 
             end
        end
    end 
    fclose(fp_adjt_bb);
end
end
