function hsvim = hsvread(filename)
[map, lib] = imread(filename);
% lib = uint8(255 * reshape(lib, size(lib, 1), 1, 3));
% hsvlib = rgb2hsv(lib);
% hlib = hsvlib(:, :, 1);
% him = zeros(size(map, 1), size(map, 2));
% for h = 1 : size(map, 1)
%     for w = 1 : size(map, 2)
%         him(h, w) = hlib(map(h, w)+1);
%     end
% end
rgbim = zeros(size(map, 1), size(map, 2), 3);
for h = 1 : size(map, 1)
    for w = 1 : size(map, 2)
        rgbim(h, w, :) = 255 * lib(map(h,w)+1, :);
    end
end
hsvim = rgb2hsv(uint8(rgbim));









