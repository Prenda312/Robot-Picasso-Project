function [word,result]=getword(ii)
word=[];flag=0;y1=8;y2=0.5;a=0;
while flag==0
    [m,n]=size(ii);
    wide=0;
    while a==0
        if sum(ii(:,wide+1))~=0 && wide<=n-2%wide+1列加和约为0，
        wide=wide+1;
        if wide+2>n
            break
        end
    elseif sum(ii(:,wide+2))~=0 && wide<=n-3
        wide=wide+1;
        elseif sum(ii(:,wide+3))~=0 && wide<=n-4
                wide=wide+1;
        elseif sum(ii(:,wide+4))~=0 && wide<=n-5
                wide=wide+1;
        else
            break;
        end
    end
    temp=charslice(imcrop(ii,[1 1 wide m]));
    [m1,n1]=size(temp);
    if wide<y1 && n1/m1>y2
        ii(:,1:wide)=0;
        if sum(sum(ii))~=0 
            ii=charslice(ii);  % 切割出最小范围
        else word=[];flag=1;
        end
    else
        word=charslice(imcrop(ii,[1 1 wide m]));
        ii(:,1:wide)=0;
        if sum(sum(ii))~=0;
            ii=charslice(ii);
            flag=1;
        else ii=[];
        end
    end
end
result=ii;



