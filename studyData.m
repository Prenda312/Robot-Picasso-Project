
function studyData()
%�Զ���ѧϰ����ѵ��������
%ͨ��ѭ����ÿһ��ѧϰ��������ѧϰ����
clc;
clear;
clear templet pattern; 
%pattern(1).num=0;
dataSet = '������ѧ�����˿����뽨ģ';  %ѧϰ���ַ���
for i = 1:12    %12������
    for j = 1:8 %ÿ��������Ҫ8������������8��������
        pattern(i).feature(:,j)=zeros(400,1);
    end
end
save templet pattern;
for i = 1:12    %12������
    for j = 1:8 %ÿ��������Ҫ8������������8��������
        sampleTraining(i,j,dataSet); %ѭ��ѧϰ������
    end
end