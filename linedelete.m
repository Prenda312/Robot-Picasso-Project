function BW1 = linedelete (BW,C)
[m,n]=size(C);
BW1=BW;
for i=1:m
    for j=1:n
        if BW(i,j)==1 && C(i,j)==1
            BW1(i,j)=0;
        end
    end
end

