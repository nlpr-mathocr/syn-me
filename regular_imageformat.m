%function regular_teximages()
clear; clc
im_num = length(dir('color-tex-uint8/*.png'));
if ~isdir('color-tex-regular/')
    mkdir('color-tex-regular');
end


%parfor ii = 1 : core_num

for i = 1 : im_num %1 + (ii-1) * im_num / core_num : ii * im_num / core_num
     
    [map, lib] = imread(strcat('color-tex-uint8/', num2str(i), '.png'));
    
    
    
    lib = 255 * lib;
    % regular_im = 255 * ones(regular_h, regular_w, 3);
    [ori_h, ori_w, ch] = size(map);
    
    regular_w = ori_w;
    regular_h = ori_h;
    %i 
    %size(lib)
    %size(map)

    ori_im = zeros(ori_h, ori_w, 3);
    if ch == 1
        tmpmap = map(:);
        for j = 1 : size(lib, 1)
            tmp_index = double(tmpmap == j - 1)' .* (1 : length(tmpmap));
            tmp_index = tmp_index(tmp_index > 0);
            ori_im(tmp_index) = lib(j, 1);
            ori_im(tmp_index + length(tmpmap)) = lib(j, 2);
            ori_im(tmp_index + length(tmpmap) * 2) = lib(j, 3);
            
        end
%         for ww = 1 : ori_w
%             for hh = 1 : ori_h
%                 tmpid = map(hh, ww) + 1; 
%                 ori_im(hh, ww, :) = lib(tmpid, :);
%             end
%         end
    else
        
        ori_im = double(map);
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
%     for ww = 1 : regular_w
%             for hh = 1 : regular_h
%                 if sum(regular_im(hh, ww, :)) == 765
%                     regular_im(hh, ww, :) = 0;
%                 end
%             end
%     end
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
    imwrite(regular_im, strcat('color-tex-regular/', num2str(i), '.png'), 'png');
    

end


%end
