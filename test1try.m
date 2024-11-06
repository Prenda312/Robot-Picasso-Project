L(1)=Link('revolute','d',19  ,'a', 22.5,'alpha', -pi/2);
L(2)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(3)=Link('revolute','d',0 ,'a', 97.5,'alpha', 0);
L(4)=Link('revolute','d',40 ,'a', 22.5,'alpha',-pi/2);
L(5)=Link('revolute','d',40 ,'a', 0,'alpha',0);
mod5=SerialLink(L,'name','S-dof');
%mod5.base = transl(0,0,-59); mod5.teach

load test1
load test1map
load testlength

q1=zeros(length(q),5);
q1(:,1)=-q(:,1);
q1(:,2)=-q(:,2);
q1(:,3)= q(:,3);
q1(:,4)=q(:,4);
q1(:,5)=-q(:,1);

m=1;
axes(h10);
for i=1:length(keylength)    
    plot3 (p2(m:m+keylength(i)-1,1),-p2(m:m+keylength(i)-1,2),-21*ones(keylength(i),1)),hold on
    m=m+keylength(i);
end
% view ([0 0 1]);
axis equal
zlim([-100 150]),xlim([-20,300]),ylim([-200,200])
view ([0 0 1]);
hold on
axes(h10);
plot(mod5,q1,'loop');axis equal;
% JTA=transl(mod5.fkine(q1));
% figure
% plot3 (JTA(:,1),JTA(:,2),JTA(:,3)),axis equal,zlim([-22 -20]);
% view ([0 0 1]);

% 
% plot3 (JTA(:,1),JTA(:,2),JTA(:,3)),hold on,zlim([-22 -20])
