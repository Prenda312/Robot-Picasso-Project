function class=bayesBinaryTest(imp)
%���ñ�Ҷ˹����������дͼƬʶ��
load templet;         %���غ�������
A = imp;              %�õ���ʶ��ͼƬ
%figure(1),subplot(121),imshow(A),title(['��ʶ��ĺ��֣�']);
B=zeros(1,400);       %����1��100�е���������
[row, col] = size(A);  %�õ���������������
cellRow = row/20;     %���併ά10x10������ͼƬ
cellCol = col/20;
count = 0;            %ÿ1/100��������Ϊ0�����ص����
currentCell = 1;      %��ǰ����Ϊ��1��1/100���Ӳ���
for currentRow = 0:19    
    for currentCol = 0:19    
       for i = 1:cellRow     %����ÿ1/100������Ϊ0������
           for j = 1:cellCol
               if(A(currentRow*cellRow+i,currentCol*cellCol+j)==0)
                   count=count+1;
               end
           end
        end
        ratio = count/(cellRow*cellCol);   %����1/100�����к�ɫ���ص�ռ��
        B(1,currentCell) = ratio;          %��ÿ��ռ��ͳ����B����������
        currentCell = currentCell+1;       %�µ�1/100���ֿ�ʼ����
        count = 0;                         %���ص������0
     end
end
class = bayesBinary(B');                   %�����������ñ�Ҷ˹����������,������ĸ���