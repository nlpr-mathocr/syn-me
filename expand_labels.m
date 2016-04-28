clear; close all; clc
if ~isdir('expand-labels/')
    mkdir('expand-labels')
end

im_num = length(dir('tex-labels/*.png'));
im = imread(strcat('tex-labels/1.png'));
[im_h, im_w, ~] = size(im);
im_len = im_h * im_w;

expand_radius = 2;

uncare_label = 33;



for i = 1:im_num % : im_num
    cnt = 0;
    
%     innermap = zeros(im_h, im_w);
    
    im = imread(strcat('tex-labels/', num2str(i), '.png'));
    tex_part = double(im > 0);
    tex_part = tex_part(:);
    tex_part = tex_part' .* (1 : im_len);
    tex_part = tex_part(tex_part > 0);
    re_lbl = double(im);
    for j = 1 : length(tex_part)
        map_index = tex_part(j);
        map_ww = ceil(map_index / im_h);
        map_hh = mod(map_index, im_h);
        if map_hh == 0
            map_hh = im_h;
        end
        if map_hh > 1 && map_hh < im_h && ...
                map_ww > 1 && map_ww < im_w
            if im(map_hh + 1, map_ww) + im(map_hh - 1, map_ww) + im(map_hh, map_ww + 1) + im(map_hh, map_ww - 1) == 4 * im(map_hh, map_ww)
                cnt = cnt + 1;
%                 innermap(map_hh, map_ww) = 1;
                continue;
            end
        end
        
        left = max(map_ww - expand_radius, 1);
        right = min(map_ww + expand_radius, im_w);
        top = max(map_hh - expand_radius, 1);
        bottom = min(map_hh + expand_radius, im_h);
        for xx = left : right
            for yy = top : bottom
                % 如果是255就跳过，如果是0就变成前景点，如果有label就变成255，最后把原来的label值再重置一遍
                if re_lbl(yy, xx) == 0
                    re_lbl(yy, xx) = im(map_hh, map_ww);
                elseif re_lbl(yy, xx) ~= im(map_hh, map_ww)
                    re_lbl(yy, xx) = uncare_label;
                end
            end
        end
    end

    rate = cnt / length(tex_part)
    
    re_lbl(tex_part) = im(tex_part);
    surf(re_lbl)
    re_lbl = uint8(re_lbl);
    imwrite(re_lbl, strcat('expand-labels/', num2str(i), '.png'), 'png');
end



