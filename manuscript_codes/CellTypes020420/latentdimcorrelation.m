%this script analyzes the correlation between each latent dim to each other
%and combine them if neccessary
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

%% get the index of the first 40 highest std latent value for all dataset

z_texture_std = std(table2array(datamatrix_all(:,214-99:214)),1);
[z_texture_std_sorted, IndexT] = sort(z_texture_std,'descend');


z_mask_std = std(table2array(datamatrix_all(:,114-99:114)),1);
[z_mask_std_sorted, IndexM] = sort(z_mask_std,'descend');

chosenL = 40;
chosenMIdx = IndexM(1:chosenL);
chosenTIdx = IndexT(1:chosenL);

Ytitle = {};
for i = chosenMIdx
    eval(sprintf("Ytitle = [Ytitle,'m%d'];",i-1));
end

for i = chosenTIdx
    eval(sprintf("Ytitle = [Ytitle,'t%d'];",i-1));
end


% %% create a title list
% Ytitle_mask = {};
% Ytitle_texture = {};
% for i = 0:99
%         eval(sprintf("Ytitle_mask = [Ytitle_mask,'m%d'];",i));
% end
% for i = 0:99
%         eval(sprintf("Ytitle_texture = [Ytitle_texture,'t%d'];",i));
% end
%% calculate correlation matrix for mask and texture
datamatrix_mask = datamatrix_all(:,15:114);
datamatrix_texture = datamatrix_all(:,115:214);

datamatrix_mask_chosen = datamatrix_mask(:,chosenMIdx);
datamatrix_texture_chosen = datamatrix_texture(:,chosenTIdx);

R_mask = corrcoef(table2array(datamatrix_mask_chosen));
R_texture = corrcoef(table2array(datamatrix_texture_chosen));

%% get clustergram for each
cg_mask = clustergram(R_mask,'Colormap',jet,'RowLabels',Ytitle(1:40),'ColumnLabels',Ytitle(1:40));
cg_texture = clustergram(R_texture,'Colormap',jet,'RowLabels',Ytitle(41:end),'ColumnLabels',Ytitle(41:end));

%% now list the texture groups
T1 = [14,22,42,24,75,86,78,57,49,95] + 1;
T2 = [82,23,27,96,67] + 1;
T3 = [58,21,13] + 1;
T4 = [20,51,72,26,6,88,63,45,32,90,19,2,59,44,55,7,61,0,69,9,18,94] + 1;
%% calculate z score for the raw matrix
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
%% get the mean z score for each texture cluster wrt each morph group
z_matrix_T1 = Z_matrix(T1+100,:);
z_matrix_T2 = Z_matrix(T2+100,:);
z_matrix_T3 = Z_matrix(T3+100,:);
z_matrix_T4 = Z_matrix(T4+100,:);

z_mean_T1 = mean(z_matrix_T1,1);
z_mean_T2 = mean(z_matrix_T2,1);
z_mean_T3 = mean(z_matrix_T3,1);
z_mean_T4 = mean(z_matrix_T4,1);

z_mean_T = [z_mean_T1',z_mean_T2',z_mean_T3',z_mean_T4'];
heatmap(z_mean_T)
