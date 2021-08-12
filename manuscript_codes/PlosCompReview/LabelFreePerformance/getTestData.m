% this script assigns a cell number to the each TIF image in the training
% dataset
clear all

og_csv = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/TrainingImageWithCellNum.csv';
og_matrix = readtable(og_csv,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', ['%s' '%s' '%f']);

train_csv = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/TrainingImageWithCellNum98000.csv';
train_matrix = readtable(train_csv,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', ['%s' '%s' '%f']);

test_matrix = og_matrix(~ismember(og_matrix,train_matrix),:);

writetable(test_matrix,'/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/test.csv');