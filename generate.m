clear all
clc
datalist={'7-';'8-';'91-';'92-';'93-';'94-'};
%numlist=[30000,30000,30000,30000,30000,10000];
numlist=[10,10,10,20,10,5];
for i=1:2
    datanum=datalist(i);
    datanum=char(datanum);
    imnum=numlist(i);
    convert_im2uint8(datanum,imnum);
    regular_imageformat(datanum,imnum,1);
    extract_origin_boundingbox(datanum,imnum);
    adjust_boundingbox(datanum,imnum);
    distort_formulas(datanum,imnum);
end
for i=3:6
    datanum=datalist(i);
    datanum=char(datanum);
    imnum=numlist(i);
    regular_imageformat(datanum,imnum,0);
    extract_origin_boundingbox(datanum,imnum);
    adjust_boundingbox(datanum,imnum);
    distort_formulas(datanum,imnum);
end
