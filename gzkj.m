clc,clear all,close all;
L(1)=Link('revolute','d',19  ,'a', 22.5,'alpha', -pi/2);
L(2)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(3)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(4)=Link('revolute','d',40 ,'a', 22.5,'alpha',-pi/2);
L(5)=Link('revolute','d',40 ,'a', 0,'alpha',0);
mod5=SerialLink(L,'name','S-dof');

L(1).qlim=[-150,150]/180*pi;
L(2).qlim=[-90,0]/180*pi;
L(3).qlim=[0,150]/180*pi;
L(4).qlim=[0,90]/180*pi;
L(5).qlim=[-150,150]/180*pi;
 
mod5.plot([0 0 0 0 0])
hold on;
N=30000;    %随机次数

    %关节角度限制
limitmax_1 = -150.0;
limitmin_1 = 150.0;
limitmax_2 = -90.0;
limitmin_2 = 0.0;
limitmax_3 = 0.0;
limitmin_3 = 150.0;
limitmax_4 = 0.0;
limitmin_4 = 90.0;
limitmax_5 = -150.0;
limitmin_5 = 150.0;

theta1=(limitmin_1+(limitmax_1-limitmin_1)*rand(N,1))*pi/180; %关节1限制
theta2=(limitmin_2+(limitmax_2-limitmin_2)*rand(N,1))*pi/180; %关节2限制
theta3=(limitmin_3+(limitmax_3-limitmin_3)*rand(N,1))*pi/180; %关节3限制
theta4=(limitmin_4+(limitmax_4-limitmin_4)*rand(N,1))*pi/180; %关节4限制
theta5=(limitmin_5+(limitmax_5-limitmin_5)*rand(N,1))*pi/180; %关节4限制


qq=[theta1,theta2,theta3,theta4,theta4];

Mricx=mod5.fkine(qq);
X=zeros(N,1);
Y=zeros(N,1);
Z=zeros(N,1);
for n=1:1:N
    X(n)=Mricx(n).t(1);
    Y(n)=Mricx(n).t(2);
    Z(n)=Mricx(n).t(3);

end
plot3(X,Y,Z,'b.','MarkerSize',0.5);%画出落点
hold on;

