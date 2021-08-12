clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/ClusterScan/';

ClusterNum = 39;
for c = 1:ClusterNum
    
    datadirfile = sprintf('datamatrixGroupT%d.csv',c);
    datacolumn = 13+c+1;
    Text = ['%s'];
    for i = 1:datacolumn
        Text = [Text ' %f'];
    end
    
    
    datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
    
    
    
    
    %% calculate z score for all latent variables in terms of each cluster
    Z_matrix = zeros(c+1,numel(unique(datamatrix_all.group)));
    
    for i = 1:c+1
        for j = 1:8
            % first get the mean and std of z over all population
            eval(sprintf('m_z = mean(datamatrix_all.T%d);',i));
            eval(sprintf('std_z = std(datamatrix_all.T%d);',i));
            % then get the mean of the z over specific group
            submatrix = datamatrix_all(datamatrix_all.group == j-1,:);
            eval(sprintf('m_z_sub = mean(submatrix.T%d);',i));
            % calculate z_score and add to matrix
            z_score = (m_z_sub-m_z)/std_z;
            Z_matrix(i,j) = z_score;
        end
    end
    
   
    %% cluster the z score data using clustergram
    all_latent = 1;
    
    if all_latent == 1
        YtitleAll = {};
        z_matrix = Z_matrix;
        
        for i = 1:c+1
            eval(sprintf("YtitleAll = [YtitleAll,'T%d'];",i));
        end
        
        cg = clustergram(z_matrix,'Colormap',jet,'RowLabels',YtitleAll,'ColumnLabels',["0","1","2","3","4","5","6","7"]);
        
    elseif all_latent == 0
        z_matrix = Z_matrix;
        z_matrix = z_matrix([chosenMIdx,chosenTIdx+100],:);
        cg = clustergram(z_matrix,'Colormap',jet,'RowLabels',Ytitle,'ColumnLabels',["0","1","2","3","4","5","6","7"]);
    end

    
end


