function [adj_bboxes] = adjust_bb_basedon_label(label, bbox) % top left bottom right
   
    label_num_1 = 1;
    label_dot   = 83;
    label_colon = 84;
    label_cdots = 85; 
    label_frac = 97;
    label_minus = 64;
    label_div   = 67;
    
    if label == label_num_1
        adj_bboxes = adjust_num_1_bbox(bbox);
    elseif label == label_frac
        adj_bboxes = adjust_frac_bbox(bbox);
    elseif label == label_dot
        adj_bboxes = adjust_dot_bbox(bbox);
    elseif label == label_minus
        adj_bboxes = adjust_minus_bbox(bbox);
    elseif label == label_div
        adj_bboxes = adjust_div_bbox(bbox);
    elseif label == label_colon
        adj_bboxes = adjust_colon_bbox(bbox);
    elseif label == label_cdots
        adj_bboxes = adjust_cdots_bbox(bbox);
    else
        adj_bboxes = bbox;
    end
end

function [adjt_bbox] = long_symbol_to_sqare_bbox(bbox, h2w_ratio)

    top    = bbox(1);
    left   = bbox(2);
    bottom = bbox(3);
    right  = bbox(4);
    width  = right  - left + 1;
    cy = (top + bottom)/2;
    new_height = width * h2w_ratio;

    new_top     = cy -  new_height / 2  + 0.5;
    new_bottom  = cy +  new_height / 2  - 0.5;
    new_left    = left;
    new_right   = right;
    
    adjt_bbox = [new_top, new_left, new_bottom, new_right];
end

function [adjt_bbox] = high_symbol_to_sqare_bbox(bbox, w2h_ratio)

    top    = bbox(1);
    left   = bbox(2);
    bottom = bbox(3);
    right  = bbox(4);
    height  = bottom  - top + 1;
    cx = (right + left)/2;
    new_width = height * w2h_ratio;

    new_top     = top;
    new_bottom  = bottom;
    new_left    = cx -  new_width / 2  + 0.5;
    new_right   = cx +  new_width / 2  - 0.5;
    
    adjt_bbox = [new_top, new_left, new_bottom, new_right];
end

function [adjt_bbox] = adjust_colon_bbox(bbox)
    adjt_bbox = high_symbol_to_sqare_bbox(bbox, 0.5);
end

function [adjt_bbox] = adjust_cdots_bbox(bbox)
    adjt_bbox = long_symbol_to_sqare_bbox(bbox, 0.5);
end

function [adjt_bbox] = adjust_div_bbox(bbox)
    adjt_bbox = long_symbol_to_sqare_bbox(bbox, 1);
end

function [adjt_bbox] = adjust_minus_bbox(bbox)
    adjt_bbox = long_symbol_to_sqare_bbox(bbox, 1);
end

function [adjt_bbox] = adjust_dot_bbox(bbox)
    
    % expand vertically.
    vert_scale_ratio = 6;
    horz_scale_ratio = 2;
    top    = bbox(1);
    left   = bbox(2);
    bottom = bbox(3);
    right  = bbox(4);
    height = bottom - top + 1;
    width  = right  - left + 1;
    cy = (top + bottom)/2;
    cx = (left + right)/2;
    new_height = height * vert_scale_ratio;
    new_width  = width  * horz_scale_ratio;

    new_top     = bottom - new_height + 1;
    new_bottom  = bottom;
    new_left   = cx -  new_width / 2  + 0.5;
    new_right  = cx +  new_width / 2  - 0.5;
   
    adjt_bbox = [new_top, new_left, new_bottom, new_right];
end

function [adjt_bbox] = adjust_frac_bbox(bbox)
    
    % expand vertically.
    vert_scale_ratio = 8;
    top = bbox(1);
    left = bbox(2);
    bottom = bbox(3);
    right = bbox(4);
    height = bottom - top + 1;
    cy = (top + bottom)/2;
    new_height = height * vert_scale_ratio;
    
    new_top     = cy - new_height / 2.0  + 0.5;
    new_bottom  = cy + new_height / 2.0  - 0.5;
    new_left    = left;
    new_right   = right;
    
    bbox = [new_top, new_left, new_bottom, new_right];
    
    w2h_ratio = 2;
    step = max( new_height * w2h_ratio / 8, 1);
    new_left_i  = new_left;
    new_right_i = new_left + w2h_ratio * new_height - 1;
    
    if (new_right_i > new_right)
        adjt_bbox = bbox;
        return
    else
        i = 1;
        num_adjt_bbox = floor((new_right - new_right_i)/step) + 1;
        adjt_bbox = zeros(num_adjt_bbox, 4);
        while (new_right_i <= new_right)
            adjt_bbox(i, :) = [new_top, new_left_i, new_bottom, new_right_i];
            i = i + 1;
            new_right_i = new_right_i + step;
            new_left_i  = new_left_i  + step;
        end
        adjt_bbox = adjt_bbox(1:i-1, :);
        return
    end
    
end

function [adjt_bbox] = adjust_num_1_bbox(bbox)

    horz_scale_ratio = 1.2;
    top    = bbox(1);
    left   = bbox(2);
    bottom = bbox(3);
    right  = bbox(4);
    width  = right - left + 1;
    cx = (left + right)/2;
    new_width = width * horz_scale_ratio;
    
    new_left   = cx - new_width / 2 + 0.5;
    new_right  = cx + new_width / 2 - 0.5;
    new_top    = top;
    new_bottom = bottom;
    
    adjt_bbox = [new_top new_left new_bottom new_right];
end