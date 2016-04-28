function tmp_set = sort_used_set(ori_set, percent, symbol_num)
tmp_num = ceil(percent * symbol_num);
if tmp_num > length(ori_set)
    tmp_set = ori_set;
else
    rnd_index = randperm(length(ori_set));
    tmp_set = ori_set(rnd_index(1 : tmp_num));
end

