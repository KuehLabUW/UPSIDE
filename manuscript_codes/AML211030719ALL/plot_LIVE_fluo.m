%This script plots all the live cell number from UM and nonUM data
clear

%% extract drug and UM matrices
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
umapfilename = 'CombinedSubstractedDirUMAP_mixgaus_largeLIVEFLUO.csv';

cd(code_dir)

matrix = readtable(strcat(root_dir,umapfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
matrix_nondrug = matrix(matrix.treated == 0, :);
matrix_drug = matrix(matrix.treated == 1, :);

matrix_nondrug_nonUM = matrix_nondrug(matrix_nondrug.pos <= 16,:);
matrix_nondrug_UM = matrix_nondrug(matrix_nondrug.pos > 16,:);

matrix_drug_nonUM = matrix_drug(matrix_drug.pos <= 16,:);
matrix_drug_UM = matrix_drug(matrix_drug.pos > 16,:);

%% plot
figure(1)
scatter(matrix_nondrug_nonUM.x_umap,matrix_nondrug_nonUM.y_umap,1,matrix_nondrug_nonUM.t)
xlabel('xumap')
ylabel('yumap')

figure(2)
scatter(matrix_nondrug_UM.x_umap,matrix_nondrug_UM.y_umap,1,matrix_nondrug_UM.t)
xlabel('xumap')
ylabel('yumap')

figure(3)
scatter(matrix_drug_nonUM.x_umap,matrix_drug_nonUM.y_umap,1,matrix_drug_nonUM.t)
xlabel('xumap')
ylabel('yumap')

figure(4)
scatter(matrix_drug_UM.x_umap,matrix_drug_UM.y_umap,1,matrix_drug_UM.t)
xlabel('xumap')
ylabel('yumap')

figure(5)
scatter(matrix_nondrug_nonUM.x_umap,matrix_nondrug_nonUM.y_umap,1,matrix_nondrug_nonUM.APC_corr)
xlabel('xumap')
ylabel('yumap')

figure(6)
scatter(matrix_drug_nonUM.x_umap,matrix_drug_nonUM.y_umap,1,matrix_drug_nonUM.APC_corr)
xlabel('xumap')
ylabel('yumap')

figure(7)
scatter(matrix_nondrug_UM.x_umap,matrix_nondrug_UM.y_umap,1,matrix_nondrug_UM.APC_corr)
xlabel('xumap')
ylabel('yumap')

figure(8)
scatter(matrix_drug_UM.x_umap,matrix_drug_UM.y_umap,1,matrix_drug_UM.APC_corr)
xlabel('xumap')
ylabel('yumap')



