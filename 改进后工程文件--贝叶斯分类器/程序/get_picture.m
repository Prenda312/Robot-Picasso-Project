function [word, cnum]=get_picture(imp)
I=imp;
figure(1);
imshow(I);
title('需要识别的原始图像','color','b');
thresh=graythresh(I);
I=im2bw(I,thresh); 
se=strel('rectangle',[2,1]) ;%转二值
I=imerode(I,se);  %腐蚀
I=imdilate(I,se);%膨胀
ii=double(I);
[p,q]=size(ii);  %获取图像大小信息
%确定文字区域
%纵向扫描
countY=zeros(p,1);
for i=1:p
    for j=1:q
        if ii(i,j)==0
            countY(i,1)=countY(i,1)+1;
        end
    end
end
[maxY,index_y]=max(countY);%index_Y为max所处行数
temp_y1=index_y;
while (countY(temp_y1,1)>3) && (temp_y1>1)%&&运算符第一个表达式不成立的话，后面的表达式不运算
    temp_y1=temp_y1-1;
end
temp_y2=index_y;
while (countY(temp_y2,1)>3) && (temp_y2<p)
    temp_y2=temp_y2+1;
end
temp_y1=temp_y1-1;
temp_y2=temp_y2+1;
ii_Y=I(temp_y1:temp_y2,:);  %确定了Y方向上的文字区域
countX=zeros(1,q);
for j=1:q
    for i=temp_y1:temp_y2
        if ii(i,j)==0
            countX(1,j)=countX(1,j)+1;
        end
    end
end
temp_x1=1;
while (countX(1,temp_x1)<3) && (temp_x1<q)
    temp_x1=temp_x1+1;
end
temp_x2=q;
while (countX(1,temp_x2)<3) && (temp_x2>1)
    temp_x2=temp_x2-1;
end
temp_x1=temp_x1-1;
temp_x2=temp_x2+1;
ii_XY=ii_Y(:,temp_x1:temp_x2);  %确定了整体的文字区域 
ii=(ii_XY~=1);%黑色背景，白色字体
ii=bwareaopen(ii,10);  %删除面积小于200的杂质图像
my_I=charslice(ii);  %限定文字区域
%figure(11);
imshow(ii);
title('限定文字区域的图像','color','b');
maxnum=40;
k=1;                  %maxnum为字符个数限定值，k用于统计实际字符个数
word=cell(1,maxnum);  %建立单元阵列，用于储存字符
 
 while size(my_I,2)>1
    %当myI的长度小等于10，可确定没有字符了
    [word{k},my_I]=getword(my_I); 
%     [m,n]=size(my_I);
%     if
    k=k+1;
   
end
cnum=k-1;  %实际字符总个数
for j=1:cnum
    word{j}=imresize(word{j},[40 40]);  %字符规格化成40×40的
end
figure(2);
for j=1:cnum
    subplot(5,8,j);
    word{j}=(word{j}~=1);
    imshow(word{j});
    title(int2str(j));  %显示字符
end