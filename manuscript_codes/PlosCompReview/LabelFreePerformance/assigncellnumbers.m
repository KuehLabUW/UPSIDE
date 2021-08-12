% this script assigns a cell number to the each TIF image in the training
% dataset
clear all
og_csv = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/TrainingImageList.csv';
og_matrix = readtable(og_csv,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', ['%s' '%s']);

og_matrix = og_matrix(~ismember(1:1830,[12:11:332]-1),:);

%keyboard
pos_num1 = 30;
pos_num2 = 300;
t_num1 = 10;
t_num2 = 5;
seg_dir2 = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/K1P2C2trainCellTrace - processed/pos %d';
seg_dir1 = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/CellTypeTrain112319 - processed/pos %d';
%keyboard

cell_num = [];

%first dataset

for pos = 1:pos_num1
    cd(sprintf(seg_dir1,pos+50))
    load('segment.mat')

    for t = 1:t_num1
        cell_num = [cell_num numel(objects(t).obj)];
    end
end


%second dataset
for pos = 1:pos_num2
    cd(sprintf(seg_dir2,pos))
    load('segment.mat')

    for t = 1:t_num2
        cell_num = [cell_num numel(objects(t).obj)];
    end
end

og_matrix.cellnum = cell_num';

writetable(og_matrix,'/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/TrainingImageWithCellNum.csv');
