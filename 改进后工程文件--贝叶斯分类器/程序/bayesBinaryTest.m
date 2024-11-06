function class=bayesBinaryTest(imp)
%利用贝叶斯分类器对手写图片识别
load templet;         %加载汉字特征
A = imp;              %得到待识别图片
%figure(1),subplot(121),imshow(A),title(['待识别的汉字：']);
B=zeros(1,400);       %创建1列100行的特征向量
[row, col] = size(A);  %得到待测样本的行列
cellRow = row/20;     %将其降维10x10的特征图片
cellCol = col/20;
count = 0;            %每1/100个格子中为0的像素点个数
currentCell = 1;      %当前计算为第1个1/100格子部分
for currentRow = 0:19    
    for currentCol = 0:19    
       for i = 1:cellRow     %计算每1/100部分中为0的数量
           for j = 1:cellCol
               if(A(currentRow*cellRow+i,currentCol*cellCol+j)==0)
                   count=count+1;
               end
           end
        end
        ratio = count/(cellRow*cellCol);   %计算1/100部分中黑色像素的占比
        B(1,currentCell) = ratio;          %将每个占比统计在B特征向量中
        currentCell = currentCell+1;       %新的1/100部分开始计算
        count = 0;                         %像素点计数置0
     end
end
class = bayesBinary(B');                   %将该特征利用贝叶斯分类器分类,返回类的个数