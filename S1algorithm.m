sourceFolderPath3 = ' your files ';
txtFiles_raw = dir(fullfile(sourceFolderPath3, '*.txt'));

our_data = [];
confidence = [];

for kk = 1:length(txtFiles_raw)
    
    try
        
        fileName_raw = txtFiles_raw(kk).name;
        filePaths2 = fullfile(sourceFolderPath3, fileName_raw);
        %%
       
        opts2 = detectImportOptions(char(filePaths2));
        opts2.SelectedVariableNames = opts2.VariableNames([5, 4]);
        rawphoton = readtable(char(filePaths2), opts2);
        a = rawphoton(9:end,:);
        a.Var4 = cellfun(@str2double, a.Var4);
        a = table2array(a);
        rawphoton = a;
        
        if ~isempty(rawphoton)
            
            stepp = 100;
            maxdist = max(rawphoton(:,1));
            mindist = min(rawphoton(:,1));
            edges1 = mindist:stepp:maxdist;
            
            for jj = 1:length(edges1)-1
                
                index = find(rawphoton(:,1) >= edges1(jj) & rawphoton(:,1) < edges1(jj+1));                              
                aaa = rawphoton(index,:);
                
                if isempty(aaa)
                    disp('no melt pond found!');
                    continue;
                end
                
                h = histogram(aaa(:,2), 'BinWidth', 0.1);
                
                counts = h.Values;
                edges = h.BinEdges;
                close;
                
                [~, maxIdx] = max(counts);
                aaa1 = aaa(:,2);
                mostConcentratedNumber = mode(aaa1(aaa1 >= edges(maxIdx) & aaa1 < edges(maxIdx+1)));
                
                index0 = find(aaa(:,2) >= mostConcentratedNumber-6 & aaa(:,2) <= mostConcentratedNumber+6);
                bbb = aaa(index0,:);
                
                i = 1;
                j = 1;
                data = [];
                data_ele = [];
                data_x = [];
                
                for hang = mostConcentratedNumber+6 : -0.1 : mostConcentratedNumber-6
                    for lie = bbb(1,1) : 0.5 : bbb(end,1)
                        index1 = find(bbb(:,2)>=hang-0.1 & bbb(:,2)<hang);
                        index2 = find(bbb(:,1)>=lie & bbb(:,1)<lie+0.5);
                        index3 = intersect(index1,index2);
                        data(i,j) = length(index3);
                        data_ele(i,j) = mean(bbb(index3,2));
                        data_x(i,j) = mean(bbb(index3,1));
                        j = j+1;
                    end
                    j = 1;
                    i = i+1;
                end
                
                indexxx = find(data < 2);
                data1 = data;
                data1(indexxx) = 0;
                
                aaa01 = filtersingle(data1);
                if all(aaa01(:) == 0)
                    disp('no melt pond found!');
                    continue;
                end
                
                bbb01 = findsurface(aaa01);
                if all(bbb01(:) == 0)
                    disp('no melt pond found!');
                    continue;
                end
                
                ccc01 = mergesurface(bbb01);
                if all(ccc01(:) == 0)
                    disp('no melt pond found!');
                    continue;
                end
                
                ddd01 = adjustsurface(ccc01);
                if all(ddd01(:) == 0)
                    disp('no melt pond found!');
                    continue;
                end
                
                %%
                if ~isempty(ddd01)
                    
                    [eee01,thr] = adjustsurface1(ddd01);
                    [z,z_wse,sig,ranges] = boundaryline(data,eee01,thr);
                    [x_mp,y_mp] = convert1(z,data_ele,data_x,ranges);
                    [x_wse,y_wse] = convert1(z_wse,data_ele,data_x,ranges);
                    confidence = [confidence;sig(2,end)];
                    y_mp = y_mp .* (y_wse./y_wse);
                    depth = y_mp - y_wse;
                    
                    [hhang1, llie1] = size(y_mp);
                    iindex1 = (zeros(hhang1, llie1)+1)*jj;
                    y_wse = nanmean(y_wse)*(zeros(hhang1, llie1)+1);
                    our_data = [our_data;iindex1',x_mp',y_wse',y_mp'];
                    disp('melt pond is found!');
                    
                    figure(1)
                    scatter(bbb(:,1),bbb(:,2),'.')
                    hold on
                    plot(x_wse,y_wse,'k','LineWidth', 2)
                    hold on
                    plot(x_mp,y_mp,'k','LineWidth', 2)
                else
                    disp('no melt pond found!');
                    continue;
                end
            end
        end
        
    catch
        continue;
    end
    
end
