function adjust_boundingbox(dataset_name, im_num)
ori_bbox_dir = [dataset_name, 'bbox-config/'];
adjust_bbox_dir = [dataset_name, 'adjust-bbox-config/'];
if ~isdir(adjust_bbox_dir)
    mkdir(adjust_bbox_dir);
end

for i = 1 : im_num
    if ~exist([ori_bbox_dir, 'bbox_', num2str(i), '.config'], 'file')
        continue
    end
    orig_label_bb = load([ori_bbox_dir, 'bbox_', num2str(i), '.config']);
    fp_adjt_bb = fopen([adjust_bbox_dir, 'bbox_', num2str(i), '.config'], 'w');
    for j = 1 : size(orig_label_bb, 1)
        adj_label_bb = adjust_bb_basedon_label(orig_label_bb(j, :));
        for bid = 1 : size(adj_label_bb, 1)
            fprintf(fp_adjt_bb, '%d %.1f %.1f %.1f %.1f %.1f %.1f\n', adj_label_bb(bid, 1), ...
                adj_label_bb(bid, 2), adj_label_bb(bid, 3), adj_label_bb(bid, 4), adj_label_bb(bid, 5), ...
                adj_label_bb(bid, 6), adj_label_bb(bid, 7));
        end
    end
    fclose(fp_adjt_bb);
end
