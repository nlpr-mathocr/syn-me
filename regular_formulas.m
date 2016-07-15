clear; close all; clc
if ~isdir('gray-tex-images/')
    mkdir('gray-tex-images')
end

if ~isdir('distort-adjust-bbox-config/')
    mkdir('distort-adjust-bbox-config');
end

im_num = length(dir('color-tex-regular/*.png'));

target_h = 512;
target_w = 512;

template2 = [1, 1,1; 1 1 1;1 1 1];


global_scale = 0.3333;

parfor i = 1 : im_num
    im = imread(strcat('color-tex-regular/', num2str(i), '.png'));
%     im = imdilate(im, template1);
    
    [ori_h, ori_w, ~] = size(im);
    target_im = zeros(target_h, target_w, 3);
    bbox_h=[];
    bbox_w=[];
    bbox_config = load(strcat('adjust-bbox-config/bbox_', num2str(i), '.config'));
    [row col]=size(bbox_config);
    for j=1:row
        bbox_h=[bbox_h,bbox_config(j,4)-bbox_config(j,2)];
        bbox_w=[bbox_w,bbox_config(j,5)-bbox_config(j,3)];
    end
    bbox_h=median(bbox_h);
    bbox_w=median(bbox_w);
    %% get tmp distort image
    %tmp_im = imdilate(im, template2);
    sx=(32/bbox_w+32/bbox_h)/2;
    sy=(32/bbox_w+32/bbox_h)/2;
    scale=[sx,0,0;0,sy,0;0,0,1];
    GT=scale;
    gtform=maketform('affine',GT);
    [tmp_gim,gxdata,gydata]=imtransform(im,gtform,'nearest');  
    [height width channel]=size(tmp_gim);
    pixel=30;
    while width>target_w
        pixel=pixel-1;
        sx=(pixel/bbox_w+pixel/bbox_h)/2;
        gscale=[sx,0,0;0,sx,0;0,0,1];
        GT=gscale;
        gtform=maketform('affine',GT);  
       [tmp_gim,gxdata,gydata] = imtransform(im,gtform,'nearest'); 
       [height width channel]=size(tmp_gim);
    end 
    rw=max(ceil((target_w-width)/2),1);
    rh=max(ceil((target_h-height)/2),1);
    target_im(rh:(rh+height-1),rw:(rw+width-1),:)=tmp_gim;
    if rand(1)>0.5
       target_im=imdilate( target_im, template2);
       result_im = zeros(target_h, target_w);
       for j = 1 : target_h
           for k = 1 : target_w
               if sum(target_im(j , k , :))==0
                   result_im(j,k)=113;
               else
                   result_im(j,k)=0;
               end
           end
       end
       result_im=uint8(result_im);
       imwrite(result_im, strcat('gray-tex-images/', num2str(i), '.jpg'), 'jpg');  
    else
        half_h = floor(target_h / 2);
        half_w = floor(target_w / 2);
        bklib_num = length(dir('newbackground/*.jpg'));
        gray_contrast = 60;
        sigma = 1; 
        gausFilter = fspecial('gaussian',[3 3],sigma);
        im_ori = uint8(target_im);
        im_ori = double(rgb2gray(im_ori));
        bk = rgb2gray(imread(strcat('newbackground/', num2str(ceil(rand(1) * bklib_num)), '.jpg')));
        bk_mean = mean(bk(:));
        im = ((bk_mean - gray_contrast) * rand(1)) * double(im_ori > 0);
        im = im + double(im == 0) .* double(bk);
        im = imfilter(im, gausFilter, 'replicate');
		im = uint8(im);
		imwrite(im, strcat('gray-tex-images/', num2str(i), '.jpg'), 'jpg');      
    end
     distort_config=[];
     for j=1:row
       point=[bbox_config(j,3),bbox_config(j,2);
              bbox_config(j,3),bbox_config(j,4);
              bbox_config(j,5),bbox_config(j,2);
              bbox_config(j,5),bbox_config(j,4)];
       target_point = tformfwd(point,gtform);          
       target_point(:,1)= target_point(:,1) - gxdata(1)+(target_w-width)/2;
       target_point(:,2)= target_point(:,2) - gydata(1)+(target_h-height)/2;
       target_point=ceil(target_point);
       if bbox_config(j,1)~=98
         distort_config=[distort_config;bbox_config(j,1),target_point(1,2),target_point(1,1),target_point(3,2),target_point(3,1),target_point(4,2),target_point(4,1),target_point(2,2),target_point(2,1),roundn((target_point(1,1)+target_point(3,1))/2,-1),roundn((target_point(1,2)+target_point(4,2))/2,-1)] ;
       else
         center_point=[bbox_config(j,6),bbox_config(j,7)];
         new_point = tformfwd(center_point,gtform);
         new_point(:,1)= new_point(:,1) - gxdata(1)+(target_w-width)/2;
         new_point(:,2)= new_point(:,2) - gydata(1)+(target_h-height)/2;
         new_point=roundn(new_point,-1);
         distort_config=[distort_config;bbox_config(j,1),target_point(1,2),target_point(1,1),target_point(3,2),target_point(3,1),target_point(4,2),target_point(4,1),target_point(2,2),target_point(2,1),new_point(1),new_point(2)] ;
       end
    end          
     dlmwrite(strcat('distort-adjust-bbox-config/bbox_', num2str(i), '.config') ,distort_config, 'delimiter', '\t');
 end