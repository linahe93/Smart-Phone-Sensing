%set windows size
winSize = 10;

len1 = length(accx_static);
a_static = zeros(len1,1);
%get static acc 
for i=1:len1
    a_static(i) = sqrt(accx_static(i)^2 + accy_static(i)^2 + accz_static(i)^2);
end
a_static = a_static';

a_static = a_static(5:5794);
len2 = length(a_static);
num_static = len2/winSize;

%Mean  
mean_static = zeros(num_static,1);
for i = 1:num_static
    sum1 = 0;
    m = 1+(i-1)*winSize;
    for j = m:i*winSize
        sum1 = sum1 + a_static(j);
    end
    mean_static(i) = sum1/winSize;
end
mean_static = mean_static';

%Max Min  
%Variance  
var_static = zeros(num_static,1);
for i = 1:num_static
    sum2 = 0;
    m = 1+(i-1)*winSize;
    for j = m:i*winSize
         sum2 = sum2 + (a_static(j) - mean_static(i))^2;
    end
    var_static(i) = sum2/winSize;
end
var_static = var_static';

mean_1 = zeros(num_static,1);
var_1 = zeros(num_static,1);
max_mean = max(mean_static);
min_mean = min(mean_static);
max_var = max(var_static);
min_var = min(var_static);
for i = 1:num_static
mean_1(i) =(mean_static(i)-min_mean)/(max_mean-min_mean);
var_1(i) =(var_static(i)-min_var)/(max_var-min_var);
end

scatter(mean_1,var_1,'k.');
hold on

%get sample
start = 1000;
snum= 50;
sample = a_static(start+1:snum+start);
k = sqrt(snum);
k = floor(k);
if(mod(k,2) == 0)
   k = k+1;
end

%Sample Mean  
smean = zeros(snum/winSize,1);
for i = 1:snum/winSize
    s_sum1 = 0;
    m = 1+(i-1)*winSize;
    for j = m:i*winSize
        s_sum1 = s_sum1 + sample(j);
    end
    smean(i) = s_sum1/winSize;
end
smean = smean';

%Max Min  
%Variance  
%mean_s = mean(sample)
svar = zeros(snum/winSize,1);
for i = 1:snum/winSize
    s_sum2 = 0;
    m = 1+(i-1)*winSize;
    for j = m:i*winSize
         s_sum2 = s_sum2 + (sample(j) - mean_static(i))^2;
    end
    svar(i) = s_sum2/winSize;
end
svar = svar';

smean_1 = zeros(snum/winSize,1);
svar_1 = zeros(snum/winSize,1);
smax_mean = max(smean);
smin_mean = min(smean);
smax_var = max(svar);
smin_var = min(svar);
for i = 1:snum/winSize
smean_1(i) =(smean(i)-smin_mean)/(smax_mean-smin_mean);
svar_1(i) =(svar(i)-smin_var)/(smax_var-smin_var);
end

scatter(smean_1,svar_1,'r*');
hold on

dis_static = zeros(num_static,snum/winSize);
for i = 1:num_static
    for j = 1:snum/winSize
        dis_static(i,j) = sqrt((var_1(i)-svar_1(j))^2 + (mean_1(i)-smean_1(j))^2);
    end
end
dis_static = sort(dis_static);

k_static = dis_static(1:k,1:snum/winSize);

% Dynamic states
len3 = length(accx_dym);
a_dym = zeros(len3,1);
%get dym acc 
for i=1:len3
    a_dym(i) = sqrt(accx_dym(i)^2 + accy_dym(i)^2 + accz_dym(i)^2);
end
a_dym = a_dym';

a_dym = a_dym(5:5794);
len4 = length(a_dym);
num_dym = len4/winSize;

%Mean  
mean_dym = zeros(num_dym,1);
for i = 1:num_dym
    sum3 = 0;
    m = 1+(i-1)*winSize;
    for j = m:i*winSize
        sum3 = sum3 +a_dym(j);
    end
    mean_dym(i) = sum3/winSize;
end
mean_dym = mean_dym';

%Max Min  
%Variance  
var_dym = zeros(num_dym,1);
for i = 1:num_dym
    sum4 = 0;
    m = 1+(i-1)*winSize;
    for j = m:i*winSize
         sum4 = sum4+(a_dym(j) - mean_dym(i))^2;
    end
    var_dym(i) = sum4/winSize;
end
var_dym = var_dym';

mean_2 = zeros(num_dym,1);
var_2 = zeros(num_dym,1);
dmax_mean = max(mean_dym);
dmin_mean = min(mean_dym);
dmax_var = max(var_dym);
dmin_var = min(var_dym);
for i = 1:num_dym
mean_2(i) =(mean_dym(i)-dmin_mean)/(dmax_mean-dmin_mean);
var_2(i) =(var_dym(i)-dmin_var)/(dmax_var-dmin_var);
end

scatter(mean_2,var_2,'+');

dis_dym = zeros(num_dym,snum/winSize);
for i = 1:num_dym
    for j = 1:snum/winSize
        dis_dym(i,j) = sqrt((var_2(i)-svar_1(j))^2 + (mean_2(i)-smean_1(j))^2);
    end
end
dis_dym = sort(dis_dym);

k_dym = dis_dym(1:k,1:snum/winSize);

static = zeros(snum/winSize,1);
dym = zeros(snum/winSize,1); 

for i = 1:snum/winSize
    for j = 1:k
        if(k_static(j,i) < k_dym(j,i))
        static(i) = static(i) + 1;
        end
        if(k_static(j,i) > k_dym(j,i))
        dym(i) = dym(i) + 1;
        end
    end
end

action = cell(1,snum/winSize); 
for i = 1:snum/winSize
    if(static(i)>dym(i))
        action(i) = {'static'};
    end
    if(static(i)<dym(i))
        action(i) = {'dynamic'};
    end
end
        


       