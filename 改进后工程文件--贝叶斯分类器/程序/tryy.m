%clc,clear,close
for i=1:5
    imp=imread(['C:\Users\Lenovo\Desktop\�����˽�ģProject\����ʶ��\�ֿ�\�ֿ�' num2str(i),'.png']);%�������ȡ�ֿ�
    create_database(imp,i);
end
load templet pattern;
aa=imread('example_4.jpg');%������ʶ�������
[word, cnum]=get_picture(aa);
%cc=imresize(aa,[120 90]);
for i=1:cnum
    class=bayesBinaryTest(word{i});
     Code(i)=pattern(class).name;
end

figure(3);
imshow(aa);
tt=title(['ʶ������: ', Code(1:cnum)],'Color','b'); 
figure(1)
ap=imread(['C:\Users\Lenovo\Desktop\�����˽�ģProject\����ʶ��\�ֿ�\ƴ���ֿ�\',Code(1),'.png']);
    Picture = imresize(ap,1); 
     subplot(1,cnum,1);
     imshow(Picture);
     pic=Picture;
for i=2:cnum
    ap=imread(['C:\Users\Lenovo\Desktop\�����˽�ģProject\����ʶ��\�ֿ�\ƴ���ֿ�\',Code(i),'.png']);
    Picture = imresize(ap,1); 
     subplot(1,cnum,i);
     imshow(Picture);
     pic=[pic,Picture];
end 

 
imwrite(pic,'writing.jpg')
X=imread('writing.jpg');
%preprocess
figure
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
imwrite(p,'testsave.jpg');
%ʹ��256�������ظ�����ʹ��ƫ�Էֿ�   