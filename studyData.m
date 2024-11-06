
function studyData()
%自动化学习所有训练样本集
%通过循环对每一个学习样本调用学习函数
clc;
clear;
clear templet pattern; 
%pattern(1).num=0;
dataSet = '材料力学机器人控制与建模';  %学习的字符集
for i = 1:12    %12个汉字
    for j = 1:8 %每个汉字需要8个特征向量即8个样本集
        pattern(i).feature(:,j)=zeros(400,1);
    end
end
save templet pattern;
for i = 1:12    %12个汉字
    for j = 1:8 %每个汉字需要8个特征向量即8个样本集
        sampleTraining(i,j,dataSet); %循环学习样本集
    end
end