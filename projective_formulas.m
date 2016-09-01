function projective_formulas(dataset_name, im_num, proj_type)
regular_image_dir = [dataset_name, 'color-tex-regular/'];
projective_image_dir = [dataset_name, 'projective-tex-images/'];
projective_param_dir = [dataset_name, 'projective-param/'];
adjust_bbox_dir = [dataset_name, 'adjust-bbox-config/'];
undisturbed_bbox_dir = [dataset_name, 'undisturbed-bbox-config/'];
disturbed_bbox_dir = [dataset_name, 'disturbed-bbox-config/'];

mkdir(projective_image_dir)
mkdir(projective_param_dir);
mkdir(undisturbed_bbox_dir);
mkdir(disturbed_bbox_dir);


target_w = 512;
target_h = 512;
stand_w = 32;
stand_h = 32;
if strcmp(proj_type, 'proj')
    global_deviate = 1;
elseif strcmp(proj_type, 'norm')
    global_deviate = 0;
else
    error('Invalid proj_type : either proj or norm');
end

for imid = 1 : im_num
    cfgname = [adjust_bbox_dir, 'bbox_', num2str(imid), '.config'];
    imname = [num2str(imid), '.png'];
    if ~exist(cfgname, 'file') || ~exist([regular_image_dir, num2str(imid), '.png'], 'file')
        continue;
    end
    im = imread([regular_image_dir, num2str(imid), '.png']);
    
    bboxes = load(cfgname);
    %     % swap centerx centery
    %     tmp = bboxes(:, 6);
    %     bboxes(:, 6) = bboxes(:, 7);
    %     bboxes(:, 7) = tmp;
    
    bbox_hs = zeros(1, size(bboxes, 1));
    bbox_ws = zeros(1, size(bboxes, 1));
    for bid = 1 : size(bboxes, 1)
        bbox_hs(bid) = bboxes(bid, 4) - bboxes(bid, 2) + 1;
        bbox_ws(bid) = bboxes(bid, 5) - bboxes(bid, 3) + 1;
    end
    bbox_h = median(bbox_hs);
    bbox_w = median(bbox_ws);
    base_scl = min(sqrt((stand_w * stand_w + stand_h * stand_h) ...
        / (bbox_w * bbox_w + bbox_h * bbox_h)), 0.75 * target_w / size(im, 2));
    im = imresize(im, base_scl, 'nearest');
    if max(size(im)) > min(target_h, target_w)
        disp(['Invalid Image Size : ', imname]);
        continue
    end
    
    bboxes(:, 2 : end) = ceil(bboxes(:, 2 : end) * base_scl);
    
    ori_top = ceil(target_h / 2 - size(im, 1) / 2);
    ori_bottom = ori_top + size(im, 1) - 1;
    ori_left = ceil(target_w / 2 - size(im, 2) / 2);
    ori_right = ori_left + size(im, 2) - 1;
    
    bboxes(:, [2, 4, 6]) = bboxes(:, [2, 4, 6]) + ori_top - 1;
    bboxes(:, [3, 5, 7]) = bboxes(:, [3, 5, 7]) + ori_left - 1;
    
%     bboxes(:, [2, 4, 6]) = min(max(bboxes(:, [2, 4, 6]), 1), size(im, 1));
%     bboxes(:, [3, 5, 7]) = min(max(bboxes(:, [3, 5, 7]), 1), size(im, 2));
    
    ori_img = uint8(zeros(target_h, target_w, 3));
    ori_img(ori_top : ori_bottom, ori_left : ori_right, :) = im;
    %     ori_img(1 : 10, 1 : 10, :) = 255;
    %     ori_img(1 : 10, end - 9 : end, :) = 255;
    %     ori_img(end - 9 : end, end - 9 : end, :) = 255;
    %     ori_img(end - 9 : end, 1 : 10, :) = 255;
    %% transform grid
    src_pts = [-1 -1; 1 -1; 1 1; -1 1];
    src_me_pts = [ori_left, ori_top; ori_right, ori_top; ori_right, ori_bottom; ori_left, ori_bottom];
    src_me_pts(:, 1) = src_me_pts(:, 1) / target_w * 2 - 1;
    src_me_pts(:, 2) = src_me_pts(:, 2) / target_h * 2 - 1;
    src_me_pts = [src_me_pts, ones(4, 1)];
    
    rot_angle = (rand(1) - 0.5) * 90 / 180 * pi;
    rot_deviate = [-cos(rot_angle) + sin(rot_angle), -sin(rot_angle) - cos(rot_angle); ...
        cos(rot_angle) + sin(rot_angle), sin(rot_angle) - cos(rot_angle)];
    rot_deviate = [rot_deviate; -rot_deviate] - src_pts;
    trans_deviate = [unifrnd(1 - ori_left, target_w - ori_right) / target_w * 2, unifrnd(1 - ori_top, target_h - ori_bottom) / target_h * 2];
    %     trans_deviate = [max(1 - ori_left, target_w - ori_right) / target_w * 2, max(1 - ori_top, target_h - ori_bottom) / target_h * 2];
    corner_deviate = 0.5 * (rand(4, 2) - 0.5) + repmat(trans_deviate, [4, 1]);
    dst_pts = src_pts + (corner_deviate + rot_deviate) * global_deviate;
    Tform_stn = maketform('projective', src_pts, dst_pts);
    T = Tform_stn.tdata.T;
    % CHECK WHETHER ME IS OUT OF BOUND
    dst_me_pts = src_me_pts * T;
    dst_me_pts(:, 1) = dst_me_pts(:, 1) ./ dst_me_pts(:, 3);
    dst_me_pts(:, 2) = dst_me_pts(:, 2) ./ dst_me_pts(:, 3);
    dst_me_pts = dst_me_pts(:, 1 : 2);
    if min(dst_me_pts(:)) < -1 || max(dst_me_pts(:)) > 1
        rot_angle = (rand(1) - 0.5) * 90 / 180 * pi;
        rot_deviate = [-cos(rot_angle) + sin(rot_angle), -sin(rot_angle) - cos(rot_angle); ...
            cos(rot_angle) + sin(rot_angle), sin(rot_angle) - cos(rot_angle)];
        rot_deviate = [rot_deviate; -rot_deviate] - src_pts;
        corner_deviate = 0.5 * (rand(4, 2) - 0.5);
        dst_pts = src_pts + (corner_deviate + rot_deviate) * global_deviate;
        Tform_stn = maketform('projective', src_pts, dst_pts);
        T = Tform_stn.tdata.T;
        % CHECK WHETHER ME IS OUT OF BOUND
        dst_me_pts = src_me_pts * T;
        dst_me_pts(:, 1) = dst_me_pts(:, 1) ./ dst_me_pts(:, 3);
        dst_me_pts(:, 2) = dst_me_pts(:, 2) ./ dst_me_pts(:, 3);
        dst_me_pts = dst_me_pts(:, 1 : 2);
        if min(dst_me_pts(:)) < -1 || max(dst_me_pts(:)) > 1
            corner_deviate = zeros(4, 2);
            dst_pts = src_pts + corner_deviate * global_deviate;
            Tform_stn = maketform('projective', src_pts, dst_pts);
            T = Tform_stn.tdata.T;
            % CHECK WHETHER ME IS OUT OF BOUND
            dst_me_pts = src_me_pts * T;
            dst_me_pts(:, 1) = dst_me_pts(:, 1) ./ dst_me_pts(:, 3);
            dst_me_pts(:, 2) = dst_me_pts(:, 2) ./ dst_me_pts(:, 3);
            dst_me_pts = dst_me_pts(:, 1 : 2);
            if min(dst_me_pts(:)) < -1 || max(dst_me_pts(:)) > 1
                error(['Fatal Error For Image : ', regular_image_dir, num2str(imid), '.png, Too Big Size !']);
            end
        end
    end
    src_img_pts = [1 1; target_w, 1; target_w, target_h; 1, target_h];
    dst_img_pts = src_img_pts + round([(corner_deviate(:, 1) + rot_deviate(:, 1)) * target_w / 2, (corner_deviate(:, 2) + rot_deviate(:, 2)) * target_h / 2]) * global_deviate;
    
    Tform_img = maketform('projective', src_img_pts, dst_img_pts);
    %     T2 = Tform_img.tdata.T;
    
    % transform images and adjust the size to [target_h, target_w]
    [dst_irg_im, ~, ~] = imtransform(ori_img, Tform_img, 'nearest');
    dst_im = uint8(zeros(target_h, target_w, 3));
    dst_irg_left = max(1, -min(dst_img_pts(:, 1)));
    dst_irg_top = max(1, -min(dst_img_pts(:, 2)));
    dst_left = max(1, min(dst_img_pts(:, 1)));
    dst_top = max(1, min(dst_img_pts(:, 2)));
    patch_h = min(target_h, max(dst_img_pts(:, 2))) - max(1, min(dst_img_pts(:, 2))) + 1;
    patch_w = min(target_w, max(dst_img_pts(:, 1))) - max(1, min(dst_img_pts(:, 1))) + 1;
    dst_im(dst_top : dst_top + patch_h - 1, dst_left : dst_left + patch_w - 1, :) ...
        = dst_irg_im(dst_irg_top : dst_irg_top + patch_h - 1, dst_irg_left : dst_irg_left + patch_w - 1, :);
    % transform two point boxes into four point boxes
    bboxes_4p = [bboxes(:, 1), ...
        bboxes(:, 3), bboxes(:, 2), ...
        bboxes(:, 5), bboxes(:, 2), ...
        bboxes(:, 5), bboxes(:, 4), ...
        bboxes(:, 3), bboxes(:, 4), ...
        bboxes(:, 7), bboxes(:, 6)];
    bboxes = [bboxes(:, 1), ...
        bboxes(:, 3), bboxes(:, 2), ...
        bboxes(:, 5), bboxes(:, 2), ...
        bboxes(:, 5), bboxes(:, 4), ...
        bboxes(:, 3), bboxes(:, 4), ...
        bboxes(:, 7), bboxes(:, 6)];
    
    
    for bid = 1 : size(bboxes_4p, 1)
        bbox_4p = bboxes_4p(bid, 2 : end);
        bbox_4p(1 : 2 : end) = bbox_4p(1 : 2 : end) / target_w * 2 - 1;
        bbox_4p(2 : 2 : end) = bbox_4p(2 : 2 : end) / target_h * 2 - 1;
        bbox_4p = reshape(bbox_4p, [2, 5]);
        
        bbox_4p = [bbox_4p; 1 1 1 1 1]';
        bbox_4p = bbox_4p * T;
        bbox_4p(:, 1) = bbox_4p(:, 1) ./ bbox_4p(:, 3);
        bbox_4p(:, 2) = bbox_4p(:, 2) ./ bbox_4p(:, 3);
        bbox_4p = bbox_4p(:, 1 : 2)';
        bbox_4p = bbox_4p(:)';
        bbox_4p(1 : 2 : end) = (bbox_4p(:, 1 : 2 : end) + 1) * target_w / 2;
        bbox_4p(2 : 2 : end) = (bbox_4p(:, 2 : 2 : end) + 1) * target_h / 2;
        bboxes_4p(bid, 2 : end) = bbox_4p;
        %         y = bbox_4p(2 : 2 : end);
        %         x = bbox_4p(1 : 2 : end);
        %         dst_im = bitmapplot(y, x, dst_im, struct('LineWidth', 1, 'Color', [0 1 0 1]));
    end
    %     figure
    %     imshow(dst_im)
    %     imwrite(dst_im, ['dis', num2str(imid), '.png'], 'png');
    %% reverse bboxes_4p to bboxes_2p --- just for test
    %     [src_gridx, src_gridy] = meshgrid(1 : target_w, 1 : target_h);
    %     src_gridx = src_gridx(:) / target_w * 2 - 1;
    %     src_gridy = src_gridy(:) / target_h * 2 - 1;
    %     src_grid = [src_gridx, src_gridy, ones(length(src_gridx), 1)];
    %     dst_grid = src_grid * T;
    %     dst_grid(:, 1) = dst_grid(:, 1) ./ dst_grid(:, 3);
    %     dst_grid(:, 2) = dst_grid(:, 2) ./ dst_grid(:, 3);
    %     dst_grid(:, 1) = round((dst_grid(:, 1) + 1) / 2 * target_w);
    %     dst_grid(:, 2) = round((dst_grid(:, 2) + 1) / 2 * target_h);
    %     in_bound = dst_grid(:, 1) >= 1 & dst_grid(:, 1) <= target_w & dst_grid(:, 2) >= 1 & dst_grid(:, 2) <= target_h;
    %     src_im = uint8(zeros(target_h, target_w, 3));
    %     [src_gridx, src_gridy] = meshgrid(1 : target_w, 1 : target_h);
    %     src_grid = [src_gridx(:), src_gridy(:), ones(length(src_gridx(:)), 1)];
    %     src_grid = src_grid(in_bound, :);
    %     dst_grid = dst_grid(in_bound, :);
    %     for c = 1 : 3
    %         src_im((c - 1) * target_w * target_h + (src_grid(:, 1) - 1) * target_h + src_grid(:, 2)) = ...
    %             dst_im((c - 1) * target_w * target_h + (dst_grid(:, 1) - 1) * target_h + dst_grid(:, 2));
    %     end
    
    %     for bid = 1 : size(bboxes)
    %         y = [bboxes(bid, 2), bboxes(bid, 2), bboxes(bid, 4), bboxes(bid, 4), bboxes(bid, 6)];
    %         x = [bboxes(bid, 3), bboxes(bid, 5), bboxes(bid, 5), bboxes(bid, 3), bboxes(bid, 7)];
    %         src_im = bitmapplot(y, x, src_im, struct('LineWidth', 1, 'Color', [0 1 0 1]));
    %     end
    %     figure
    %     imshow(uint8(src_im))
    %% output origin and distorted bounding boxes
    dlmwrite([undisturbed_bbox_dir, 'bbox_', num2str(imid), '.config'], bboxes, 'delimiter', ' ');
    dlmwrite([disturbed_bbox_dir, 'bbox_', num2str(imid), '.config'], bboxes_4p, 'delimiter', ' ');
    
    %% output T matrix and gray-scale ME image
    T = T';
    T = T(1 : 8);
    dlmwrite([projective_param_dir, 'projective_', num2str(imid), '.config'], T, 'delimiter', ' ');
    imwrite(dst_im, [projective_image_dir, imname], 'png');
end
