    

for i=1:5
    imp=imread(['C:\Users\blugr\Desktop\�����˽�ģProject\�����˽�ģProject - ����\�Ľ��󹤳��ļ�--��Ҷ˹������\�ֿ�\�ֿ�' num2str(i),'.png']);%�������ȡ�ֿ�
    create_database(imp,i);
end
load templet pattern;
aa=imread('choosen.jpg');%������ʶ�������
[word, cnum]=get_picture(aa);
%cc=imresize(aa,[120 90]);
for i=1:cnum
    class=bayesBinaryTest(word{i});
     Code(i)=pattern(class).name;
end

% figure(3);
% imshow(aa);
tt=title(['ʶ������: ', Code(1:cnum)],'Color','b'); 
% figure
ap=imread(['C:\Users\blugr\Desktop\�����˽�ģProject\�����˽�ģProject - ����\�Ľ��󹤳��ļ�--��Ҷ˹������\�ֿ�\ƴ���ֿ�\',Code(1),'.png']);
    Picture = imresize(ap,1); 
%      subplot(1,cnum,1);
     pic=Picture;
     pic=im2bw(pic,0.5);
%      imshow(pic);
for i=2:cnum
    api=imread(['C:\Users\blugr\Desktop\�����˽�ģProject\�����˽�ģProject - ����\�Ľ��󹤳��ļ�--��Ҷ˹������\�ֿ�\ƴ���ֿ�\',Code(i),'.png']);
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
bw=im2bw(X,0.5);%ת���ɶ�ֵͼ��
%�þ��ο��ȡͼ��
[i,j]=find(bw==0);
imin=min(i);
imax=max(i);
jmin=min(j);
jmax=max(j);
bw1=bw(imin:imax,jmin:jmax);
[x1,y1]=size(bw1);
%��������
rate=min((256/x1),(a/y1));%��ȡ�Ŵ����
bw1=imresize(bw1,rate);%���ձ��ʷŴ�
[i,j]=size(bw1);%��ȡ������
i1=round((256-i)/2);%ȡ��
j1=round((a-j)/2);
p(i1+1:i1+i,j1+1:j1+j)=bw1;%ͼ��������ݴ�
p=-1.*p+ones(256,a); 
%��ʾԤ����Ľ��
% axes(h2);
% imshow(p);

imwrite(p,'X.jpg');
M=imread("X.jpg");
axes(h2);
imshow(M);
%ʹ��256�������ظ�����ʹ��ƫ�Էֿ� 