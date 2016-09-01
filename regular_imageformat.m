function regular_imageformat(dataset_name, im_num)
ori_image_dir = [dataset_name, 'color-tex/'];
regular_image_dir = [dataset_name, 'color-tex-regular/'];
if ~isdir(regular_image_dir)
    mkdir(regular_image_dir);
end

for i = 1 : im_num
    if ~exist([ori_image_dir, num2str(i), '.png'], 'file')
        continue
    end
    im = imread([ori_image_dir, num2str(i), '.png']);
    [ori_h, ori_w, ~] = size(im);
    regular_w = ori_w;
    regular_h = ori_h;
    ori_im = zeros(ori_h, ori_w, 3);
    if size(im, 3) == 3
        if max(im(:)) > 2^8 - 1 % uint16
            ori_im = uint8(double(im) / 65535 * 255);
        else
            ori_im = im;
        end
    elseif size(im, 3) == 1
        [map, lib] = imread([ori_image_dir, num2str(i), '.png']);
        lib = lib * 255;
        tmpmap = map(:);
        for j = 1 : size(lib, 1)
            tmp_index = double(tmpmap == j - 1)' .* (1 : length(tmpmap));
            tmp_index = tmp_index(tmp_index > 0);
            ori_im(tmp_index) = lib(j, 1);
            ori_im(tmp_index + length(tmpmap)) = lib(j, 2);
            ori_im(tmp_index + length(tmpmap) * 2) = lib(j, 3);
        end
    else
        disp(['Invalid Image Format: Image Channel is ', num2str(size(im, 3))]);
    end

    ori_hh = max(min(round((1 : regular_h) / regular_h * ori_h), ori_h), 1);
    ori_ww = max(min(round((1 : regular_w) / regular_w * ori_w), ori_w), 1);
    
    regular_im = ori_im(ori_hh, ori_ww, :);
    sum_im = sum(regular_im, 3);
    sum_im = sum_im(:);
    tmp_index = double(sum_im == 765)' .* (1 : length(sum_im));
    tmp_index = tmp_index(tmp_index > 0);
    tmp_index = [tmp_index, tmp_index + length(sum_im), ...
        tmp_index + 2 * length(sum_im)];
    regular_im(tmp_index) = 0;
    % crop a tight bound
    tmpim = sum(regular_im, 3);
    tmpx = sum(tmpim);
    tmpx = double(tmpx > 0) .* (1 : length(tmpx));
    tmpx = tmpx(tmpx > 0);
    tmpy = sum(tmpim, 2)';
    tmpy = double(tmpy > 0) .* (1 : length(tmpy));
    tmpy = tmpy(tmpy > 0);
    regular_im = regular_im(tmpy(1) : tmpy(end), tmpx(1) : tmpx(end), :);
    regular_im = uint8(regular_im);
    imwrite(regular_im, [regular_image_dir, num2str(i), '.png'], 'png');
end
end
