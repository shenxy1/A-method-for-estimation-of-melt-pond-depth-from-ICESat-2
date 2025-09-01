function outputMatrix = filterDandu(inputMatrix)
    [rows, cols] = size(inputMatrix);
    
    outputMatrix = inputMatrix;
    
    for i = 1:rows
        for j = 1:cols
            if inputMatrix(i, j) == 0
                continue;
            end
            
            allZeros = true;
            for m = -1:1
                for n = -1:1
                    if m == 0 && n == 0
                        continue;
                    end
                    
                    neighborRow = i + m;
                    neighborCol = j + n;
                    
                    if neighborRow > 0 && neighborRow <= rows && ...
                       neighborCol > 0 && neighborCol <= cols
                        if inputMatrix(neighborRow, neighborCol) ~= 0
                            allZeros = false;
                            break;
                        end
                    end
                end
                if ~allZeros
                    break;
                end
            end
            
            if allZeros
                outputMatrix(i, j) = 0;
            end
        end
    end
end
