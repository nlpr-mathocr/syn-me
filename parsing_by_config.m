%% parse the color images by config file
clear; close all; clc
if ~isdir('parsing-images/')
    mkdir('parsing-images');
end

im_num = length(dir('color-tex-distort/*.png'));

parfor i = 1 : im_num

	if mod(i, 5000) == 0
		i
	end

    %hsvim = hsvread(strcat('color-tex-images\', num2str(i), '.bmp'));
    hsvim = rgb2hsv(imread(strcat('color-tex-distort/', num2str(i), '.png')));
    
    if ~isdir(strcat('parsing-images/', num2str(i), '/'))
        mkdir(strcat('parsing-images/', num2str(i)));
    end
    
    config_info = load(strcat('tex_config/tex_', num2str(i), '.config'));
    
    
    for j = 1 : size(config_info, 1)
        hval = config_info(j, 2);
        symbol = num2str(config_info(j, 1));
        labelmap = (abs(hsvim(:, :, 1) - hval) < 0.006 & hsvim(:, :, 2) > 0); % s channel to avoid white background
        if sum(labelmap(:)) > 0
            imwrite(labelmap, strcat('parsing-images/', num2str(i), '/', symbol, '.png'), 'png');
        end
    end
end








































