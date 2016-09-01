function merge_with_background(dataset_name, im_num)
projective_image_dir = [dataset_name, 'projective-tex-images/'];
gray_image_dir = [dataset_name, 'gray-tex-images/'];
mkdir(gray_image_dir);
template2 = [1, 1, 1; 1 1 1; 1 1 1];

for imid = 1 : im_num
    imname = [num2str(imid), '.png'];
    if ~exist([projective_image_dir, imname], 'file')
        continue
    end
    ori_im = imread([projective_image_dir, imname]);
    if rand(1) > 0.5
        ori_im = imdilate(ori_im, template2);
        ori_im = sum(ori_im, 3);
        ori_im = double(ori_im == 0) .* 113 + double(ori_im > 0) .* 0;
        ori_im=uint8(ori_im);
        imwrite(ori_im, [gray_image_dir, num2str(imid), '.jpg'], 'png');
    else
        bklib_num = length(dir('newbackground/*.jpg'));
        gray_contrast = 60;
        sigma = 1;
        gausFilter = fspecial('gaussian', [3 3], sigma);
        ori_im = double(rgb2gray(ori_im));
        bk = rgb2gray(imread(strcat('newbackground/', num2str(ceil(rand(1) * bklib_num)), '.jpg')));
        bk_mean = mean(bk(:));
        im = ((bk_mean - gray_contrast) * rand(1)) * double(ori_im > 0);
        im = im + double(im == 0) .* double(bk);
        im = imfilter(im, gausFilter, 'replicate');
        im = uint8(im);
        imwrite(im, [gray_image_dir, num2str(imid), '.jpg'], 'jpg');
    end
end

