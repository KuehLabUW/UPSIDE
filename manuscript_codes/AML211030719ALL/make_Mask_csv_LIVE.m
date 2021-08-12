clear
%%
%create a csv file of mask equivalents of the brightfield subim

code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
%BFfilename = 'AML211_ALLSubstractedDir_LIVE.csv';
%maskfilename = 'AML211_ALLSubstractedDir_LIVE_mask.csv';
BFfilename = 'test_LIVE_truncated.csv';
maskfilename = 'test_LIVE_truncated_mask.csv';

cd(code_dir)

%%read bulk csv file
matrix_BF = readtable(strcat(root_dir,BFfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');
matrix_mask = matrix_BF;
for i = 1:numel(matrix_mask)
    oldname = char(matrix_mask.dirname(i));
    newname = strcat(oldname(1:end-4),'_mask.TIF');
    matrix_mask.dirname(i) = cellstr(newname);
    disp(i)
end
writetable(matrix_mask,strcat(root_dir,maskfilename))