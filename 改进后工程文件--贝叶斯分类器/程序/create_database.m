function create_database(imp,num)
%����׼�ַ�ͼ���и�������ֿ�
%impΪͼ��numΪͼ��ĵڼ����ص�
code=char('������ѧ�����˽�ģ�����');%�����ַ���
G=imp;

thresh=graythresh(G);
% ʹ�� Otsu �������ݻҶ�ͼ�� I ����ȫ����ֵ T��Otsu ����ѡ��һ����ֵ��ʹ��ֵ���ĺڰ����ص����ڷ�����С����
G=im2bw(G,thresh);
% ȫ����ֵ T ���� imbinarize ���ʹ���Խ��Ҷ�ͼ��ת��Ϊ��ֵͼ��
se=strel('rectangle',[2,1]) ;  %����һ����СΪ [m n] �ľ��νṹԪ��
G=imerode(G,se);%ʹ�ýṹԪ�� se ��ʴ�Ҷȡ���ֵ��ѹ����ֵͼ�� G 
G=imdilate(G,se);%ʹ�ýṹԪ�� se ���ͻҶȡ���ֵ��ѹ����ֵͼ�� I
GD=double(G);%ֵת��Ϊ˫����
[m,n]=size(GD);  %��ȡͼ���С��Ϣ
%ȷ����������
%����ɨ��
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
iiY=G(tempy1:tempy2,:);  %ȷ����Y�����ϵ���������
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
iiXY=iiY(:,tempx1:tempx2);  %ȷ�����������������
GD=(iiXY~=1);%��ɫ��������ɫ����
GD=bwareaopen(GD,10);  %ɾ�����С��200������ͼ��
myI=charslice(GD);  %�޶���������
% figure(2);
% imshow(GD);
% title('�޶����������ͼ��','color','b');
maxnum=40;%������������м���
k=1;        %maxnumΪ�ַ������޶�ֵ��k����ͳ��ʵ���ַ�����
word=cell(1,maxnum);  %������Ԫ���У����ڴ����ַ�
while size(myI,2)>10
    %��myI�ĳ���С����10����ȷ��û���ַ���
    [word{k},myI]=getword(myI);  %��ȡ�ַ�
    k=k+1;
end
cnum=k-1;  %ʵ���ַ��ܸ���
% figure(3);
% for j=1:cnum
% subplot(5,8,j),imshow(word{j}),title(int2str(j));  %��ʾ�ַ�
% end
for j=1:cnum
    word{j}=imresize(word{j},[40 40]);  %�ַ���񻯳�40��40��
    word{j}=(word{j}~=1);
end
% figure(4);
% for j=1:cnum
% subplot(5,8,j),imshow(word{j}),title(int2str(j));  %��ʾ��ʽ���ַ�
% end
for j=1:cnum  
imwrite(word{j},['C:\Users\Lenovo\Desktop\�����˽�ģProject\����ʶ��\�ֿ�\���ɵ��ֿ�\',code(j),num2str(num),'.png']);  %�����ַ�
end
