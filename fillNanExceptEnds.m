function result = fillNanExceptEnds(data)
    if ~isvector(data)
        error('Input must be a one-dimensional array.');
    end
    
    firstValidIdx = find(~isnan(data), 1, 'first');
    lastValidIdx = find(~isnan(data), 1, 'last');
    
    if isempty(firstValidIdx) || isempty(lastValidIdx)
        result = data;
        return;
    end
    
    middleData = data(firstValidIdx:lastValidIdx);
    
    notNaNIdx = find(~isnan(middleData));
    nanIdx = find(isnan(middleData));
    
    if ~isempty(nanIdx)
        middleData = interp1(notNaNIdx, middleData(notNaNIdx), 1:numel(middleData), 'linear', 'extrap');
    end
    
    result = data;
    result(firstValidIdx:lastValidIdx) = middleData;
end