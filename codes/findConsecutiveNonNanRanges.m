function ranges = findConsecutiveNonNanRanges(data)

    if ~isvector(data)
        error('Input must be a one-dimensional array.');
    end
    
    isValid = ~isnan(data);
    
    ranges = [];
    
    i = 1;
    while i <= length(isValid)
        if isValid(i)
            startIdx = i;
            
            while i <= length(isValid) && isValid(i)
                i = i + 1;
            end
            
            endIdx = i - 1;
            
            ranges = [ranges; startIdx, endIdx];
        else
            i = i + 1;
        end
    end
end
