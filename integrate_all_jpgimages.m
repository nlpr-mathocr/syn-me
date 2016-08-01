function integrate_all_jpgimages()
mkdir('gray-tex-images');
datalist = {'1-', '2-', '3-', '4-', '5-', '61-', '62-', '7-', '8-', '91-', '92-', '93-', '94-', '95-'};
numlist = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
for did = 1 : length(datalist)
    for i = 1 : numlist(did)
        src_name = [datalist{did}, 'gray-tex-images/', num2str(i), '.jpg'];
        if ~exist(src_name, 'file')
            continue
        end
        dst_name = ['gray-tex-images/', datalist{did}, num2str(i), '.jpg'];
        copyfile(src_name, dst_name);
    end
end
