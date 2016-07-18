function distort_formulas(data_num,im_num)
color_regular=[data_num,'color-tex-regular/'];
color_gray=[data_num,'gray-tex-images/'];
color_affine=[data_num,'affine-param/'];
color_distort=[data_num,'distort-adjust-bbox-config/'];
color_adjust=[data_num,'adjust-bbox-config/'];
if ~isdir(color_gray)
    mkdir(color_gray)
end
if ~isdir(color_affine)
    mkdir(color_affine);
end
if ~isdir(color_distort)
    mkdir(color_distort);
end

template2 = [1, 1,1; 1 1 1;1 1 1];
target_h = 512;
target_w = 512;


parfor i = 1 : im_num
    im = imread([color_regular, num2str(i), '.png']);
    imname =[num2str(i),'.jpg'];
%     im = imdilate(im, template1);
%     [ori_h, ori_w, ~] = size(im);
    target_im = zeros(target_h, target_w, 3);
    bbox_config = load(strcat(color_adjust,'/bbox_', num2str(i), '.config'));
    [row col]=size(bbox_config);
    bbox_h=[];
    bbox_w=[];
    for j=1:row
        bbox_h=[bbox_h,bbox_config(j,4)-bbox_config(j,2)];
        bbox_w=[bbox_w,bbox_config(j,5)-bbox_config(j,3)];
    end
    bbox_h=median(bbox_h);
    bbox_w=median(bbox_w);
    %% get tmp distort image
    %tmp_im = imdilate(im, template2);
    sx=(32/bbox_w+32/bbox_h)/2;
    sx1=random('unif',0.8,1.2);
    shx=random('unif',-0.3,0.3);
    shy=random('unif',-0.3,0.3);
    theta=20*(rand(1)-0.5);
    %theta=30;
    scale=[sx*sx1,0,0;0,sx*sx1,0;0,0,1];
    gscale=[sx,0,0;0,sx,0;0,0,1];
    shear=[1,shx,0;shy,1,0;0,0,1];
    rotate=[cosd(theta),-sind(theta),0;sind(theta),cosd(theta),0;0,0,1];
    T=scale*rotate'*shear';
    GT=gscale;
    tform= maketform('affine',T);
    gtform=maketform('affine',GT);
    [tmp_im,xdata,ydata] = imtransform(im,tform,'nearest');    
    [tmp_gim,gxdata,gydata] = imtransform(im,gtform,'nearest'); 
    [height width channel]=size(tmp_im); 
    [gheight gwidth channel]=size(tmp_gim);
    pixel=30;
    while width>target_w||gwidth>target_w
        pixel=pixel-1;
        sx=(pixel/bbox_w+pixel/bbox_h)/2;
        %sx1=random('unif',0.8,1.2);
        sx1=random('unif',0.8,1.2);
        scale=[sx*sx1,0,0;0,sx*sx1,0;0,0,1];
        gscale=[sx,0,0;0,sx,0;0,0,1];
        T=scale*rotate'*shear';
        GT=gscale;
        tform= maketform('affine',T);
        gtform=maketform('affine',GT);
       [tmp_im,xdata,ydata] = imtransform(im,tform,'nearest');    
       [tmp_gim,gxdata,gydata] = imtransform(im,gtform,'nearest'); 
       [height width channel]=size(tmp_im); 
       [gheight gwidth channel]=size(tmp_gim);
    end
      
%     [height width channel]=size(tmp_im);
    rh=max(ceil(rand(1)*(target_h-height)),1);
    rw=max(ceil(rand(1)*(target_w-width)),1);
    rw1=max(ceil((target_w-width)/2),1);%Ô­À´µÄ¸ß¶ÈºÍ³¤¶È
    rh1=max(ceil((target_h-height)/2),1);
    T=[sx1,theta,(rw-rw1)/target_w,(rh-rh1)/target_h,shx,shy];
%     fprintf(fid,'%s ',imname);
%     for j=1:6
%     fprintf(fid,'%g ',T(j));
%     end
    dlmwrite([color_affine,'affine_', num2str(i), '.config'] ,T, 'delimiter', '\t');
    target_im(rh:(rh+height-1),rw:(rw+width-1),:)=tmp_im;
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
       imwrite(result_im, [color_gray, imname], 'jpg');  
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
		imwrite(im, [color_gray, imname], 'jpg');      
    end
%     %% distort bounding box
%     bbox_config = load(strcat('bbox-config/bbox_', num2str(i), '.config'));
%     [row col]=size(bbox_config);
%     distort_config=[];
%     for j=1:row
%        point=[bbox_config(j,3),bbox_config(j,2);
%               bbox_config(j,3),bbox_config(j,4);
%               bbox_config(j,5),bbox_config(j,2);
%               bbox_config(j,5),bbox_config(j,4)];
%        target_point = tformfwd(point,tform);          
%        target_point(:,1)= target_point(:,1) - xdata(1)+rw;
%        target_point(:,2)= target_point(:,2) - ydata(1)+rh;
%        target_point=ceil(target_point);
%        distort_config=[distort_config;bbox_config(j,1),target_point(1,2),target_point(1,1),target_point(3,2),target_point(3,1),target_point(4,2),target_point(4,1),target_point(2,2),target_point(2,1)] ;
%     end     
%     dlmwrite(strcat('distort-bbox-config/bbox_', num2str(i), '.config') ,distort_config, 'delimiter', '\t');    
%    %% distort adjust bounding box
     distort_config=[];    
    for j=1:row
       point=[bbox_config(j,3),bbox_config(j,2);
              bbox_config(j,3),bbox_config(j,4);
              bbox_config(j,5),bbox_config(j,2);
              bbox_config(j,5),bbox_config(j,4)];
       target_point = tformfwd(point,tform);          
       target_point(:,1)= target_point(:,1) - xdata(1)+rw;
       target_point(:,2)= target_point(:,2) - ydata(1)+rh;
       target_point=ceil(target_point);
       if bbox_config(j,1)~=98
         distort_config=[distort_config;bbox_config(j,1),target_point(1,2),target_point(1,1),target_point(3,2),target_point(3,1),target_point(4,2),target_point(4,1),target_point(2,2),target_point(2,1),roundn((target_point(1,1)+target_point(3,1))/2,-1),roundn((target_point(1,2)+target_point(4,2))/2,-1)] ;
       else
         center_point=[bbox_config(j,6),bbox_config(j,7)];
         new_point = tformfwd(center_point,tform);
         new_point(:,1)= new_point(:,1) - xdata(1)+(target_w-width)/2;
         new_point(:,2)= new_point(:,2) - ydata(1)+(target_h-height)/2;
         new_point=roundn(new_point,-1);
         distort_config=[distort_config;bbox_config(j,1),target_point(1,2),target_point(1,1),target_point(3,2),target_point(3,1),target_point(4,2),target_point(4,1),target_point(2,2),target_point(2,1),new_point(1),new_point(2)] ;
       end
    end          
     dlmwrite([color_distort,'bbox_', num2str(i), '.config'] ,distort_config, 'delimiter', '\t');
end
end
