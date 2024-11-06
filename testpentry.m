clear;
clc;
L(1)=Link('revolute','d',19  ,'a', 22.5,'alpha', -pi/2);
L(2)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(3)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(4)=Link('revolute','d',40 ,'a', 22.5,'alpha',-pi/2);
L(5)=Link('revolute','d',40 ,'a', 0,'alpha',0);
mod5=SerialLink(L,'name','S-dof');
%mod5.teach
%mod5.base = transl(0,0,-59); mod5.teach



y=-30;
i=-36;
j=36;
v=6;
u=-50;

% q1=jtraj([0,0,0,0,0,0],[0,-50,0,0,0,0],150);
% q1=[q1;jtraj([0,-50,0,0,0,0],[-35,-40,0,0,-0,0],100)];
% q1=[q1;jtraj([-35,-40,0,0,-0,0],[-35,-40,40,0,-0,u],100)];
% q1=[q1;jtraj([-35,-40,40,0,-0,u],[-35,-40,40,0,0,u],30)];
% q1=[q1;jtraj([-35,-40,40,0,-0,u],[-30,-40,40,0,-30,u],10)];
% q1=[q1;jtraj([-30,-40,40,0,-30,u],[-30,-40,40,0,-30,v],5)];
% q1=[q1;jtraj([-30,-40,40,0,-30,v],[0,-10,20,-10,0,v],100)];

% q1=jtraj([y-5,i,0,0,0,u],[y-5,i,j,-(j+i),y-5,u],30);
% q1=[y,i,j,-(j+i),y,v];
% 
q1=jtraj([0,0,0,0,0,0],[0,i-5,0,0,0,0],20);%提起
q1=[q1;jtraj([0,i-5,0,0,0,0],[y-5,i,0,0,0,0],20)];%平移
q1=[q1;jtraj([y-5,i,0,0,0,0],[y-5,i,0,0,0,u],10)];%开爪
q1=[q1;jtraj([y-5,i,0,0,0,u],[y-5,i,j,-(j+i),y-5,u],20)];%放下
q1=[q1;jtraj([y-5,i,j,-(j+i),y-5,u],[y,i,j,-(j+i),y,u],10)];%靠近夹块
q1=[q1;jtraj([y,i,j,-(j+i),y,u],[y,i,j,-(j+i),y,v],5)];%夹紧
C1=cos((-i-j/2)/180*pi)*cos(j/2/180*pi);
for n=0:j%竖直抬起
    theta1=(j-n)/2;
    theta2=acos(C1/cos(theta1/180*pi))*180/pi;
    qi=[y,-(theta2+theta1),2*theta1,theta2-theta1,y,v];
    q1=[q1;qi];
end
q1=[q1;jtraj(q1(end,:),[0,-10,20,-10,0,v],20)];%返回初始位置

q1=q1*pi/180;
q=q1(:,1:5);

JTA=transl(mod5.fkine(q));
max(JTA(:,3))
min(JTA(:,3))
%plot3 (p2(:,1),p2(:,2),-21*ones(length(p2),1));
% figure
% plot3 (JTA(:,2),JTA(:,1),JTA(:,3)),axis equal,zlim([-22 -20]);
% view ([0 0 1]);
figure
plot3 (JTA(:,1),JTA(:,2),JTA(:,3));
axis equal
zlim([-100 200])
view ([0 0 1]);
hold on
plot(mod5,q,'loop');axis equal;