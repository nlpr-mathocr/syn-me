function output_bboxes = extract_symbol_bboxes(labelmap, label, imid)
bbox = [];
topcenter = []; bottomcenter = []; leftcenter = []; rightcenter = []; boxcenter = [];
output_bboxes= [];

cc_color = unique(labelmap(:));
if cc_color(1) ~= 0
    disp('Vital Error in Extracting Connected Components : Background Label is Not Zero !');
    output_bboxes= [];
    return;
end
labels = []; % for labels like brackets, they contain multiple labels
for k = 2 : length(cc_color)
    tmp_cc = double(labelmap == cc_color(k));
    xmap = sum(tmp_cc) > 0;
    xmap = double(xmap) .* (1 : length(xmap));
    xmap = xmap(xmap > 0); % left right
    
    ymap = sum(tmp_cc, 2) > 0;
    ymap = double(ymap') .* (1 : length(ymap));
    ymap = ymap(ymap > 0); % top bottom
    
    if xmap(end) - xmap(1) < 5 && ymap(end) - ymap(1) < 5
        disp([num2str(imid), '.png', ', cc pieces for multi-part label : ', num2str(label)]);
        output_bboxes= [];
        return;
    end
    if label == 98 % sqrt
        bbox = [bbox; ymap(1), xmap(1), ymap(end), xmap(end)]; % top left bottom right
        topcenter = [topcenter; ymap(1), round((xmap(1) + xmap(end)) / 2)];
        bottomcenter = [bottomcenter; ymap(end), round((xmap(1) + xmap(end)) / 2)];
        leftcenter = [leftcenter; round((ymap(1) + ymap(end)) / 2), xmap(1)];
        rightcenter = [rightcenter; round((ymap(1) + ymap(end)) / 2), xmap(end)];
        
        yproj = sum(tmp_cc, 2);
        ygap = abs(yproj(1 : end - 1) - yproj(2 : end));
        [~, maxp] = max(ygap);
        while sum(tmp_cc(maxp, :)) == 0
            maxp = maxp + 1;
        end
        xmap_maxp = tmp_cc(maxp, :);
        xmap_maxp = (xmap_maxp > 0) .* (1 : size(tmp_cc, 2));
        xmap_maxp = xmap_maxp(xmap_maxp > 0);
        xmap = xmap(1) : min(xmap_maxp);
        boxcenter = [boxcenter; round((ymap(1) + ymap(end)) / 2), round((xmap(1) + xmap(end)) / 2)];
        labels = [labels, label];
    else
        if label == 169 % left{
            xproj = sum(tmp_cc, 1);
            if xproj(xmap(1)) > xproj(xmap(end))
                label = 170;
            end
        elseif label == 170 % right}
            xproj = sum(tmp_cc, 1);
            if xproj(xmap(1)) < xproj(xmap(end))
                label = 169;
            end
        elseif label == 95 % left[
            xproj = sum(tmp_cc, 1);
            if xproj(xmap(1)) < xproj(xmap(end))
                label = 96;
            end
        elseif label == 96 % right]
            xproj = sum(tmp_cc, 1);
            if xproj(xmap(1)) > xproj(xmap(end))
                label = 95;
            end
        elseif label == 93 % left(
            xproj = sum(tmp_cc, 1);
            if xproj(xmap(1)) < xproj(xmap(end))
                label = 94;
            end
        elseif label == 94 % right)
            xproj = sum(tmp_cc, 1);
            if xproj(xmap(1)) > xproj(xmap(end))
                label = 93;
            end
        end
        labels = [labels, label];
        bbox = [bbox; ymap(1), xmap(1), ymap(end), xmap(end)]; % top left bottom right
        topcenter = [topcenter; ymap(1), round((xmap(1) + xmap(end)) / 2)];
        bottomcenter = [bottomcenter; ymap(end), round((xmap(1) + xmap(end)) / 2)];
        leftcenter = [leftcenter; round((ymap(1) + ymap(end)) / 2), xmap(1)];
        rightcenter = [rightcenter; round((ymap(1) + ymap(end)) / 2), xmap(end)];
        boxcenter = [boxcenter; round((ymap(1) + ymap(end)) / 2), round((xmap(1) + xmap(end)) / 2)];
    end
    
end
% top bottom structure, two connected components for each symbol
if label == 19 || ... % i
        label == 20 || ... % j
        label == 68 || ... % =
        label == 92 || ... % %
        (label >= 71 && label <= 74) || ... % geq, geqslant, leq, leqslant
        label == 82 || ... % approx
        label == 84 || ... % :
        (label >= 151 && label <= 153) || ... % ; ! ?
        label == 127 || ... % leftrightharpoons
        label == 128 || ... % rightleftharpoons
        label == 184 || ... % subseteq
        label == 188 || ... % simeq
        label == 191 || ... % supseteq
        label == 196 % preceq
    usedcenter = bottomcenter;
    if label == 19 || label == 20 || label == 151 % i j ;
        usedcenter = topcenter;
    end
    output_bboxes = group_connected_components(bbox, usedcenter, 2, labels);
    % top bottom structure, three connected components for each symbol
elseif label == 67 || ... % div
        label == 162 || ... % equiv
        label == 164 || ... % cong
        label == 176 || ... % leqq
        label == 178 % geqq
    usedcenter = boxcenter;
    if label == 164 || label == 176 || label == 178
        usedcenter = bottomcenter;
    end
    output_bboxes = group_connected_components(bbox, usedcenter, 3, labels);
    % left right structure, two connected components for each symbol
elseif label == 157 % parallel
    usedcenter = boxcenter;
    output_bboxes = group_connected_components(bbox, usedcenter, 2, labels);
    % left right structure, three connected components for each symbol
elseif label == 85 % cdots
    usedcenter = boxcenter;
    output_bboxes = group_connected_components(bbox, usedcenter, 3, labels);
    % surrounding structure
elseif label == 140 % Theta
    usedcenter = boxcenter;
    output_bboxes = group_connected_components(bbox, usedcenter, 2, labels);
    % single connected component for each symbol
else
    usedcenter = boxcenter;
    output_bboxes = group_connected_components(bbox, usedcenter, 1, labels);
end
end

function output_bboxes = group_connected_components(bbox, usedcenter, group_size, labels)
output_bboxes= [];
if group_size == 1
    for j = 1 : size(usedcenter, 1)
        output_bboxes = [output_bboxes; labels(j), bbox(j, :), usedcenter(j, :)];
    end
elseif group_size == 2
    % bbox_pair = {};
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
            tmpdis = sum(abs(usedcenter(j, :) - usedcenter(k, :)));
            if tmpdis < mindis
                mindis = tmpdis;
                tmppair(2) = k;
            end
        end
        if tmppair(2) ~= tmppair(1)
            bbox_used(tmppair(2)) = 1;
            % bbox_pair = [bbox_pair; tmppair];
        end
        % draw bbox
        bbox1 = bbox(tmppair(1), :);
        bbox2 = bbox(tmppair(2), :);
        tmpbbox = [min(bbox1(1), bbox2(1)), min(bbox1(2), bbox2(2)), ...
            max(bbox1(3), bbox2(3)), max(bbox1(4), bbox2(4))];
        output_bboxes = [output_bboxes; labels(j), tmpbbox(1), tmpbbox(2), tmpbbox(3), tmpbbox(4), (tmpbbox(1) + tmpbbox(3)) / 2, (tmpbbox(2) + tmpbbox(4)) / 2];
    end
elseif group_size == 3
    near_pair = [];
    for j = 1 : size(usedcenter, 1)
        mindis = 100000;
        tmp_pair = [j, j];
        for k = 1 : size(usedcenter, 1)
            if j == k
                continue
            end
            if mindis > sum(abs(usedcenter(k, :) - usedcenter(j, :)))
                tmp_pair(2) = k;
                mindis = sum(abs(usedcenter(k, :) - usedcenter(j, :)));
            end
        end
        if tmp_pair(2) == tmp_pair(1)
            disp('Invalid Pair for \cdots');
            output_bboxes= [];
            return;
        end
        near_pair = [near_pair; tmp_pair];
    end
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
    for j = 1 : length(center_index)
%         tmp = (near_pair(:, 2) == center_index(j))' .* (1 : size(near_pair, 1));
        tmp = near_pair(near_pair(:, 2) == center_index(j), :);
        tmp = tmp(:, 1);
%         tmp = tmp(tmp > 0);
        % cdots_pair = [cdots_pair; center_index(j), tmp];
        % draw bbox
        bbox1 = bbox(tmp(1), :);
        bbox2 = bbox(tmp(2), :);
        bbox_center = bbox(center_index(j), :);
        tmpbbox = [min([bbox1(1), bbox2(1), bbox_center(1)]), min([bbox1(2), bbox2(2), bbox_center(2)]), ...
            max([bbox1(3), bbox2(3), bbox_center(3)]), max([bbox1(4), bbox2(4), bbox_center(4)])];
        output_bboxes = [output_bboxes; labels(j), tmpbbox(1), tmpbbox(2), tmpbbox(3), tmpbbox(4), (tmpbbox(1) + tmpbbox(3)) / 2, (tmpbbox(2) + tmpbbox(4)) / 2];
    end
else
    disp('Invalid Group Size');
    output_bboxes= [];
    return;
end
end


