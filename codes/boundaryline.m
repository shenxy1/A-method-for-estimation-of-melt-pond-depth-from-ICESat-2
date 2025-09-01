function [z,z_wse,sig,ranges] = boundaryline(data,eee01,thr)

test = data;
test(1:ceil(thr)+3,:)=0;
array = test;

numRows = size(array, 1);
numCols = size(array, 2);
first_nonzero_row1 = NaN(1, numCols); 

for col = 1:numCols
    rowIdx = find(array(:, col) ~= 0, 1, 'first');
    
    if ~isempty(rowIdx)
        first_nonzero_row1(col) = rowIdx;
    end
end

if all(isnan(first_nonzero_row1))
    first_nonzero_row1 = NaN;
end

eee01_copy = eee01;
eee01(find(eee01 == 100)) = 0;

array = eee01;

numRows = size(array, 1);
numCols = size(array, 2);
first_nonzero_row = NaN(1, numCols);

for col = 1:numCols
    rowIdx = find(array(:, col) == 200);
    if ~isempty(rowIdx)
        first_nonzero_row(col) = mean(rowIdx);
    end
end

if all(isnan(first_nonzero_row))
    first_nonzero_row = NaN;
end

bottom = max(first_nonzero_row);
first_nonzero_row1(find(first_nonzero_row1 >= bottom)) = NaN;

fin = [first_nonzero_row1;first_nonzero_row];
array = fin;
result = NaN(1, size(array, 2)); 

for col = 1:size(array, 2)
    col_data = array(:, col); 
    non_nan_indices = ~isnan(col_data); 
    
    if sum(non_nan_indices) == 1
        result(col) = col_data(non_nan_indices);
    elseif sum(non_nan_indices) == 2
        result(col) = col_data(2);
    end
end

x = 1:199;
y = fillmissing(result,'linear');
indexy = find(y == ceil(thr)+4);
[~,liey] = find(eee01 == 200);
indexy = [1,indexy,199];
z = y;

inRange = [];
for yy = 1:length(indexy)-1
    inRange1 = (liey >= indexy(yy)) & (liey <= indexy(yy+1));
    index_inrange = find(inRange1 == 1);
    inRange(yy) = length(index_inrange);
end

for yy = 1:length(indexy)-1
    
    if yy == 1
        
        if inRange(yy) <= 2
            z(indexy(yy):indexy(yy+1)-1) = NaN;
        end
        
    else
        
        if yy ~= length(indexy)-1
            
            if inRange(yy) <= 2
                if inRange(yy-1) <= 2
                    z(indexy(yy):indexy(yy+1)-1) = NaN;
                else
                    z(indexy(yy)+1:indexy(yy+1)-1) = NaN;
                end
            end
            
        else
            if inRange(yy) <= 2
                if inRange(yy-1) <= 2
                    z(indexy(yy):indexy(yy+1)) = NaN;
                else
                    z(indexy(yy)+1:indexy(yy+1)) = NaN;
                end
            end
            
        end
    end
    
end

z_wse = z.*NaN;
eee01_copy1 = eee01_copy;
eee01_copy(find(eee01_copy == 200)) = 0;
ranges = findConsecutiveNonNanRanges(z);
[hang_ranges,~] = size(ranges);

for kk = 1:hang_ranges
    
    temp_eee01 = eee01_copy(:,ranges(kk,1):ranges(kk,2));
    [hang_temp,lie_temp] = find(temp_eee01 == 100);
    
    lie_temp = unique(lie_temp);
    
    if ~isempty(hang_temp)
         z_wse(1,ranges(kk,1):ranges(kk,2)) = mean(hang_temp);
         sig_swe(1:2,kk) = [length(lie_temp);length(lie_temp)./(ranges(kk,2)-ranges(kk,1)+1)];
    else
         sig_swe(1:2,kk) = [NaN;NaN];
    end
     
    temp_eee01 = eee01_copy1(:,ranges(kk,1):ranges(kk,2));
    [~,index_temp_lie] = find(temp_eee01 == 200);
    index_temp_lie = unique(index_temp_lie);
    sig_mp(1:2,kk) = [length(index_temp_lie);length(index_temp_lie)./(ranges(kk,2)-ranges(kk,1)+1)];
    
    sig = [sig_mp;sig_swe];
    
end
    
end