root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
filename = strcat(root_dir,'AML211_ALLLargeMaskSubstractedDir_p3.csv');
matrix = readtable(filename,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %f %s %f %f %f %f %f');

for i = 1:numel(matrix)
    if isfile(string(matrix.dirname(i)))
        display(i)
    else
        display(string(matrix.dirname(i)))
        keyboard
    end
end
