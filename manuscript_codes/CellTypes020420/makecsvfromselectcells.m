clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/';
mat_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/mat/';
csvfilename = 'CombinedDirType.csv';

cd(code_dir)


matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f');

cd(mat_dir)
typelist = [1,2,3];
T = table();
for i = 1: numel(typelist)
    for j = 1:2
        matname = sprintf('ChosenINDtype%dtrial%d.mat',typelist(i),j);
        submatrix = matrix(matrix.trial == j &  matrix.type == typelist(i),:);
        load(matname);
        chosenmatrix = submatrix(INDEX,:);
        T = [T;chosenmatrix];
    end
end
cd(root_dir)
writetable(T,'CombinedDirTypeChosen.csv')