%op
%��ȡͼ���ļ�
[filename,pathname]=uigetfile({'*.jpg';'*.png';...
    '*.gif';'*.*'},...
    'Pick an Image File');
X=imread([pathname,filename]);
%��ʾͼ��
axes(h0);%��h0����Ϊ��ǰ��������
imshow(X);%��h0����ʾԭʼͼ��
y=filename;
y1=y(1);

