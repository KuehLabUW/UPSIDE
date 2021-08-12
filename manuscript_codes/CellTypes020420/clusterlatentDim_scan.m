clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/';

datadirfile = 'ClusteredTypesChosen.csv';
datacolumn = 213;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
chosenL = 50;

% for i = 1:numel(datamatrix_all)
%     if datamatrix_all.group(i) == 4
%         datamatrix_all.group(i) = 2;
%     elseif datamatrix_all.group(i) == 5
%         datamatrix_all.group(i) = 4;
%     end
%     
% end
%% get the index of the first 40 highest std latent value for all dataset

z_texture_std = std(table2array(datamatrix_all(:,214-99:214)),1);
[z_texture_std_sorted, IndexT] = sort(z_texture_std,'descend');


z_mask_std = std(table2array(datamatrix_all(:,114-99:114)),1);
[z_mask_std_sorted, IndexM] = sort(z_mask_std,'descend');

chosenMIdx = IndexM(1:chosenL);
chosenTIdx = IndexT(1:chosenL);

Ytitle = {};
for i = chosenMIdx
    eval(sprintf("Ytitle = [Ytitle,'m%d'];",i-1));
end

for i = chosenTIdx
    eval(sprintf("Ytitle = [Ytitle,'t%d'];",i-1));
end

%% calculate z score for all latent variables in terms of each cluster
Z_matrix = zeros(200,numel(unique(datamatrix_all.group)));

for i = 0:99
    for j = 1:8
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix_all.m%d);',i));
        eval(sprintf('std_z = std(datamatrix_all.m%d);',i));
        % then get the mean of the z over specific group
        submatrix = datamatrix_all(datamatrix_all.group == j-1,:);
        eval(sprintf('m_z_sub = mean(submatrix.m%d);',i));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(i+1,j) = z_score;
    end
end

for i = 0:99
    for j = 1:8
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix_all.t%d);',i));
        eval(sprintf('std_z = std(datamatrix_all.t%d);',i));
        % then get the mean of the z over specific group
        submatrix = datamatrix_all(datamatrix_all.group == j-1,:);
        eval(sprintf('m_z_sub = mean(submatrix.t%d);',i));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(101+i,j) = z_score;
    end
end

%% find the mean z score for the grouped texture
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/ClusterScan/';
ClusterNum = 39;
for c = [2,4,8,16,32]-1%1:ClusterNum
    z_mean_total = [];
    datadirfile = sprintf('Clustermemberset%d.csv',c);
    datamatrix = csvread(strcat(root_dir,datadirfile));
    for feature = 1:size(datamatrix,1)
        featureset = datamatrix(feature,:);
        featureset = featureset(featureset < 2000);
        z_matrix = Z_matrix(featureset+101,:);
        z_mean = mean(z_matrix,1);
        z_mean_total = [z_mean_total z_mean'];
        
    end
    Ytitle = {};
    for i = 1:size(datamatrix,1)
        eval(sprintf("Ytitle = [Ytitle,'T%d'];",i));
    end
    cg_texture = clustergram(z_mean_total,'Colormap',jet,'RowLabels',["0","1","2","3","4","5","6","7"],'ColumnLabels',Ytitle);
    %keyboard
end
    
