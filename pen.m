clear;
clc;
L(1)=Link('revolute','d',19  ,'a', 22.5,'alpha', -pi/2);
L(2)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(3)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(4)=Link('revolute','d',40 ,'a', 22.5,'alpha',-pi/2);
L(5)=Link('revolute','d',40 ,'a', 0,'alpha',0);

mod5=SerialLink(L,'name','S-dof');
%mod5.teach

q1=jtraj([0,0,0,0,0],[35,-40,0,40,35],100);
q1=[q1;jtraj([35,-40,0,40,35],[35,-40,40,0,35],100)];
q1=[q1;jtraj([35,-40,40,0,35],[30,-40,40,0,30],30)];
q1=q1*pi/180;
% 
% L(1).qlim = [-150 150]/360*2*pi();
%  L(2).qlim = [-130 1]/360*2*pi();
% L(3).qlim = [-1 135]/360*2*pi();
% L(4).qlim = [-100 1]/360*2*pi();
% L(5).qlim = [-150 150]/360*2*pi();
% L(6).qlim = [-150 150]/360*2*pi();

% R =[1 0 0;
%     0 0 1;
%     0 -1 0];
% 
% % define the origin of the image (painting plate) relative to the origin of
% % the work space
% %p0 = [0.15  0.5  0.1]';
% p2=jtraj([0,150,0],[0,150,-25],100);
% x=p2(:,1);
% y=p2(:,2);
% z=p2(:,3);
% 
% %p0 = [0 15 5]'; 
% 
% %block = 0.4; % set up the drawing region (size of the drawing (m))
% %mm = max(max(x),max(y)); %find out the longest edge
% for i = 1:100
%     p1(i,:) = [x(i) y(i) z(i)];
%     % scale up/down from the original image
%     T1(:,:,i)= [R p1(i,:)';
%             0 0 0 1];
%     % get the transformation matrix for the pen tip
% end
% 
% for temp_560 = 1: 80
%     %q1(temp_560,:)=ikine560(p560, T1(:,:,temp_560),'u');
%     q1(temp_560,:)=mod5.ikine(T1(:,:,temp_560),'u');
% end
% 
JTA=transl(mod5.fkine(q1));
% 
% %plot3 (p2(:,1),p2(:,2),-21*ones(length(p2),1));
plot3 (JTA(:,1),JTA(:,2),JTA(:,3));
axis equal
zlim([-100 200])
view ([0 0 1]);
hold on
plot(mod5,q1,'loop');axis equal;

u=-55;
v=6;
q1=jtraj([0,0,0,0,0,0],[35,-40,0,40,35,u],100);
q1=[q1;jtraj([35,-40,0,40,35,u],[35,-40,40,0,35,u],100)];
q1=[q1;jtraj([35,-40,40,0,35,u],[30,-40,40,0,30,u],30)];
q1=[q1;jtraj([35,-40,40,0,35,u],[30,-40,40,0,30,v],10)];
q1=q1*pi/180;
q=zeros(length(q1)+20,6);
q(1:length(q1),-55*ones)

save('mao.mat','q');
