function outputMatrix = mergesurface(inputMatrix)

height = zeros(2,5).*NaN;
num1 = zeros(2,5).*NaN;

kk = 1;
[~,lie] = size(inputMatrix);

for ii = 1:20:200
    
    if ii ~= 181
        temp = inputMatrix(:,ii:ii+19);
    else
        temp = inputMatrix(:,ii:lie);
    end
    
    [hang1,~] = find(temp == 100);
    [hang2,lie2] = find(temp == 200);
    
    if isempty(mean(hang1))
        height(1,kk) = NaN;
        num1(1,kk) = NaN;
    else
        height(1,kk) = mean(hang1);
        num1(1,kk) = length(hang1);
    end
    
    if isempty(mean(hang2))
        height(2,kk) = NaN;
        num1(2,kk) = NaN;
    else
        if length(lie2) > 2
            height(2,kk) = mean(hang2);
            num1(2,kk) = length(hang2);
        else
            height(2,kk) = NaN;
            num1(2,kk) = NaN;
            
            temp(find(temp==200)) = 0;
            if ii ~= 181
                inputMatrix(:,ii:ii+19) = temp;
            else
                inputMatrix(:,ii:lie) = temp;
            end
            
        end
    end
    
    kk = kk + 1;
    
end


noNaNCols = all(~isnan(height), 1);

columnIndices = find(noNaNCols);

if isempty(columnIndices)
    outputMatrix = [];
else
    
    if (length(columnIndices) == 1 && num1(2,columnIndices) <= 2) || sum(num1(2,:)) <= 2
        outputMatrix = [];
    else
        
        shuangceng = height(:,columnIndices);
        shuangcengnum1 = num1(2,columnIndices);
        indexnum1 = find(shuangcengnum1 <= 2);
        shuangceng(:,indexnum1) = [];
        [~,liee1] = size(shuangceng);
        
        maxlie = find(shuangceng(2,:) == max(shuangceng(2,:)));
        tempp = inputMatrix;
        
        for oo = 1:liee1
            if oo ~= maxlie
                if abs(shuangceng(2,oo) - shuangceng(1,maxlie)) <= abs(shuangceng(2,oo) - shuangceng(2,maxlie))
                    
                    if columnIndices(oo) ~= 10
                        temp = inputMatrix(:,(columnIndices(oo)-1)*20+1:(columnIndices(oo)-1)*20+20);
                        indext1= find(temp == 200);
                        temp(indext1) = 100;
                        
                        tempp(:,(columnIndices(oo)-1)*20+1:(columnIndices(oo)-1)*20+20) = temp;
                    else
                        temp = inputMatrix(:,(columnIndices(oo)-1)*20+1:lie);
                        indext1= find(temp == 200);
                        temp(indext1) = 100;
                        
                        tempp(:,(columnIndices(oo)-1)*20+1:lie) = temp;
                    end
                    
                end
                
                if abs(shuangceng(1,oo) - shuangceng(2,maxlie)) <= abs(shuangceng(1,oo) - shuangceng(1,maxlie))
                    
                    if columnIndices(oo) ~= 10
                        temp = inputMatrix(:,(columnIndices(oo)-1)*20+1:(columnIndices(oo)-1)*20+20);
                        indext2= find(temp == 100);
                        temp(indext2) = 200;
                        
                        tempp(:,(columnIndices(oo)-1)*20+1:(columnIndices(oo)-1)*20+20) = temp;
                    else
                        temp = inputMatrix(:,(columnIndices(oo)-1)*20+1:lie);
                        indext2= find(temp == 100);
                        temp(indext2) = 200;
                        
                        tempp(:,(columnIndices(oo)-1)*20+1:lie) = temp;
                    end
                    
                end
                
            end
        end
        
        outputMatrix = tempp;
        
    end
end
end