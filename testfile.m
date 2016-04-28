clear; clc

fs = dir('center-labels/*.png');

cnt = 0;
for i = 1 : length(fs)
    im = imread(['center-labels/', fs(i).name]);
    bk = double(im == 0);
    cnt = cnt + sum(bk(:));
end

(1 - cnt / length(im(:)) / length(fs)) / 97 / (cnt / length(im(:)) / length(fs))


% clear; close all; clc
% fs = dir('color-tex-distort/*.png');
% if ~isdir('half-resolution')
%     mkdir('half-resolution');
% end
% template2 = [1, 1; 1 1];
% parfor i = 1 : length(fs)
%     im = imread(['color-tex-distort/', num2str(i), '.png']);
%     [h, w, ~] = size(im);
%     tmp_im = imdilate(im, template2);
%     re_im = zeros(floor(h/2), floor(w/2), 3);
%     
%     [hh, ww] = meshgrid(1 : floor(h / 2), 1 : floor(w / 2));
%     hh = hh(:);
%     ww = ww(:);
%     tarhh = 2 * hh;
%     tarww = 2 * ww;
%     ori_index = [hh + (ww - 1) * floor(h / 2), ...
%         hh + (ww - 1) * floor(h / 2) + floor(h / 2) * floor(w / 2), ...
%         hh + (ww - 1) * floor(h / 2) + 2 * floor(h / 2) * floor(w / 2)];
%     tar_index = [tarhh + (tarww - 1) * h, ...
%         tarhh + (tarww - 1) * h + h * w, ...
%         tarhh + (tarww - 1) * h + h * w * 2];
%     re_im(ori_index) = tmp_im(tar_index);
%     imwrite(uint8(re_im), ['half-resolution/', num2str(i), '.png']);
% end
% 





% id = '67';
% im = imread(['center-labels/', id, '.png']);
% imagesc(double(im))
% im2 = imread(['tex-labels/', id, '.png']);
% figure
% imagesc(double(im2))


% 
% % fp = fopen('label.txt', 'w');
% % lbl = 1;
% % for i = 1 : 10
% %     fprintf(fp, '%d %d\n', mod(i, 10), lbl);
% %     lbl = lbl + 1;
% % end
% % 
% % for i = 1 : 26
% %     fprintf(fp, '%c %d\n', 'a' + i - 1, lbl);
% %     lbl = lbl + 1;
% % end
% % 
% % for i = 1 : 26
% %     fprintf(fp, '%c %d\n', 'A' + i - 1, lbl);
% %     lbl = lbl + 1;
% % end
% % 
% % 
% % fclose(fp)
% 
% 
% 
% clear; clc; close all
% 
% lbls = [];
% for i = 1 : 1000 %ceil(1000 * rand(1))
%     im = imread(strcat('center-labels/', num2str(i), '.png'));
%     
%     tmp = unique(double(im(:)));
%     lbls = [lbls; tmp];
%     lbls = unique(lbls);
%     
%     im(im > 0) = 255;
%     im2 = double(imread(strcat('color-tex-distort/', num2str(i), '.png')));
%     im3 = double(repmat(im, [1, 1, 3])) + im2;
% %     imshow(uint8(im3))
%     
% end
% 
% lbls
% 

% 
% 
% 
% clear; clc; close all
% 
% for i = 1 : 1000%ceil(1000 * rand(1))
%     im = imread(strcat('color-tex-regular/', num2str(i), '.png'));
%     config = load(strcat('bbox-config/bbox_', num2str(i), '.config'));
%     labels = config(:, 1);
%     coords = config(:, 2 : end);
%     for j = 1 : length(labels)
%         coord = coords(j, :); % top left bottom right
%         im(coord(1), coord(2) : coord(4), :) = 255;
%         im(coord(3), coord(2) : coord(4), :) = 255;
%         im(coord(1) : coord(3), coord(2), :) = 255;
%         im(coord(1) : coord(3), coord(4), :) = 255;
%     end
%     imwrite(im, ['bbox-im/', num2str(i), '.png'], 'png');
% end
% 
% 
% 
% 
% % clear; clc; close all
% % 
% % for i = 1 %ceil(1000 * rand(1))
% %     im = imread(strcat('color-tex-distort/', num2str(i), '.png'));
% %     config = load(strcat('distort-bbox-config/bbox_', num2str(i), '.config'));
% %     labels = config(:, 1);
% %     coords = config(:, 2 : end);
% %     for j = 1 : length(labels)
% %         coord = coords(j, :); % top left bottom right
% %         im(coord(1), coord(2), :) = [255, 0, 0];
% %         im(coord(3), coord(4), :) = [255, 0, 0];
% %         im(coord(5), coord(6), :) = [255, 0, 0];
% %         im(coord(7), coord(8), :) = [255, 0, 0];
% %         
% % %         im(coord(1) : coord(3), coord(2), :) = 255;
% % %         im(coord(1) : coord(3), coord(4), :) = 255;
% % %         im(coord(3), coord(2) : coord(4), :) = 255;
% % %         im(coord(1), coord(2) : coord(4), :) = 255;
% %     end
% %     imshow(im)
% % end
% 
% 
% 
