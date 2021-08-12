clear

%this script calculates prediction accuracy to AAE to predict 4 quardrant
%of CSC
%expression 
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
csvfilename = 'SemiAML211_umap_CSC_testresult.csv';

%read file
cd(code_dir)
matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f');

%calculate overall accuracy
overall_result = sum(matrix.cat_real == matrix.cat_z);
percent_correct = (overall_result/height(matrix))*100;

%calculate accuracy of each category

%OFFOFF
matrix_OFFOFF = matrix(matrix.cat_real==1,:);
Accuracy_OFFOFF = (sum(matrix_OFFOFF.cat_real == matrix_OFFOFF.cat_z)/height(matrix_OFFOFF))*100;
%ONOFF
matrix_ONOFF = matrix(matrix.cat_real==2,:);
Accuracy_ONOFF = (sum(matrix_ONOFF.cat_real == matrix_ONOFF.cat_z)/height(matrix_ONOFF))*100;
%OFFOFF
matrix_ONOFF = matrix(matrix.cat_real==2,:);
Accuracy_ONOFF = (sum(matrix_ONOFF.cat_real == matrix_ONOFF.cat_z)/height(matrix_ONOFF))*100;