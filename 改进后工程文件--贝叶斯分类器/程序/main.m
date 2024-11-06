%形成用户界面
clear all;
%添加图形窗口
H=figure('Color',[0.85 0.85 0.85],...
    'position',[400 300 500 400],...
    'Name','汉字识别',...
    'NumberTitle','off',...
    'MenuBar','none');
%画坐标轴对象，显示原始图像
h0=axes('position',[0.1 0.6 0.3 0.3]);
%添加图像打开按钮
h1=uicontrol(H,'Style','push',...
    'Position',[40 100 80 60],...
    'String','文字识别',...
    'FontSize',10,...
    'Call','op');
%画坐标轴对象，显示经过预处理之后的图像
h2=axes('position',[0.5 0.6 0.3 0.3]);
%添加预处理按钮
h3=uicontrol(H,'Style','push',...
    'Position',[140 100 80 60],...
    'String','图像处理',...
    'FontSize',10,...
    'Call','mao');
%添加训练神经网络按钮
h6=uicontrol(H,'Style','push',...
    'Position',[240 100 80 60],...
    'String','网络训练',...
    'FontSize',10,...
    'Call','tryy');
%添加识别按钮
h4=uicontrol(H,'Style','push',...
    'Position',[340 100 80 60],...
    'String','汉字识别',...
    'FontSize',10,...
    'Call','recognize');
%添加显示识别结果的文本框
