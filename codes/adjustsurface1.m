function [outputMatrix,thr] = adjustsurface1(inputMatrix)

[~,lie] = size(inputMatrix);
[hang1,~] = find(inputMatrix == 100);
thr =  median(hang1);

outputMatrix = inputMatrix;
numRows = size(outputMatrix, 1);



rowsToModify = (1:numRows <= thr+3);
valuesToModify = (outputMatrix == 200);
outputMatrix(rowsToModify, :) = outputMatrix(rowsToModify, :) .* ~valuesToModify(rowsToModify, :) + 100 * valuesToModify(rowsToModify, :);
    
end