function [color_id, letternum_set, operater_set, pair_set, script_set, frac_set, sqrt_set] = set_symbol_color(color_list, letternum_set, operater_set, pair_set, script_set, frac_set, sqrt_set)
if size(color_list, 1) < length(letternum_set) + length(operater_set) + 2 * length(pair_set)  + length(frac_set) + length(sqrt_set)
%     size(color_list, 1)
%     length(letternum_set) + length(operater_set) + length(pair_set) + length(script_set)
    disp('too many symbols to use the color set!')
else
    color_id = {};
    color_list = color_list / 255;
    tmpid = 0;
    for i = 1 : length(letternum_set)
        tmpid = tmpid + 1;
    	tmp = letternum_set{i};
        letternum_set{i} = ['{\\color[rgb]{', ...
            num2str(color_list(tmpid, 1)), ',', ...
            num2str(color_list(tmpid, 2)), ',', ...
            num2str(color_list(tmpid, 3)), ...
            '}',tmp, '}'];
        
        color_id = [color_id; {tmp}, {tmpid}];
        
    end

    for i = 1 : length(operater_set)
        tmpid = tmpid + 1;
    	tmp = operater_set{i};
        operater_set{i} = ['{\\color[rgb]{', ...
            num2str(color_list(tmpid, 1)), ',', ...
            num2str(color_list(tmpid, 2)), ',', ...
            num2str(color_list(tmpid, 3)), ...
            '}',tmp, '}'];
        
        color_id = [color_id; {tmp}, {tmpid}];
        
    end

    for i = 1 : length(pair_set)
        tmpid = tmpid + 1;
        tmp = pair_set{i};
        
        tmp1 = tmp{1};
        tmp{1} = ['{\\color[rgb]{', ... 
            num2str(color_list(tmpid, 1)), ',', ...
            num2str(color_list(tmpid, 2)), ',', ...
            num2str(color_list(tmpid, 3)), ...
            '}', tmp1];
        color_id = [color_id; {tmp1}, {tmpid}];
        
        tmp2 = tmp{2};
        tmpid = tmpid + 1;
        tmp{2} = ['\\color[rgb]{', ... 
            num2str(color_list(tmpid, 1)), ',', ...
            num2str(color_list(tmpid, 2)), ',', ...
            num2str(color_list(tmpid, 3)), ...
            '}', tmp2, '}'];
        
        pair_set{i} = tmp;
        color_id = [color_id; {tmp2}, {tmpid}];
    end
    
    for i = 1 : length(sqrt_set)
        tmpid = tmpid + 1;
        tmp = sqrt_set{i};
        
        tmp1 = tmp{1};
        tmp{1} = ['{\\color[rgb]{', ... 
            num2str(color_list(tmpid, 1)), ',', ...
            num2str(color_list(tmpid, 2)), ',', ...
            num2str(color_list(tmpid, 3)), ...
            '}', tmp1];
        
        tmp2 = tmp{2};
        
        tmp{2} = [tmp2, '}'];
        
        sqrt_set{i} = tmp;
        
        color_id = [color_id; {tmp1}, {tmpid}];
        
    end
    
    for i = 1 : length(frac_set)
        tmpid = tmpid + 1;
        tmp = frac_set{i};
        
        tmp1 = tmp{1};
        tmp{1} = ['{\\color[rgb]{', ... 
            num2str(color_list(tmpid, 1)), ',', ...
            num2str(color_list(tmpid, 2)), ',', ...
            num2str(color_list(tmpid, 3)), ...
            '}', tmp1];
        
        tmp4 = tmp{4};
        
        tmp{4} = [tmp4, '}'];
        
        frac_set{i} = tmp;
        
        color_id = [color_id; {tmp1}, {tmpid}];
        
    end

end



















