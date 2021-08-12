clear all

csv = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/CombinedUMAPDirCluster100.csv';
matrix = readtable(csv,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', ['%f' '%s' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f']);

group = 3;

%submatrix = matrix(matrix.group_new == group,:);
submatrix = matrix(matrix.group== group,:);
cell = randi(height(submatrix));

name = submatrix.dirname(cell);
im = imread(char(name));
imtool(im,[0.5,1.5])