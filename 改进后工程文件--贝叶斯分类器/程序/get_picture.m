function [word, cnum]=get_picture(imp)
I=imp;
figure(1);
imshow(I);
title('��Ҫʶ���ԭʼͼ��','color','b');
thresh=graythresh(I);
I=im2bw(I,thresh); 
se=strel('rectangle',[2,1]) ;%ת��ֵ
I=imerode(I,se);  %��ʴ
I=imdilate(I,se);%����
ii=double(I);
[p,q]=size(ii);  %��ȡͼ���С��Ϣ
%ȷ����������
%����ɨ��
countY=zeros(p,1);
for i=1:p
    for j=1:q
        if ii(i,j)==0
            countY(i,1)=countY(i,1)+1;
        end
    end
end
[maxY,index_y]=max(countY);%index_YΪmax��������
temp_y1=index_y;
while (countY(temp_y1,1)>3) && (temp_y1>1)%&&�������һ�����ʽ�������Ļ�������ı��ʽ������
    temp_y1=temp_y1-1;
end
temp_y2=index_y;
while (countY(temp_y2,1)>3) && (temp_y2<p)
    temp_y2=temp_y2+1;
end
temp_y1=temp_y1-1;
temp_y2=temp_y2+1;
ii_Y=I(temp_y1:temp_y2,:);  %ȷ����Y�����ϵ���������
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
ii_XY=ii_Y(:,temp_x1:temp_x2);  %ȷ����������������� 
ii=(ii_XY~=1);%��ɫ��������ɫ����
ii=bwareaopen(ii,10);  %ɾ�����С��200������ͼ��
my_I=charslice(ii);  %�޶���������
%figure(11);
imshow(ii);
title('�޶����������ͼ��','color','b');
maxnum=40;
k=1;                  %maxnumΪ�ַ������޶�ֵ��k����ͳ��ʵ���ַ�����
word=cell(1,maxnum);  %������Ԫ���У����ڴ����ַ�
 
 while size(my_I,2)>1
    %��myI�ĳ���С����10����ȷ��û���ַ���
    [word{k},my_I]=getword(my_I); 
%     [m,n]=size(my_I);
%     if
    k=k+1;
   
end
cnum=k-1;  %ʵ���ַ��ܸ���
for j=1:cnum
    word{j}=imresize(word{j},[40 40]);  %�ַ���񻯳�40��40��
end
figure(2);
for j=1:cnum
    subplot(5,8,j);
    word{j}=(word{j}~=1);
    imshow(word{j});
    title(int2str(j));  %��ʾ�ַ�
end