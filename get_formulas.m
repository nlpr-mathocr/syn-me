clear; close all; clc
fp_tex = fopen('color_tex.tex', 'w');
color_list =load('color-list.txt');

if ~isdir('tex_config/')
    mkdir('tex_config');
end


%% preload symbolset and operater_set
symbol_set = {};
symbol_set_fp = fopen('label-list.txt', 'r');
while 1
    strline = fgetl(symbol_set_fp);
    if strline == -1
        break
    end
    strline = regexp(strline, '\s+', 'split');
    symbol_set = [symbol_set; strline];
end
fclose(symbol_set_fp);

operater_set = {};
operater_set_fp = fopen('operater-list.txt', 'r');
while 1
    strline = fgetl(operater_set_fp);
    if strline == -1
        break
    end
    strline = regexp(strline, '\s+', 'split');
    operater_set = [operater_set; strline{1}];
end
fclose(operater_set_fp);

formula_len = [];
for i = 1 : 10
    if mod(i, 1000) == 0
        i
    end
    rand_index = randperm(size(color_list, 1));
    color_list = color_list(rand_index, :);
    hsv_list = reshape(color_list, [1, size(color_list, 1), 3]);
    hsv_list = rgb2hsv(hsv_list);
    h_list = hsv_list(:,:,1);
    
    [formula, color_id, tmplen] = generate_formula(color_list, operater_set);
    formula_len = [formula_len, tmplen];
    fprintf(fp_tex, '%s\n', formula);
    fp_color = fopen(strcat('tex_config/tex_', num2str(i), '.config'), 'w');
    
    for j = 1 : length(color_id)
        symbol = color_id{j, 1};
        tmp_id = color_id{j, 2};
		
        issymbol = false;
        for k = 1 : size(symbol_set, 1)
            if strcmp(symbol, symbol_set{k, 1})
                symbol = str2double(symbol_set{k, 2});
                issymbol = true;
                break
            end
        end
        
        if ~issymbol
            disp(['invalid symbol : ', symbol]);
        end
        
        fprintf(fp_color, '%d ', symbol);
        fprintf(fp_color, '%.5f\n', h_list(tmp_id));
    end
    
    fclose(fp_color);
end
fclose(fp_tex);













