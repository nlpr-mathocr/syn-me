function batch_write_densebox_data()
datalist = {''};
numlist = 144;
densebox_data_filename = 'train.txt';
densebox_data_fp = fopen(densebox_data_filename, 'w');

for did = 1 : length(datalist)
    for i = 1 : numlist(did)
        imname = [datalist{did}, num2str(i), '.jpg'];
        cfgname = [datalist{did}, 'disturbed-bbox-config/bbox_', num2str(i), '.config'];
        if ~exist(['gray-tex-images/', imname], 'file')
            continue
        end
        bboxes = load(cfgname);
        bbox_num = size(bboxes, 1);
        fprintf(densebox_data_fp, '%s', imname);
        for bid = 1 : bbox_num
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 2));
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 3));
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 4));
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 5));
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 6));
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 7));
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 8));
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 9));
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 10));
            fprintf(densebox_data_fp, ' %g', bboxes(bid, 11));
            fprintf(densebox_data_fp, ' 1 1');
            fprintf(densebox_data_fp, ' %g', (bboxes(bid, 1) + 1));
            fprintf(densebox_data_fp, ' %g', (bboxes(bid, 1) + 1));
            fprintf(densebox_data_fp, ' 0 0');
        end
        fprintf(densebox_data_fp, '\n');
    end
end
fclose(densebox_data_fp);
