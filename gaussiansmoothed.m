types = 30;
numCell = 18;
for f = 1:types
    file = int2str(f-1);
    s1 = 'ApPmf';
    s2 = '.csv';
    filename = strcat(s1,file,s2);
    A = importdata(filename ,',');
    smoothed = zeros(2,256);
    for i = 1:numCell
        B = A(i,:);
        kernel = fspecial('gaussian',[3 3],1);
        smoothed(i,:) = imfilter(B, kernel, 'same');
        s = sum(smoothed(i,:),2);
        if(s ~= 0)
            smoothed(i,:) = smoothed(i,:)/s;
        end
    end
     s3 = 'tran';
    filename1 = strcat(s3,file,s2);
    dlmwrite(filename1,smoothed);
end
    
