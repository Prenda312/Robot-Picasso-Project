% clear axes(h2)
IMG = im2gray(imread('choosen.jpg')); % transfer to grayscalce pic
% figure; 
% imshow(IMG);            

IMG = im2bw(IMG,0.5);
% IMG=~IMG;
% figure;
% imshow(IMG);
IMG = bwmorph(IMG,'thin');
if(IMG(1,1)==0&&IMG(2,2)==1)||(IMG(1,1)==1&&IMG(2,2)==0)
    IMG = IMG(2:(end-1),2:(end-1));
end
IMG = bwmorph(IMG,'spur',2);
% figure;
% imshow(IMG);

% IMG = IMG - imerode(IMG,[0 1 0 ; 1 1 1 ; 0 1 0]);
IMG=bwmorph(IMG,'remove');
if(IMG(1,1)==0&&IMG(2,2)==1)||(IMG(1,1)==1&&IMG(2,2)==0)
    IMG = IMG(2:(end-1),2:(end-1));
end
% IMG=bwmorph(IMG,'thin');
% IMG=bwmorph(IMG,'clean');
% figure;
% imshow(IMG);

IMG=fliplr(IMG);
IMG=imrotate(IMG,180);
IMG1=IMG;
IMG0=zeros(size(IMG));
l=100;
pathlength=[0];
path=[0,0];
i=0;

while (l>19)
    i=i+1;
    [C0,C1,IMG1]=contour_get3(IMG1);
    %path=[path;C0(1,:);C0;C0(end,:)];
    path=[path;C0];
    [l,~]=size(C0);
    %sum(sum(C1))
    pathlength(i,1)=l;
%     figure
% plot(path(:,1),path(:,2)),axis equal
%     figure
%     IMG0=C1+IMG0;
%     imshow(IMG0)
    
%    IMG1=linedelete(IMG1,C1);
%     figure
%     imshow(IMG1)
    
%     IMG1=bwmorph(IMG1,'thin');
%     IMG1=bwmorph(IMG1,'clean');
    %IMG1 = bwmorph(IMG1,'spur',5);
%     figure;
%     imshow(IMG1);
end

path=path(2:(end-1),:);
pathlength=pathlength(1:(end-1));
% figure
% plot(path(:,1),path(:,2)),axis equal

len=sum(pathlength);

%路径光滑，关键点提取，（照搬老师的代码）
m=1;
trajectory=zeros(len,4);
keypath=[0,0,0];
keypath_=[0,0];
keylength=zeros(size(pathlength));
% figure

if(len>1000)
for i=1:size(pathlength)
    xx=smooth(path(m:(m+pathlength(i)-1),1));
    yy=smooth(path(m:(m+pathlength(i)-1),2));
    zz=zeros(size(xx,1),1);
    if(len>1000)
        [T,N,B,k,t0] = frenet(xx,yy,zz);

        temp_xx = [xx; xx];
        temp_xx = temp_xx(2: length(xx)+1) - xx;
        temp_yy = [yy; yy];
        temp_yy = temp_yy(2: length(yy)+1) - yy;
        temp_d = (temp_xx.^2 + temp_yy.^2).^0.5; % distance between two points.
        temp_d(length(xx))=temp_d(length(xx)-1); % temp_s(length(xx))=0 originally
        temp_k = [k; k];
        temp_k = (temp_k(2: length(k)+1) + k)/2;
        temp_r = 1./temp_k; % radius
        temp_s= 2*asin(temp_d/2 ./ temp_r).*temp_r;
        % vel = 1./temp_d(1:length(xx)); % temp_s not good, similar as temp_d...
        % vel = smooth(vel) % try smooth, bad result
        rel_t = [0; temp_s];
        rel_t = rel_t(1: length(xx));  % test temp_s, temp_d
        %===============================

        % ============== output the data ==========================================
        % rel_t = mean(vel)./vel; % relative time
        abs_t = zeros(size(rel_t));
        for j = 1:size(rel_t)
            abs_t(j,1) = sum(rel_t(1:j)); % absolute time, sum of the first n terms
        end
        norm_t = abs_t./abs_t(size(rel_t,1)); % normalize to 1
        % [xx,yy] is the piont in the planar workspace
        % norm_t is the time axis normalized to 1


        trajectory(m:(m+pathlength(i)-1),:)=[xx, yy, norm_t,k];


        m=m+pathlength(i);



        tt =norm_t*20;

        x=0;
        y=0;
        t=0;
        tik = 1; % counter
        n = length(k); % number of points on the path loaded from "Profiler"
        num = 1; % sequence number for the picked points
        % define the first point
        x(num,1) = xx(1);
        y(num,1) = yy(1);
        t(num,1) = tt(1);
        % -------
        num = num + 1;
        for j = 2 : n
            if k(j) > 0.1*max(k)       % case 1: curve is complicated
                tik = tik - 500/n;     % pick more points
            else if k(j) > 0.01*max(k) % case 2: curve is medium complicated
                    tik = tik - 100/n; % pick medium points
            else                   % case 3: curve is simple and flat
                tik = tik - 50/n;  % pick fewer points
            end
            end
            if tik <= 0                % pick points when tik <= 0
                x(num,1) = xx(j);
                y(num,1) = yy(j);
                t(num,1) = tt(j);
                num = num + 1;
                tik = 1;               % reset tik
            end
        end

        keypath1=[x,y,t];
        keypath=[keypath;keypath1];
        keylength(i)=num-1;
        axes(h8);
        plot(y,x),hold on,axis equal

    end
end
keypath=keypath(2:end,:);
end
if(len<1000&&len>500)
for i=1:size(pathlength)
    xx=smooth(path(m:(m+pathlength(i)-1),1));

    yy=smooth(path(m:(m+pathlength(i)-1),2));

    keypath2=[xx,yy];
    keypath_=[keypath_;keypath2];
    m=m+pathlength(i);
    axes(h8);
    plot(yy,xx);hold on,axis equal
end

keypath=keypath_(2:end,:);
keylength=pathlength;
end

if(len<500)
for i=1:size(pathlength)
    xx=(path(m:(m+pathlength(i)-1),1));

    yy=(path(m:(m+pathlength(i)-1),2));

    keypath2=[xx,yy];
    keypath_=[keypath_;keypath2];
    m=m+pathlength(i);
    axes(h8);
    plot(yy,xx);hold on,axis equal
end

keypath=keypath_(2:end,:);
keylength=pathlength;
end


%缩放路径坐标至实际位置，确保不会超出工作空间
a=22.5;%机械臂长度1
l=97.5;%机械臂长度2
h=40;%机械臂长度3
[m,n]=size(IMG);
syms v
eqn= (v*m+2*a+2*l*cos(pi*71.5/180))^2+(v*n/2)^2-(a+2*l)^2==0;
u=solve(eqn,v);
u=double(max(u));

%u=0.8*(2*l)^2/sqrt(m^2/4+n^2)^2*(1-cos(pi*5/12))
p2=keypath;%实际尺寸图像，单位mm
p2(:,2)=p2(:,2)-n/2;
p2=p2*u;
p2(:,2)=p2(:,2);%-10;
p2(:,1)=p2(:,1)+2*l*cos(pi*71.5/180)+2*a;
% figure
% plot(p2(:,2),p2(:,1))
r=1;
qi=zeros(sum(keylength),4);

%工作空间转关节空间
for j=1:length(keylength)
    p1=p2(r:r+keylength(j)-1,:);
    for i=1:length(p1)
        x=p1(i,2);
        y=p1(i,1);
        L0=sqrt(x^2+y^2);
        thetha1=atan(y/x);
        thetha2=asin(h/L0);
        L1=L0*cos(thetha2)-a;
        qi(i+r-1,1)=pi/2-mod(thetha1-thetha2,pi);
        qi(i+r-1,2)=abs(acos((L1-a)/l/2));
        qi(i+r-1,3)=2*qi(i+r-1,2);
        qi(i+r-1,4)=-qi(i+r-1,2);
        %q5=-q1;
    end
    r=r+keylength(j);
end

 max(qi(:,3))/pi*180;
%添加提笔，下笔动作
v1=[0 pi/8 0 pi/8];
q=jtraj([0 pi/8 0 pi/8],qi(1,:)+v1,80);
q_=jtraj(qi(1,:)+v1,qi(1,:),30);
q=[q;q_;qi(1:keylength(1),:)];
j=1+keylength(1);
for i=2:length(keylength)
    lastpost=qi(j-1,:);
    nextpost=qi(j,:);
    qa=jtraj(lastpost,lastpost+v1,30);
    qb=jtraj(lastpost+v1,nextpost+v1,20);
    qc=jtraj(nextpost+v1,nextpost,50);
    q=[q;qa;qb;qc;qi(j:j+keylength(i)-1,:)];
    j=j+keylength(i);
end
qlast=jtraj(qi(end,:),qi(end,:)+v1,30);
qlast=[qlast;jtraj(qi(end,:)+v1,[0 pi/8 0 pi/8],80)];
q=[q;qlast];

time=length(q);
real=zeros(time,3);
for i=1:time
    q1=q(i,1);
    q2=q(i,2);
    q3=q(i,3);
    real(i,1)=(2*a+l*cos(q2)+l*cos(q3-q2))*sin(q1)-h*cos(q1);
    real(i,2)=(2*a+l*cos(q2)+l*cos(q3-q2))*cos(q1)+h*sin(q1);
    real(i,3)=l*sin(q2)-l*sin(q3-q2);
end
% 
% figure
% plot3(real(:,1),real(:,2),real(:,3)),axis equal,zlim([-1,0]),view([0 0 1])

save('test1.mat','q');
save('test1map.mat','p2')
save('testlength',"keylength")
