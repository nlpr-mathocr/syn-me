function [formula, color_id, formula_len] = generate_formula(color_list, operater_set)

% 
letter_set = {};
for i = 0 : 25
    letter_set = [ letter_set, char(i + 'a') ];
end
for i = 0 : 25
    letter_set = [ letter_set, char(i + 'A') ];
end
%clear letters letters_base capital_letters num_base num_chars
letter_set = [ letter_set, '\\pi' ];

num_set = {};
for i = 0 : 9
    num_set = [ num_set, num2str(i) ];
end

pair_set = { { '\\left(' , '\\right)' } , { '\\left[', '\\right]' } }; % 注意 [ {与 ] } 的askii码不是相邻的
script_set = { { '^{', '}' } , { '_{', '}' } };
frac_set = { { '\\frac{', '}', '{', '}' } };
sqrt_set = { { '\\sqrt{' , '}'} };
% color_prefix = '\\color[rgb]';

%% set how many symbols will be used and length of the formula
max_symbol_num = 10;
max_formula_len = 20;
min_formula_len = 3;
formula_len = min_formula_len + floor(rand(1) * (max_formula_len - min_formula_len)); %ceil(rand(1) * max_formula_len); % 3 ~ maxlen
%%  generate temp symbol set 
tmp_letter_set = sort_used_set(letter_set, 0.3, max_symbol_num); % 这里的参数量需要调整，不然颜色不够用，把数字全加进去，字母挑出一点儿
tmp_num_set = sort_used_set(num_set, 1, max_symbol_num);
tmp_letternum_set = [tmp_letter_set, tmp_num_set];

tmp_operater_set = sort_used_set(operater_set, 0.7, max_symbol_num);
tmp_pair_set = sort_used_set(pair_set, 1, max_symbol_num);
tmp_script_set = sort_used_set(script_set, 1, max_symbol_num);
tmp_frac_set = sort_used_set(frac_set, 1, max_symbol_num);
tmp_sqrt_set = sort_used_set(sqrt_set, 1, max_symbol_num);

[color_id, tmp_letternum_set, tmp_operater_set, tmp_pair_set, tmp_script_set, tmp_frac_set, tmp_sqrt_set] = ...
    set_symbol_color(color_list, tmp_letternum_set, tmp_operater_set, tmp_pair_set, tmp_script_set, tmp_frac_set, tmp_sqrt_set);

tmp_pair_set = [tmp_pair_set, tmp_sqrt_set];
[formula, formula_len] = generate_subformula(formula_len, tmp_letternum_set, tmp_operater_set, tmp_pair_set, tmp_script_set, tmp_frac_set);
% disp(formula)
% formula = [formula, '\\\\'];


end




%%
function [equ, equ_len] = generate_subformula(len, letternum_set, operater_set, pair_set, script_set, frac_set)
equ = '';

noletter_len = length(operater_set) + length(pair_set) + length(script_set) + length(frac_set);
operater_ratio = length(operater_set) / noletter_len;
pair_ratio = length(pair_set) / noletter_len;
script_ratio = length(script_set) / noletter_len;
frac_ratio = length(frac_set) / noletter_len;

[tmp_u, unary_len] = generate_unary(letternum_set, len);
if len < unary_len
    equ_len = unary_len;
    equ = tmp_u;
else
    rnd = rand(1);
    if ~isempty(script_set) && rnd < script_ratio% 0.15 % && ~isempty(equ) 上下标
        rindex = randperm(length(script_set));
        p = script_set{ rindex(1) };
        [tmp, tmp_len] = generate_subformula(len - unary_len, letternum_set, operater_set, pair_set, script_set, frac_set);
        equ = [equ, tmp_u];
        equ = [equ, p{1}];
        equ = [equ, tmp];
        equ = [equ, p{2}];
        equ_len = tmp_len + unary_len;
    else
        rnd = rand(1);
        if (isempty(pair_set) && isempty(frac_set)) || rnd < operater_ratio % 0.5 % operater like + - * / 要考虑到括号集合与运算符集合的大小，不然有一堆根号
            rindex = randperm(length(operater_set));
            o = operater_set{ rindex(1) };
            tmp_len = len - 1;
            [tmp1, tmp_len1] = generate_subformula(ceil(tmp_len * 0.5), letternum_set, operater_set, pair_set, script_set, frac_set);
            [tmp2, tmp_len2] = generate_subformula(tmp_len - tmp_len1, letternum_set, operater_set, pair_set, script_set, frac_set);
            equ = [equ, tmp1];
            equ = [equ, o];
            equ = [equ, tmp2];
            equ_len = tmp_len1 + tmp_len2 + 1;
        elseif (isempty(operater_set) && isempty(frac_set)) || (rnd < operater_ratio + pair_ratio) % 0.25 % pair like ( [ { sqrt...
            rindex = randperm(length(pair_set));
            p = pair_set{ rindex(1) };
            [tmp, pair_len] = generate_subformula(len - 1, letternum_set, operater_set, pair_set, script_set, frac_set);
            equ = [equ, p{1}];
            equ = [equ, tmp];
            equ = [equ, p{2}];
            equ_len = pair_len + 1;
        elseif (isempty(operater_set) && isempty(pair_set)) || (rnd < operater_ratio + pair_ratio + frac_ratio)% 0.05 % frac {} {} like operater
            rindex = 1; %randperm(length(script_set));
            frac = frac_set{ rindex(1) };
            tmp_len = len;
            [tmp1, tmp_len1] = generate_subformula(ceil(tmp_len * 0.5), letternum_set, operater_set, pair_set, script_set, frac_set);
            [tmp2, tmp_len2] = generate_subformula(tmp_len - tmp_len1, letternum_set, operater_set, pair_set, script_set, frac_set);
            equ = [equ, frac{1}];
            equ = [equ, tmp1];
            equ = [equ, frac{2}];
            equ = [equ, frac{3}];
            equ = [equ, tmp2];
            equ = [equ, frac{4}];
            equ_len = max(tmp_len1, tmp_len2);
        else 
            [tmp_u, unary_len] = generate_full_unary(letternum_set, len);
            equ_len = unary_len;
            equ = tmp_u;
        end
    end
end
end

%%
function [unary, unary_len] = generate_unary(letternum_set, len)
unary = '';
unary_len = 0;
while unary_len < min(len, rand(1) * 3)
    rindex = randperm(length(letternum_set));
    
    unary = [unary, letternum_set{ rindex(1) }];
    unary_len = unary_len + 1;
end

rindex = randperm(length(letternum_set));
unary = [unary, letternum_set{ rindex(1) }];
unary_len = unary_len + 1;

end

%%
function [unary, unary_len] = generate_full_unary(letternum_set, len)
unary = '';
unary_len = 0;
while unary_len < len
    rindex = randperm(length(letternum_set));
    
    unary = [unary, letternum_set{ rindex(1) }];
    unary_len = unary_len + 1;
end

rindex = randperm(length(letternum_set));
unary = [unary, letternum_set{ rindex(1) }];
unary_len = unary_len + 1;

end

















