    

for i=1:5
    imp=imread(['C:\Users\blugr\Desktop\机器人建模Project\机器人建模Project - 副本\改进后工程文件--贝叶斯分类器\字库\字库' num2str(i),'.png']);%在这里调取字库
    create_database(imp,i);
end
load templet pattern;
aa=imread('choosen.jpg');%读入想识别的文字
[word, cnum]=get_picture(aa);
%cc=imresize(aa,[120 90]);
for i=1:cnum
    class=bayesBinaryTest(word{i});
     Code(i)=pattern(class).name;
end

% figure(3);
% imshow(aa);
tt=title(['识别文字: ', Code(1:cnum)],'Color','b'); 
% figure
ap=imread(['C:\Users\blugr\Desktop\机器人建模Project\机器人建模Project - 副本\改进后工程文件--贝叶斯分类器\字库\拼接字库\',Code(1),'.png']);
    Picture = imresize(ap,1); 
%      subplot(1,cnum,1);
     pic=Picture;
     pic=im2bw(pic,0.5);
%      imshow(pic);
for i=2:cnum
    api=imread(['C:\Users\blugr\Desktop\机器人建模Project\机器人建模Project - 副本\改进后工程文件--贝叶斯分类器\字库\拼接字库\',Code(i),'.png']);
    Picture1= imresize(api,1);
    Picture1=im2bw(Picture1,0.5);
%    subplot(1,cnum,i);
%    imshow(Picture1);
      pic=[pic,Picture1];
    
end 

 
imwrite(pic,'X.jpg')
X=imread('X.jpg');
%preprocess
% figure
[m,n,o]=size(X);
a=round(n/m*256);
p=ones(256,a);
bw=im2bw(X,0.5);%转换成二值图像
%用矩形框截取图像
[i,j]=find(bw==0);
imin=min(i);
imax=max(i);
jmin=min(j);
jmax=max(j);
bw1=bw(imin:imax,jmin:jmax);
[x1,y1]=size(bw1);
%调整比例
rate=min((256/x1),(a/y1));%求取放大比率
bw1=imresize(bw1,rate);%按照比率放大
[i,j]=size(bw1);%求取行列数
i1=round((256-i)/2);%取整
j1=round((a-j)/2);
p(i1+1:i1+i,j1+1:j1+j)=bw1;%图像从右向暂存
p=-1.*p+ones(256,a); 
%显示预处理的结果
% axes(h2);
% imshow(p);

imwrite(p,'X.jpg');
M=imread("X.jpg");
axes(h2);
imshow(M);
%使用256扩大像素格数，使得偏旁分开 