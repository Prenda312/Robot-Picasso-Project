function sampleTraining(cla,fea,dataSet)
%ѧϰ������������
%cla��ʾ�ڼ����༴���ָ���,fea��ʾ�ڼ�����������������,dataSetΪѧϰ���ַ���
%ÿ������ͼƬ���ֳ�10*10=100��cell
%��Ҫע��ͼƬ�ĵĳ��Ϳ��豻�����10�ı���,��Ϊ����Ҫ��10��
clc;            %����
 load templet pattern;   %���غ�������
A=imread(['C:\Users\Lenovo\Desktop\�����ļ�\�Ľ��󹤳��ļ�--��Ҷ˹������\�ֿ�\���ɵ��ֿ�\',dataSet(cla),num2str(fea),'.png']);
figure(1),imshow(A) %��ʾ��ȡ����д�Ҷ�ͼ'C:\Users\Lenovo\Desktop\�����ļ�\�Ľ��󹤳��ļ�--��Ҷ˹������\�ֿ�\���ɵ��ֿ�\',code(j),num2str(num),'.png'
B=zeros(1,100);     %����1��100�е�����
pattern(cla).feature(:,fea)=zeros(100,1); %��ʼ����ǰ��ĵ�fea����ʼ����������
[row,col] = size(A); %��ȡ����ͼƬ������
cellRow = row/10;    %����10�õ�1/100��С����
cellCol = col/10;
count = 0;           %ÿ1/100��������Ϊ0�����ص����
currentCell = 1;     %��ǰ����Ϊ��1��1/100���Ӳ���
for currentRow = 0:9
    for currentCol = 0:9
       for i = 1:cellRow      %����ÿ1/100������Ϊ0������
           for j = 1:cellCol
               if(A(currentRow*cellRow+i,currentCol*cellCol+j)==0)
                   count=count+1;
               end
           end
        end
        ratio = count/(cellRow*cellCol); %����1/100�����к�ɫ���ص�ռ��
        B(1,currentCell) = ratio;        %��ÿ��ռ��ͳ����B����������
        currentCell = currentCell+1;     %�µ�1/100���ֿ�ʼ����
        count = 0;                       %���ص������0
     end
end
pattern(cla).num=5;             %�����������(feature�е�����)
pattern(cla).name=dataSet(cla); %��ǰ�����ĺ����ַ�
pattern(cla).feature(:,fea)=B'; %��ǰ���fea����������
save templet pattern            %����ѧϰ�����ĺ�������
%                
            
