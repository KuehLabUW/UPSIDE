%this code split the large 'ALL Dir' csv files into smaller, more
%manageable chunks
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
filename = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/AML211_ALLLargeMaskSubstractedWatershedDir.csv';
matrix = readtable(filename,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %f %s %f %f %f %f %f');
submatrix_1 = matrix(1:1e6,:);
submatrix_2 = matrix(1e6+1:2e6,:);
submatrix_3 = matrix(2e6+1:3e6,:);
submatrix_4 = matrix(3e6+1:end,:);


%keyboard
writetable(submatrix_1,strcat(root_dir,'AML211_ALLLargeMaskSubstractedWatershedDir_p1.csv'));
writetable(submatrix_2,strcat(root_dir,'AML211_ALLLargeMaskSubstractedWatershedDir_p2.csv'));
writetable(submatrix_3,strcat(root_dir,'AML211_ALLLargeMaskSubstractedWatershedDir_p3.csv'));
writetable(submatrix_4,strcat(root_dir,'AML211_ALLLargeMaskSubstractedWatershedDir_p4.csv'));