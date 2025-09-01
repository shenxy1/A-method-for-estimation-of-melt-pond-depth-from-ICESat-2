function [outputMatrix,wse] = watersurface(inputMatrix)

outputMatrix = [];
wse = [];
[~,lie] = size(inputMatrix);
numRows = size(inputMatrix, 1);

for ii = 1:20:200
    
    if ii ~= 181
        temp = inputMatrix(:,ii:ii+19);
    else
        temp = inputMatrix(:,ii:lie);
    end
    
    [~,lie_wse] = size(temp);
    [hang1,~] = find(temp == 100);
    
    if isempty(hang1)
        outputMatrix = [outputMatrix,temp];
        wse = [wse,zeros(1,lie_wse).*NaN];
    else
    
    thr =  median(hang1);    
    rowsToModify = (1:numRows > thr+3);
    valuesToModify = (temp == 100);
    temp(rowsToModify, :) = temp(rowsToModify, :) .* ~valuesToModify(rowsToModify, :) + 200 * valuesToModify(rowsToModify, :);
                
    rowsToModify = (1:numRows <= thr+3);
    valuesToModify = (temp == 200);
    temp(rowsToModify, :) = temp(rowsToModify, :) .* ~valuesToModify(rowsToModify, :) + 100 * valuesToModify(rowsToModify, :);
    
    outputMatrix = [outputMatrix,temp];
    wse = [wse,zeros(1,lie_wse) + thr];
    
    end
    
end
end