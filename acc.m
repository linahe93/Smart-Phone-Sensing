len1 = length(accx);
for i=1:len
    a(i) = sqrt(accx(i)^2 + accy(i)^2 + accz(i)^2);
end
a = a';
subplot(3,2,1);
plot(a);
title('Acceleration of Staic State');
xlabel('numbers');
ylabel('Acceleration');

%set windows size
winSize = 10;
a = a(5:5794);
len2 = length(a);
n = len2/winSize;

%Mean  
mean = zeros(n:1);
for i = 1:n
    k = 1+(i-1)*winSize;
    for j = 1:winSize
        sum1 = a(k) +a(k + j -1);
    end
    mean(i) = sum1/winSize;
end
mean = mean';
subplot(3,2,2);
plot(mean);
title('Mean');
xlabel('Numbers');
ylabel('Mean Acceleration');

%Max Min  
%Variance  
var = zeros(n:1);
for i = 1:n
    k = 1+(i-1)*winSize;
    for j = 1:winSize
         sum2 = (a(k + j -1) - mean(i))^2;
    end
    var(i) = sum2/winSize;
end
var = var';
subplot(3,2,3);
plot(var);
title('Variance');
xlabel('Numbers');
ylabel('Variance of Acceleration');

%Fourier transforms  

%Autocorrelation  



    

