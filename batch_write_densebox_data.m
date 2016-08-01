d=strcat('train.txt');
fid=fopen(d,'wt');
for i=1:15000
    e=['1_',num2str(i),'.jpg'];
    b=['1-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:30000
    e=['2_',num2str(i),'.jpg'];
    b=['2-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:30000
    e=['3_',num2str(i),'.jpg'];
    b=['3-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:15000
    e=['4_',num2str(i),'.jpg'];
    b=['4-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:15000    
    e=['5_',num2str(i),'.jpg'];
    filename=['gray-tex-images/',e];
    if ~exist(filename, 'file')
        continue;
    end
    b=['5-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:15000
    e=['6_',num2str(i),'.jpg'];
    b=['61-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:15000
    e=['6_',num2str(i+15000),'.jpg'];
    b=['62-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:30000
    e=['7_',num2str(i),'.jpg'];
    b=['7-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:30000
    e=['8_',num2str(i),'.jpg'];
    b=['8-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:30000
    e=['9_',num2str(i),'.jpg'];
    b=['91-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:30000
    e=['9_',num2str(i+30000),'.jpg'];
    filename=['gray-tex-images/',e];
    if ~exist(filename, 'file')
        continue;
    end
    b=['92-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:30000
    e=['9_',num2str(i+60000),'.jpg'];
    filename=['gray-tex-images/',e];
    if ~exist(filename, 'file')
        continue;
    end
    b=['93-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:10000
    e=['9_',num2str(i+90000),'.jpg'];
    b=['94-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
for i=1:5000
    e=['9_',num2str(i+100000),'.jpg'];
    filename=['gray-tex-images/',e];
    if ~exist(filename, 'file')
        continue;
    end
    b=['95-distort-adjust-bbox-config/bbox_',num2str(i),'.config'];    
    bbox=load(b);
    [row col]=size(bbox);
    fprintf(fid,'%s ',e);
    for k = 1 : row
        fprintf(fid,'%g ',bbox(k,9));
        fprintf(fid,'%g ',bbox(k,8));
        fprintf(fid,'%g ',bbox(k,7));
        fprintf(fid,'%g ',bbox(k,6));
        fprintf(fid,'%g ',bbox(k,5));
        fprintf(fid,'%g ',bbox(k,4));
        fprintf(fid,'%g ',bbox(k,3));
        fprintf(fid,'%g ',bbox(k,2));
        fprintf(fid,'%g ',bbox(k,10));
        fprintf(fid,'%g ',bbox(k,11));
        fprintf(fid,'%s ','1 1');
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%g ',(bbox(k,1)+1));
        fprintf(fid,'%s ','0 0');
    end
    fprintf(fid,'\n') ;
end
fclose(fid);
