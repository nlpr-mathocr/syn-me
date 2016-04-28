0. color_tex.tex 是被着色的tex公式列表, 用于在linux端生成公式图像
1. color-list.txt 是根据H通道划分颜色之后对应的rbg通道数值
2. generate_formula.m 是生成单个公式的函数
3. get_formulas.m 是生成color_tex.tex文件的函数, 按行存放着着色的公式
4. hsvread.m 将tex2im生成的图像转为hsv格式的函数
5. parsing_by_config.m 生成parsing的图像, 文件名代表着符号
6. regular_teximages.m 将linux生成的图像都归一化到同一个分辨率 -> 重命名regular_imageformat.m
7. set_symbol_color.m 给公式着色
8. sort_used_set.m 选取符号集
9. get_color_label_list.m 生成color-list.txt 和 label-list.txt
10. get_caffe_data.m 生成灰度图像, 以及label
11. expand_samples.m 对生成的图像与标签进行膨胀
12. distort_formulas.m 对彩色公式图像进行扰动
13. expand_labels.m 对label进行膨胀, 用于multi-task的一个label-channel
14. extract_origin_boundingbox.m 对原图的符号进行bounding_box的提取, 生成四个点的坐标以及label值
15. convert_im2uint8.m 将uint16图像转化成uint8图像

# 使用流程
. 运行get_color_label_list 生成color-list.txt 和 label-list.txt
. 在label-list.txt 中填入所有符号的list, 然后在operater-list.txt 中填入运算符的list
. 运行get_formulas 得到color_tex.tex
. 在linux端生成彩色的公式图像
. 运行convert_im2uint8和regular_imageformat, 统一图像的格式 #运行regular_teximages 归一化分辨率
. 运行extract_origin_boundingbox, 提取bounding-box

+ parsing:
. 运行distort_formulas, 对彩色图像进行扰动
. 运行parsing_by_config 生成label图像
. 运行get_caffe_data 生成灰度图和label, 默认生成二值图
. 运行expand_labels 生成膨胀的label, 运行前需要提前设定uncare_label的值
. 如果需要, 运行expand_samples 生成膨胀后的样本
 
+ densebox: (prepare_densebox_data_from_image.m 会依次执行下面的脚本)
. 运行adjust_boundingbox.m, 调整某些类别的bounding-box
. 运行distort_formulas, 对彩色图像进行扰动
. 运行parsing_by_config 生成label图像
. 运行get_caffe_data 生成灰度图和label, 默认生成二值图
. 运行get_caffe_densebox_data.m, 生成训练densebox所需要的数据
 
# 上面的流程还能简化, parsing_by_config.m 可以直接生成带label信息的图像
# 优化 2015 07 07 优化了公式长度的控制策略, 不至于生成极其冗长的公式
# 2015 07 10 添加一步来生成膨胀的label与image
# 2015 07 14 丰富符号集合, 再一次优化公式长度的计算
# 2015 07 14 在get_caffe_data 中添加灰度图接口
# 2015 07 15 修复了H通道索引的重大bug, 从HSV反向生成RGB时H通道不能值为1
# 2015 07 19 增加了分式的选项
# 2015 07 20 修改regular_teximages不进行归一化操作, 并将这步操作命名为regular_imageformat
# 2015 07 20 添加distort_formulas.m 对彩色图像进行扰动
# 2015 07 21 修改regular_imageformat, 生成黑底图像, 先膨胀后腐蚀让样本更像真实数据
# 2015 07 22 修改distort_formulas, 进行加速, 加速幅度20倍左右
# 2015 07 22 修改get_caffe_data, 灰度图的背景生成方案用现成的背景图
# 2015 07 22 修改get_caffe_data, 用彩色图做背景, 并且以jpg格式存储, 深色字彩底
# 2015 07 24 添加expand_labels 生成膨胀的label
# 2015 07 26 完成expand_labels, 以及加速优化, 运行前需要提前设定uncare_label的值
# 2015 07 30 完成extract_origin_boundingbox
# 2015 07 30 修改get_formula, 生成的tex_i.config文件就是数值矩阵 label h_value
# 2015 07 31 修改distort_formulas, 生成形变后的bounding-box坐标
# 2015 07 31 修改get_caffe_data, 生成center-label数据
# 2015 07 31 修改parsing_by_config, 不用写这么啰嗦了
# 2015 08 09 将类别增加到了94类
# 2015 09 09 将括号移出pair_set, 左右括号当做单独的一个符号处理, 删除long arrow, 类别数为95类
# 2015 09 09 修改extract_origin_boundingbox, 将i j 除号这样带点中的点做特殊处理
# 2015 10 07 修改了运行extract_origin_boundingbox 针对i j = >= <= ÷ ≈ ％ ... :做了特殊处理, 基本思路都是近邻匹配思路
# 2015 10 07 修改了括号的着色方法, 左右括号的颜色不同, 根号作为一个单独的集合, 但是在生成公式串的时候跟pair_set放在一起
# 2015 10 07 优化了公式生成策略, 数字一定都有概率出现, 字母取一部分出现
# 2015 10 08 修改了get_caffe_data 最终的labelmap, centerlabel 分别生成两组, 其中一组是降分辨率的
# 2015 10 08 修改了公式生成的流程, 需要预先修改两个txt文件: label-list.txt & operater-list.txt
# 2015 10 10 加速了regular_imageformat, 对于lib做for循环
# 2015 10 12 修改了distort_formulas, 增加了global_scale的变量用来处理图像DPI太大带来的问题, 缩小了倾斜的范围
# 2015 10 15 add gray_contrast into get_caffe_data
# 2015 10 15 add get_caffe_mulcls_densebox_data.m to generate multi-class gt 
# 2015 10 26 refine the for loop
# 2016 04 26 128 MS categories
# 2016 04 26 refine the bounding box of sqrt symbol in 'extract_origin_boundingbox.m'



