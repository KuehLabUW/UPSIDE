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

%% only choose the highest variable in latent dim
Ytitle_mask = Ytitle(1:50);
Ytitle_texture = Ytitle(51:100);
Z_matrix_mask = Z_matrix(chosenMIdx,:);
Z_matrix_texture = Z_matrix(chosenTIdx+100,:);
%% for each group, display a list of texture and mask features with the highest z score
for g = 1:8
    z_mask_list = Z_matrix_mask(:,g);
    [z_mask_list_sorted, idxM] = sort(z_mask_list,'descend');
    best_z_mask_list = Ytitle_mask(idxM(1:5));
    disp(z_mask_list(idxM(1:5)))
    fprintf('best mask list for group %d: \n',g);
    disp(best_z_mask_list)
    
%     z_texture_list = Z_matrix_texture(:,g);
%     [z_texture_list_sorted, idxT] = sort(z_texture_list,'descend');
%     best_z_texture_list = Ytitle_texture(idxT(1:5));
%     disp(z_texture_list(idxT(1:5)))
%     fprintf('best texture list for group %d: \n',g);
%     disp(best_z_texture_list)
    
   
end