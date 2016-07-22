function projective_formulas(data_num, im_num)
color_regular = [data_num, 'color-tex-regular/'];
color_gray = [data_num, 'gray-tex-images/'];
color_projective = [data_num, 'projective-param/'];
color_adjust = [data_num, 'adjust-bbox-config/'];
if ~isdir(color_gray)
    mkdir(color_gray)
end
if ~isdir(color_projective)
    mkdir(color_projective);
end

template2 = [1, 1,1; 1 1 1;1 1 1];
target_h = 512;
target_w = 512;


for i = 1 : im_num
    im = imread([color_regular, num2str(i), '.png']);
    imname = [num2str(i), '.jpg'];
    target_im = zeros(target_h, target_w, 3);
    bbox_config = load(strcat(color_adjust, '/bbox_', num2str(i), '.config'));
    [row , ~] = size(bbox_config);
    bbox_h = [];
    bbox_w = [];
    for j = 1 : row
        bbox_h = [bbox_h, bbox_config(j, 4) - bbox_config(j, 2)];
        bbox_w = [bbox_w, bbox_config(j, 5) - bbox_config(j, 3)];
    end
    bbox_h = median(bbox_h);
    bbox_w = median(bbox_w);
    sx = (32 / bbox_w + 32 / bbox_h) / 2;
    regular_im = imresize(im, sx);
    [~,gwidth,~]=size(regular_im);
    bbox_config(:, 2 : 7) = bbox_config(:, 2 : 7) * sx;
    pixel = 30;
    while gwidth > target_w
        pixel = pixel - 1;
        sx = (pixel / bbox_w + pixel / bbox_h) / 2;
        regular_im = imresize(im, sx);
        [~,gwidth,~]=size(regular_im);
        bbox_config(:, 2 : 7) = bbox_config(:, 2 : 7) * sx;
    end
%     distort_bboxes = [];
%     label_bboxes = bbox_config(:, 1);
%     for rid = 1 : row
%         top = bbox_config(rid, 2);
%         left = bbox_config(rid, 3);
%         bottom = bbox_config(rid, 4);
%         right = bbox_config(rid, 5);
%         centery = bbox_config(rid, 7);
%         centerx = bbox_config(rid, 6);
%         distort_bboxes = [distort_bboxes; ...
%             left, top; right, top; right, bottom; left, bottom; ...
%             centerx, centery];
%     end
    
    % 将图像跟bounding box做透视变换
    T = eye(3);
    distort_times = 0;
    distort_im = regular_im;
    while 1
        [dst_im, Ttmp] = transform_grid(regular_im);
        distort_times = distort_times + 1;
        if size(dst_im, 1) <= target_h && size(dst_im, 2) <= target_w
            distort_im = dst_im;
%             distort_bboxes = dst_boxes;
            T = Ttmp;
            break;
        end
        if distort_times > 3
            break;
        end
    end
%     distort_bboxes_withlabel = zeros(row, size(distort_bboxes, 1) / row * 2 + 1);
%     distort_bboxes_withlabel(:, 1) = label_bboxes;
%     for rid = 1 : row
%         distort_bboxes_per_symbol = distort_bboxes((rid - 1) * size(distort_bboxes, 1) / row + 1 : ...
%             rid * size(distort_bboxes, 1) / row, :);
%         distort_bboxes_per_symbol = distort_bboxes_per_symbol';
%         distort_bboxes_per_symbol = distort_bboxes_per_symbol(:);
%         distort_bboxes_withlabel(rid, 2 : end) = distort_bboxes_per_symbol;
%     end
    
    [dist_h, dist_w, ~] = size(distort_im);
    rh = max(ceil(rand(1) * (target_h - dist_h)), 1);
    rw = max(ceil(rand(1) * (target_w - dist_w)), 1);
    rw1 = max(ceil((target_w - dist_w) / 2), 1); % 原来的高度和长度
    rh1 = max(ceil((target_h - dist_h) / 2), 1);
%     distort_bboxes_withlabel(:, 2 ) = distort_bboxes_withlabel(:, 2 ) + rw;
%     distort_bboxes_withlabel(:, 4 ) = distort_bboxes_withlabel(:, 4 ) + rw;
%     distort_bboxes_withlabel(:, 6 ) = distort_bboxes_withlabel(:, 6 ) + rw;
%     distort_bboxes_withlabel(:, 8 ) = distort_bboxes_withlabel(:, 8 ) + rw;
%     distort_bboxes_withlabel(:, 11 ) = distort_bboxes_withlabel(:, 11 ) + rw;
%     distort_bboxes_withlabel(:, 3 ) = distort_bboxes_withlabel(:, 3 ) + rh;
%     distort_bboxes_withlabel(:, 5 ) = distort_bboxes_withlabel(:, 5 ) + rh;
%     distort_bboxes_withlabel(:, 7 ) = distort_bboxes_withlabel(:, 7 ) + rh;
%     distort_bboxes_withlabel(:, 9 ) = distort_bboxes_withlabel(:, 9 ) + rh;
%     distort_bboxes_withlabel(:, 10 ) = distort_bboxes_withlabel(:, 10 ) + rh;
    
    T = T * [1 0 0; 0 1 0; 2 * (rw - rw1) / target_w, 2 * (rh - rh1) / target_h, 1];
    T = T';
    T = T(1 : 8);
    dlmwrite([color_projective, 'projective_', num2str(i), '.config'], T, 'delimiter', ' ');
    target_im(rh : (rh + dist_h - 1), rw : (rw + dist_w - 1), :) = distort_im;
    if rand(1) > 0.5
       target_im = imdilate(target_im, template2);
       result_im = zeros(target_h, target_w);
       for j = 1 : target_h
           for k = 1 : target_w
               if sum(target_im(j , k , :))==0
                   result_im(j,k)=113;
               else
                   result_im(j,k)=0;
               end
           end
       end
       result_im=uint8(result_im);
       imwrite(result_im, [color_gray, imname], 'jpg');  
    else
        bklib_num = length(dir('newbackground/*.jpg'));
        gray_contrast = 60;
        sigma = 1; 
        gausFilter = fspecial('gaussian', [3 3], sigma);
        im_ori = uint8(target_im);
        im_ori = double(rgb2gray(im_ori));
        bk = rgb2gray(imread(strcat('newbackground/', num2str(ceil(rand(1) * bklib_num)), '.jpg')));
        bk_mean = mean(bk(:));
        im = ((bk_mean - gray_contrast) * rand(1)) * double(im_ori > 0);
        im = im + double(im == 0) .* double(bk);
        im = imfilter(im, gausFilter, 'replicate');
		im = uint8(im);
		imwrite(im, [color_gray, imname], 'jpg');      
    end
end
end
