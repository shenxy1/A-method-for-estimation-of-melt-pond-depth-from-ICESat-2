function outputMatrix = panduanbianhua(matrix,columnIndices)

[numRows, numCols] = size(matrix);

resultMatrix = matrix;

for col = 1:numCols
    nanIndices = isnan(matrix(:, col));
    
    if sum(nanIndices) == 1
        nonNaNValues = matrix(~nanIndices, col);
        
        temp = abs(col - columnIndices);
        index = find(temp == min(temp));
        
        if abs(nonNaNValues(1) - matrix(1, columnIndices(index))) > abs(nonNaNValues(1) - matrix(2, columnIndices(index)))
            
            resultMatrix(2,col) = resultMatrix(1,col);
            
        end

    end
end


outputMatrix = resultMatrix;

end
