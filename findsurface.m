function outputMatrix = findsurface(inputMatrix)

outputMatrix = [];
[~,lie] = size(inputMatrix);

for ii = 1:20:200
    
    if ii ~= 181
        temp = inputMatrix(:,ii:ii+19);
    else
        temp = inputMatrix(:,ii:lie);
    end
    
    temp1 = temp;
    [hang,~] = find(temp ~= 0);
    indexx = find(temp ~= 0);
    
    if isempty(indexx) || length(indexx)==1
        temp1(find(temp1~=0)) = temp1(find(temp1~=0))./temp1(find(temp1~=0)).*100;
    end
    
    if length(indexx) > 1
        
        idx1 = kmeans(hang,2) ;
        
        index1 = find(idx1 == 1);
        index2 = find(idx1 == 2);
        
        if abs(min(hang(index1)) - max(hang(index2))) < 2 || abs(max(hang(index1)) - min(hang(index2))) < 2
            
            temp1(indexx) = 100;
            
        else
            
            if mean(hang(index1)) <= mean(hang(index2))
                temp1(indexx(index1)) = 100;
                temp1(indexx(index2)) = 200;
            else
                temp1(indexx(index1)) = 200;
                temp1(indexx(index2)) = 100;
            end
            
        end
        
        outputMatrix = [outputMatrix,temp1];
        
    else
        outputMatrix = [outputMatrix,temp1];
    end
    
end
end