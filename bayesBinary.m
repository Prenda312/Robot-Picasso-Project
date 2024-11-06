function y = bayesBinary(sample)
%���ڸ���ͳ�Ƶı�Ҷ˹������
%sampleΪҪʶ���ͼƬ������(1��100�еĸ���)
clc;    %����
load templet pattern;   %���غ�������
sum = 0;                %��ʼ��sum
prior = [];             %�������
p = [];                 %���������
likelihood = [];        %����������
pwx = [];               %��Ҷ˹����
%%�����������
for i=1:12
    sum = sum+pattern(i).num; %��������
end
for i=1:12
    prior(i) = pattern(i).num/sum;  %����ÿ�����ֵĿ�����(�������)
end
%%��������������
for i=1:12   %12������
    for j=1:100 %100��ģ��
        sum = 0;
        for k=1:pattern(i).num %������
            if(pattern(i).feature(j,k)>0.05)  %���ʴ�����ֵ0.05������+1
                sum = sum+1;
            end 
        end
        p(j,i) = (sum+1)/(pattern(i).num+2);%������ʹ���ֵ��Pj(��i)��ע��������˹ƽ������
    end
end
for i=1:12
    sum = 1;
    for j=1:100
        if(sample(j)>0.05)
            sum = sum*p(j,i);%�������ͼƬ��ǰ���ʴ���0.05��Ϊ����ֵΪ1��ֱ�ӳ�Pj(��i)
        else
            sum = sum*(1-p(j,i));%�������ͼƬ��ǰ����С��0.05��Ϊ����ֵΪ0����(1-Pj(��i))
        end
    end
    likelihood(i) = sum;  %�����������ʸ�ֵ��likelihood
end
%%����������
sum = 0;
for i=1:12
    sum = sum+prior(i)*likelihood(i);  %��ͼ���P(X)
end
for i=1:12
    pwx(i) = prior(i)*likelihood(i)/sum;  %��Ҷ˹��ʽ
end
[maxval maxpos] = max(pwx);   %�������ֵ��������λ��
y=maxpos;                     %��������±꼴���ֵ����

