function outputMatrix = adjustsurface(inputMatrix)

if isempty(inputMatrix)
    outputMatrix = [];
else
    
    height = zeros(2,5).*NaN;
    kk = 1;
    [~,lie] = size(inputMatrix);
    
    for ii = 1:20:200
        
        if ii ~= 181
            temp = inputMatrix(:,ii:ii+19);
        else
            temp = inputMatrix(:,ii:lie);
        end
        
        temp1 = temp;
        
        [hang1,~] = find(temp == 100);
        [hang2,~] = find(temp == 200);
        
        if isempty(mean(hang1))
            height(1,kk) = NaN;
        else
            height(1,kk) = mean(hang1);
        end
        
        if isempty(mean(hang2))
            height(2,kk) = NaN;
        else
            height(2,kk) = mean(hang2);
        end
        
        kk = kk + 1;
        
    end
    
    noNaNCols = all(~isnan(height), 1);
    columnIndices = find(noNaNCols);
    
    if isempty(columnIndices)
        outputMatrix = [];
    else
        
        bianhua = detectchange(height,columnIndices);
        bianhua(find(isnan(bianhua)==1)) = 0;
        height(find(isnan(height)==1)) = 0;
        changedColumns = any(bianhua ~= height, 1);
        changedColumnIndices = find(changedColumns);
        
        tempp = inputMatrix;
        
        for oo = 1:length(changedColumnIndices)
            
            if changedColumnIndices(oo) ~= 10
                temp = inputMatrix(:,(changedColumnIndices(oo)-1)*20+1:(changedColumnIndices(oo)-1)*20+20);
                indext1= find(temp == 100);
                temp(indext1) = 200;
                
                tempp(:,(changedColumnIndices(oo)-1)*20+1:(changedColumnIndices(oo)-1)*20+20) = temp;
            else
                temp = inputMatrix(:,(changedColumnIndices(oo)-1)*20+1:lie);
                indext1= find(temp == 100);
                temp(indext1) = 200;
                
                tempp(:,(changedColumnIndices(oo)-1)*20+1:lie) = temp;
            end
            
        end
        
        outputMatrix = tempp;
        
    end
end
end