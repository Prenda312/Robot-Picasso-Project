function studyData()
%�Զ���ѧϰ����ѵ��������
%ͨ��ѭ����ÿһ��ѧϰ��������ѧϰ����
clear templet pattern;          %���ѧϰ����
%pattern(1).num=0;
dataSet = '������ѧ�����˿����뽨ģ';  %ѧϰ���ַ���
for i = 1:12    %12������
    for j = 1:8 %ÿ��������Ҫ5������������5��������
        sampleTraining(i,j,dataSet); %ѭ��ѧϰ������
    end
end