%%
clear; close all; clc
fp = fopen('train.txt');
dst_dir = 'draw-gt';
mkdir(dst_dir);
while 1
    strl = fgetl(fp);
    if strl == -1
        break
    end
    strs = regexp(strl, ' ', 'split');
    fname = strs{1};
    if ~exist(['gray-tex-images/', fname], 'file')
        continue
    end
    im = imread(['gray-tex-images/', fname]);
    if size(im, 3) == 1
        im = repmat(im, [1 1 3]);
    end
    strs = strs(2 : end);
    symbol_num = length(strs) / 16;
    for sid = 1 : symbol_num
        topleft = str2double(strs{(sid - 1) * 16 + 1});
        lefttop = str2double(strs{(sid - 1) * 16 + 2});
        
        topright = str2double(strs{(sid - 1) * 16 + 3});
        righttop = str2double(strs{(sid - 1) * 16 + 4});
        
        bottomright = str2double(strs{(sid - 1) * 16 + 5});
        rightbottom = str2double(strs{(sid - 1) * 16 + 6});
        
        bottomleft = str2double(strs{(sid - 1) * 16 + 7});
        leftbottom = str2double(strs{(sid - 1) * 16 + 8});
        
        centerx = str2double(strs{(sid - 1) * 16 + 9});
        centery = str2double(strs{(sid - 1) * 16 + 10});
        
        cat = str2double(strs{(sid - 1) * 16 + 13});
        im = bitmapplot([lefttop righttop rightbottom leftbottom centery], ...
            [topleft topright bottomright bottomleft centerx], im, ...
            struct('Color', [1 0 0 1], 'LineWidth', 1));
        im = bitmaptext({label2ch(cat)}, im, ...
            round([centery, centerx]), struct('Color', [0 0 255 2], 'FontSize', 3));
    end
    imwrite(im, [dst_dir, '/', fname, '.png'], 'png');
    %     break
end
fclose(fp);






















