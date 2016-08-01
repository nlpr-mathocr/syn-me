mkdir('gray-tex-images');

for i=1:30000
    a=['3-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/3_',num2str(i),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:30000
    a=['2-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/2_',num2str(i),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:15000
    a=['1-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/1_',num2str(i),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:15000
    a=['4-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/4_',num2str(i),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:15000
    a=['5-gray-tex-images/',num2str(i),'.jpg'];
    if ~exist(a, 'file')
        continue;
    end
    b=['gray-tex-images/5_',num2str(i),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:30000
    a=['7-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/7_',num2str(i),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:30000
    a=['8-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/8_',num2str(i),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:15000
    a=['61-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/6_',num2str(i),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:15000
    a=['62-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/6_',num2str(i+15000),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:30000
    a=['91-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/9_',num2str(i),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:30000
    a=['92-gray-tex-images/',num2str(i),'.jpg'];
    if ~exist(a, 'file')
        continue;
    end
    b=['gray-tex-images/9_',num2str(i+30000),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:30000
    a=['93-gray-tex-images/',num2str(i),'.jpg'];
    if ~exist(a, 'file')
        continue;
    end
    b=['gray-tex-images/9_',num2str(i+60000),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:10000
    a=['94-gray-tex-images/',num2str(i),'.jpg'];
    b=['gray-tex-images/9_',num2str(i+90000),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
for i=1:5000
    a=['95-gray-tex-images/',num2str(i),'.jpg'];
    if ~exist(a, 'file')
        continue;
    end
    b=['gray-tex-images/9_',num2str(i+100000),'.jpg'];
    unix(['mv ',a,' ',b]);
    %movefile(b,a);
end
