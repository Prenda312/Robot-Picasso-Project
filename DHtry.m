clear;
clc;
% L(1)=Link('revolute','d',59 ,'a', 0,'alpha',0 ,'modified');
% L(2)=Link('revolute','d',0  ,'a', 22.5,'alpha', pi/2,'modified');
% L(3)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0,'modified');
% L(4)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0,'modified');
% L(5)=Link('revolute','d',-40 ,'a', 22.5,'alpha',-pi/2,'modified');
%L(6)=Link('revolute','d',59 ,'a', 0,'alpha',pi/2 ,'modified');
%L(7)=Link('revolute','d',59 ,'a', 0,'alpha', 0,'modified');

L(1)=Link('revolute','d',19  ,'a', 22.5,'alpha', -pi/2);
L(2)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(3)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(4)=Link('revolute','d',40 ,'a', 22.5,'alpha',-pi/2);
L(5)=Link('revolute','d',40 ,'a', 0,'alpha',0);
mod5=SerialLink(L,'name','S-dof');
%mod5.base = transl(0,0,-59);
mod5.teach

load mao
load maomap


q1=zeros(length(q),5);
q1(:,1)=-q(:,1);
q1(:,2)=-q(:,2);
q1(:,3)= q(:,3);
q1(:,4)=q(:,4);
q1(:,5)=-q(:,1);
max(q1(:,1))
min(q1(:,1))

JTA=transl(mod5.fkine(q1));

%plot3 (p2(:,1),p2(:,2),-21*ones(length(p2),1));
plot3 (JTA(:,1),JTA(:,2),JTA(:,3));
axis equal
zlim([-100 200])
view ([0 0 1]);
hold on
plot(mod5,q1,'loop');axis equal;

