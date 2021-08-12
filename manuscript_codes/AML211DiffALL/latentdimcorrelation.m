clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
datadirfile = 'Dataset1CompleteAreaEdgeFluoCluster.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


cd(code_dir)
%% get the index of the first 40 highest std latent value for all dataset
chosenL = 40;
z_texture_std = std(table2array(datamatrix(:,113:113+99)),1);
[z_texture_std_sorted, IndexT] = sort(z_texture_std,'descend');


z_mask_std = std(table2array(datamatrix(:,13:13+99)),1);
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

%% calculate correlation matrix for mask and texture
datamatrix_mask = datamatrix(:,13:112);
datamatrix_texture = datamatrix(:,113:212);

datamatrix_mask_chosen = datamatrix_mask(:,chosenMIdx);
datamatrix_texture_chosen = datamatrix_texture(:,chosenTIdx);

R_mask = corrcoef(table2array(datamatrix_mask_chosen));
R_texture = corrcoef(table2array(datamatrix_texture_chosen));

%% get clustergram for each
cg_mask = clustergram(R_mask,'Colormap',jet,'RowLabels',Ytitle(1:40),'ColumnLabels',Ytitle(1:40));
cg_texture = clustergram(R_texture,'Colormap',jet,'RowLabels',Ytitle(41:end),'ColumnLabels',Ytitle(41:end));

%% now list the texture groups
T1 = [58,49,68,65,29,6,99,47,17,78,75,40,22,66,74,13,26,79,51,28,94,64,60,35,33] + 1;
T2 = [81,53,21,77,24,61] + 1;
T3 = [4,54,48,93,45,0,63,82,9] + 1;

%% calculate z score for the raw matrix
Z_matrix = zeros(200,numel(unique(datamatrix.cluster)));

for i = 0:99
    for j = 1:8
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix.m%d);',i));
        eval(sprintf('std_z = std(datamatrix.m%d);',i));
        % then get the mean of the z over specific group
        submatrix = datamatrix(datamatrix.cluster == j-1,:);
        eval(sprintf('m_z_sub = mean(submatrix.m%d);',i));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(i+1,j) = z_score;
    end
end

for i = 0:99
    for j = 1:8
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix.t%d);',i));
        eval(sprintf('std_z = std(datamatrix.t%d);',i));
        % then get the mean of the z over specific group
        submatrix = datamatrix(datamatrix.cluster == j-1,:);
        eval(sprintf('m_z_sub = mean(submatrix.t%d);',i));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(101+i,j) = z_score;
    end
end
%% get the mean z score for each texture cluster wrt each morph group
z_matrix_T1 = Z_matrix(T1+100,:);
z_matrix_T2 = Z_matrix(T2+100,:);
z_matrix_T3 = Z_matrix(T3+100,:);

z_mean_T1 = mean(z_matrix_T1,1);
z_mean_T2 = mean(z_matrix_T2,1);
z_mean_T3 = mean(z_matrix_T3,1);





z_mean_T = [z_mean_T1',z_mean_T2',z_mean_T3'];
imagesc(z_mean_T)
