function extract_origin_boundingbox(dataset_name, im_num)
color_image_dir = [dataset_name, 'color-tex-regular/'];
ori_config_dir = [dataset_name, 'tex_config/'];
ori_bbox_dir = [dataset_name, 'bbox-config/'];
if ~isdir(ori_bbox_dir)
    mkdir(ori_bbox_dir);
end

for imid = 1 : im_num
    im = imread([color_image_dir, num2str(imid), '.png']);
    config_info = load([ori_config_dir, 'tex_', num2str(imid), '.config']);
    hsvim = rgb2hsv(im);
    fp = fopen([ori_bbox_dir, 'bbox_', num2str(imid), '.config'], 'w');
    for config_info_i = 1 : size(config_info, 1)
        label = config_info(config_info_i, 1);
        hval = config_info(config_info_i, 2);
        
        labelmap = (abs(hsvim(:, :, 1) - hval) < 0.006 & hsvim(:, :, 2) > 0);
        tmplabelmap = double(labelmap > 0);
        if sum(tmplabelmap(:)) == 0
            continue;
        end
        labelmap = bwlabel(labelmap);
        output_bboxes = extract_symbol_bboxes(labelmap, label, imid);
        for bid = 1 : size(output_bboxes, 1)
            output_bbox = output_bboxes(bid, :);
            fprintf(fp, '%d %.1f %.1f %.1f %.1f %.1f %.1f\n', output_bbox(1), ...
                output_bbox(2), output_bbox(3), output_bbox(4), output_bbox(5), ...
                output_bbox(6), output_bbox(7));
        end
    end
    fclose(fp);
end

