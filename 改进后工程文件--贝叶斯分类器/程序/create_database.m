function create_database(imp,num)
%将标准字符图像切割，来创建字库
%imp为图像，num为图像的第几个特点
code=char('材料力学机器人建模与控制');%创建字符集
G=imp;

thresh=graythresh(G);
% 使用 Otsu 方法根据灰度图像 I 计算全局阈值 T。Otsu 方法选择一个阈值，使阈值化的黑白像素的类内方差最小化。
G=im2bw(G,thresh);
% 全局阈值 T 可与 imbinarize 结合使用以将灰度图像转换为二值图像
se=strel('rectangle',[2,1]) ;  %创建一个大小为 [m n] 的矩形结构元素
G=imerode(G,se);%使用结构元素 se 腐蚀灰度、二值或压缩二值图像 G 
G=imdilate(G,se);%使用结构元素 se 膨胀灰度、二值或压缩二值图像 I
GD=double(G);%值转化为双精度
[m,n]=size(GD);  %获取图像大小信息
%确定文字区域
%纵向扫描
scany=zeros(m,1);
for i=1:m
    for j=1:n
        if GD(i,j)==0
            scany(i,1)=scany(i,1)+1;
        end
    end
end
[maxy,indexy]=max(scany);
tempy1=indexy;
while (scany(tempy1,1)>3) && (tempy1>1)
    tempy1  =tempy1-1;
end
tempy2=indexy;
while (scany(tempy2,1)>3) && (tempy2<m)
    tempy2=tempy2+1;
end
tempy1=tempy1-1;
tempy2=tempy2+1;
iiY=G(tempy1:tempy2,:);  %确定了Y方向上的文字区域
scanx=zeros(1,n);
for j=1:n
    for i=tempy1:tempy2
        if GD(i,j)==0
            scanx(1,j)=scanx(1,j)+1;
        end
    end
end
tempx1=1;
while (scanx(1,tempx1)<3) && (tempx1<n)
    tempx1=tempx1+1;
end
tempx2=n;
while (scanx(1,tempx2)<3) && (tempx2>1)
    tempx2=tempx2-1
end
tempx1=tempx1-1;
tempx2=tempx2+1;
iiXY=iiY(:,tempx1:tempx2);  %确定了整体的文字区域
GD=(iiXY~=1);%黑色背景，白色字体
GD=bwareaopen(GD,10);  %删除面积小于200的杂质图像
myI=charslice(GD);  %限定文字区域
% figure(2);
% imshow(GD);
% title('限定文字区域的图像','color','b');
maxnum=40;%总字数最多能有几个
k=1;        %maxnum为字符个数限定值，k用于统计实际字符个数
word=cell(1,maxnum);  %建立单元阵列，用于储存字符
while size(myI,2)>10
    %当myI的长度小等于10，可确定没有字符了
    [word{k},myI]=getword(myI);  %获取字符
    k=k+1;
end
cnum=k-1;  %实际字符总个数
% figure(3);
% for j=1:cnum
% subplot(5,8,j),imshow(word{j}),title(int2str(j));  %显示字符
% end
for j=1:cnum
    word{j}=imresize(word{j},[40 40]);  %字符规格化成40×40的
    word{j}=(word{j}~=1);
end
% figure(4);
% for j=1:cnum
% subplot(5,8,j),imshow(word{j}),title(int2str(j));  %显示格式化字符
% end
for j=1:cnum  
imwrite(word{j},['C:\Users\Lenovo\Desktop\机器人建模Project\文字识别\字库\生成单字库\',code(j),num2str(num),'.png']);  %保存字符
end
