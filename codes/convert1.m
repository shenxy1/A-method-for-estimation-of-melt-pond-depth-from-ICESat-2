function [x,y] = zhuanhuan(input,data_ele,data_x,ranges)

for ii = 1:length(input)
    if isnan(input(ii)) == 1
        x(ii) = NaN;
        y(ii) = NaN;
    else
        if rem(input(ii),1) == 0
            x(ii) = data_x(input(ii),ii);
            y(ii) = data_ele(input(ii),ii);
        else
            top = ceil(input(ii));
            bot = floor(input(ii));
            x(ii) = (data_x(top,ii)+data_x(bot,ii))/2;
            y(ii) = (data_ele(top,ii)+data_ele(bot,ii))/2;
        end
    end
end

[hang_ranges,~] = size(ranges);

for kk = 1:hang_ranges
    
    temp_x = x(:,ranges(kk,1):ranges(kk,2));
    temp_y = y(:,ranges(kk,1):ranges(kk,2));
    
    temp_x1 = fillmissing(temp_x,'linear');
    temp_y1 = fillmissing(temp_y,'linear');
    
    x(:,ranges(kk,1):ranges(kk,2)) = temp_x1;
    y(:,ranges(kk,1):ranges(kk,2)) = temp_y1;
    
end


end