clear; close all; clc
im_num = length(dir('color-tex-regular/*.png'));

if ~isdir('bbox-config/')
    mkdir('bbox-config');
end

parfor i = 1 : im_num
    im = imread(strcat('color-tex-regular/', num2str(i), '.png'));
    config_info = load(strcat('tex_config/tex_', num2str(i), '.config'));
    hsvim = rgb2hsv(im);
    [im_h, im_w, ~] = size(im);
    
    fp = fopen(strcat('bbox-config/bbox_', num2str(i), '.config'), 'w');
    
    for config_info_i = 1 : size(config_info, 1)
        label = config_info(config_info_i, 1);
        hval = config_info(config_info_i, 2);
        
        labelmap = (abs(hsvim(:, :, 1) - hval) < 0.006 & hsvim(:, :, 2) > 0);
        tmplabelmap = double(labelmap > 0);
        if sum(tmplabelmap(:)) == 0
            continue;
        end
        labelmap = bwlabel(labelmap);
        
        % process for i j = ~= >= <= % : ÷ ...
        
        if label == 19 || label == 20 || label == 67 || label == 68 || ...
                (label >= 71 && label <= 74) || label == 82 || label == 84 || ...
                label == 85 || label == 92
            bbox = {};
            topcenter = {};
            bottomcenter = {};
            
            cc_color = unique(labelmap(:));
            for k = 2 : length(cc_color)
                tmp_cc = double(labelmap == cc_color(k));
                xlabel = sum(tmp_cc) > 0;
                xlabel = double(xlabel) .* (1:length(xlabel));
                xlabel = xlabel(xlabel > 0); % left right
                
                ylabel = sum(tmp_cc, 2) > 0;
                ylabel = double(ylabel') .* (1:length(ylabel));
                ylabel = ylabel(ylabel > 0); % top bottom
                
                bbox = [bbox; ylabel(1), xlabel(1), ylabel(end), xlabel(end)]; % top left bottom right
                topcenter = [topcenter; ylabel(1), round((xlabel(1) + xlabel(end)) / 2)];
                bottomcenter = [bottomcenter; ylabel(end), round((xlabel(1) + xlabel(end)) / 2)];
            end
            if ( mod(size(topcenter, 1), 2) && label ~= 67 && label ~= 85 ) || ...
                    ( mod(size(topcenter, 1), 3) && (label == 67 || label == 85) )
                disp(['invalid number of bbox, label : ', num2str(label)]);
                break
            end
            if label == 67 % div
                % 找到中间的横线
                centerlines = {};
                points = {};
                for j = 1 : size(bbox, 1)
                    tmpbbox = bbox{j, :};
                    tmph = tmpbbox(3) - tmpbbox(1);
                    tmpw = tmpbbox(4) - tmpbbox(2);
                    if tmpw / tmph > 2
                        centerlines = [centerlines; tmpbbox];
                    else
                        points = [points; tmpbbox];
                    end
                end
                if size(bbox, 1) / length(centerlines) ~= 3
                    disp('invalid centerline number')
                    break
                end
                
                used_points = zeros(1, size(points, 1));
                %                 div_pairs = {};
                for j = 1 : size(centerlines, 1)
                    center_box = centerlines{j, :};
                    centerx = (center_box(2) + center_box(4)) / 2;
                    centery = (center_box(1) + center_box(3)) / 2;
                    tmp_pair = [j, 1, 1]; % 中心线，上点，下点
                    min_down_dis = 100000;
                    min_up_dis = 100000;
                    for k = 1 : size(points, 1) % 横线上下分别找个最近的点
                        if used_points(k)
                            continue
                        end
                        point_bbox = points{k, :};
                        if (point_bbox(1) + point_bbox(3)) / 2 < centery % 位于上面的点
                            tmpdis = abs((point_bbox(1) + point_bbox(3)) / 2 - centery) + abs((point_bbox(2) + point_bbox(4)) / 2 - centerx);
                            if tmpdis < min_up_dis
                                min_up_dis = tmpdis;
                                tmp_pair(2) = k;
                            end
                        else % 位于下面的点
                            tmpdis = abs((point_bbox(1) + point_bbox(3)) / 2 - centery) + abs((point_bbox(2) + point_bbox(4)) / 2 - centerx);
                            if tmpdis < min_down_dis
                                min_down_dis = tmpdis;
                                tmp_pair(3) = k;
                            end
                        end
                    end
                    if tmp_pair(2) ~= tmp_pair(3)
                        used_points(tmp_pair(2)) = 1;
                        used_points(tmp_pair(3)) = 1;
                        %                         div_pairs = [div_pairs; tmp_pair];
                        
                        bbox1 = centerlines{tmp_pair(1), :};
                        bbox2 = points{tmp_pair(2), :};
                        bbox3 = points{tmp_pair(3), :};
                        
                        tmpbbox = [ min([bbox1(1), bbox2(1), bbox3(1)]), min([bbox1(2), bbox2(2), bbox3(2)]), ...
                            max([bbox1(3), bbox2(3), bbox3(3)]), max([bbox1(4), bbox2(4), bbox3(4)]) ];
                        %                         im(tmpbbox(1), tmpbbox(2) : tmpbbox(4), :) = 0;
                        %                         im(tmpbbox(3), tmpbbox(2) : tmpbbox(4), :) = 0;
                        %                         im(tmpbbox(1) : tmpbbox(3), tmpbbox(2), :) = 0;
                        %                         im(tmpbbox(1) : tmpbbox(3), tmpbbox(4), :) = 0;
                        fprintf(fp, '%d %d %d %d %d\n', label, tmpbbox(1), tmpbbox(2), tmpbbox(3), tmpbbox(4)); % top left bottom right
                    end
                end
            elseif label == 85 % ...
                near_pair = [];
                for j = 1 : size(bottomcenter, 1)
                    mindis = 100000;
                    tmp_pair = [j, j];
                    for k = 1 : size(bottomcenter, 1)
                        if j == k
                            continue
                        end
                        if mindis > sum(abs(bottomcenter{k, :} - bottomcenter{j, :}))
                            tmp_pair(2) = k;
                            mindis = sum(abs(bottomcenter{k, :} - bottomcenter{j, :}));
                        end
                        
                    end
                    if tmp_pair(2) == tmp_pair(1)
                        disp('invalid pair')
                        break
                    end
                    near_pair = [near_pair; tmp_pair];
                end
                % 找到中心点
                index_count = zeros(1, size(near_pair, 1));
                for j = 1 : size(near_pair, 1)
                    index_count(near_pair(j, 2)) = index_count(near_pair(j, 2)) + 1;
                end
                center_index = [];
                for j = 1 : length(index_count)
                    if index_count(j) == 2
                        center_index = [center_index, j];
                    end
                end
                %                 cdots_pair = {};
                for j = 1 : length(center_index)
                    tmp = (near_pair(:, 2) == center_index(j))' .* (1 : size(near_pair, 1));
                    tmp = tmp(tmp > 0);
                    %                     cdots_pair = [cdots_pair; center_index(j), tmp];
                    % draw bbox
                    bbox1 = bbox{tmp(1), :};
                    bbox2 = bbox{tmp(2), :};
                    tmpbbox = [ min(bbox1(1), bbox2(1)), min(bbox1(2), bbox2(2)), ...
                        max(bbox1(3), bbox2(3)), max(bbox1(4), bbox2(4)) ];
                    %                     im(tmpbbox(1), tmpbbox(2) : tmpbbox(4), :) = 0;
                    %                     im(tmpbbox(3), tmpbbox(2) : tmpbbox(4), :) = 0;
                    %                     im(tmpbbox(1) : tmpbbox(3), tmpbbox(2), :) = 0;
                    %                     im(tmpbbox(1) : tmpbbox(3), tmpbbox(4), :) = 0;
                    fprintf(fp, '%d %d %d %d %d\n', label, tmpbbox(1), tmpbbox(2), tmpbbox(3), tmpbbox(4)); % top left bottom right
                end
            else
                usedcenter = bottomcenter;
                if label == 19 || label == 20 % i j
                    usedcenter = topcenter;
                end
                %                 bbox_pair = {};
                bbox_used = zeros(1, size(usedcenter, 1));
                for j = 1 : size(usedcenter, 1)
                    if bbox_used(j)
                        continue;
                    end
                    bbox_used(j) = 1;
                    mindis = 1000000;
                    tmppair = [j, j];
                    for k = 1 : size(usedcenter, 1)
                        if bbox_used(k)
                            continue;
                        end
                        tmpdis = sum(abs(usedcenter{j, :} - usedcenter{k, :}));
                        if tmpdis < mindis
                            mindis = tmpdis;
                            tmppair(2) = k;
                        end
                    end
                    if tmppair(2) ~= tmppair(1)
                        bbox_used(tmppair(2)) = 1;
                        %                         bbox_pair = [bbox_pair; tmppair];
                    end
                    % draw bbox
                    bbox1 = bbox{tmppair(1), :};
                    bbox2 = bbox{tmppair(2), :};
                    tmpbbox = [ min(bbox1(1), bbox2(1)), min(bbox1(2), bbox2(2)), ...
                        max(bbox1(3), bbox2(3)), max(bbox1(4), bbox2(4)) ];
                    %
                    %                         im(tmpbbox(1), tmpbbox(2) : tmpbbox(4), :) = 0;
                    %                         im(tmpbbox(3), tmpbbox(2) : tmpbbox(4), :) = 0;
                    %                         im(tmpbbox(1) : tmpbbox(3), tmpbbox(2), :) = 0;
                    %                         im(tmpbbox(1) : tmpbbox(3), tmpbbox(4), :) = 0;
                    fprintf(fp, '%d %d %d %d %d\n', label, tmpbbox(1), tmpbbox(2), tmpbbox(3), tmpbbox(4)); % top left bottom right
                    
                end
            end
		else
            %% new code
            % show map as a test
            %         figure
            %         surf(labelmap);
            %% output bbox info
            unique_color = unique(labelmap(:));
            unique_color = unique_color(unique_color > 0);
            
            tmp_used = zeros(1, length(unique_color));
            
            for color_id = 1 : length(unique_color) % 遍历每一个连通部件
                if tmp_used(color_id) > 0
                    continue;
                end
                tmpmap = double(labelmap == unique_color(color_id));
                xmap = double(sum(tmpmap) > 0) .* (1 : size(tmpmap, 2));
                xmap = xmap(xmap > 0);
                ymap = double(sum(tmpmap, 2) > 0)' .* (1 : size(tmpmap, 1));
                ymap = ymap(ymap > 0);
				if label == 98 %#ok<ALIGN> % sqrt
					% the ymap should be jump down to a low value
                    yproj = sum(tmpmap, 2);
                    ygap = abs(yproj(1 : end - 1) - yproj(2 : end));
                    [maxv, maxp] = max(ygap);
                    xlabel = tmpmap(maxp, :);
                    xlabel = (xlabel > 0) .* (1 : size(tmpmap, 2));
                    xlabel = xlabel(xlabel > 0);
                    xmap = xmap(1) : min(xlabel);
                    im(ymap(1) : ymap(end), xmap(1) : xmap(end), :) = 255;
                end
                
                % output bbox
                fprintf(fp, '%d %d %d %d %d\n', label, ymap(1), xmap(1), ymap(end), xmap(end)); % top left bottom right
            end
            
        end
        
    end
    fclose(fp);
end











