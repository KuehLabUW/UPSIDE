% this script assigns a cell number to the each TIF image in the training
% dataset
clear all
og_csv = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/TrainingImageWithCellNum.csv';
og_matrix = readtable(og_csv,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', ['%s' '%s' '%f']);

% extract only the first timepoint
% og_matrix1 = og_matrix(1:300,:);
% og_matrix2 = og_matrix(301:end,:);
% 
% og_matrix1 = og_matrix1(1:10:end,:);
% og_matrix2 = og_matrix2(1:5:end,:);
% og_matrix = [og_matrix1;og_matrix2];
max_row = height(og_matrix);

%keyboard



split_size = 2000:24000:120000;
chosen_id = [];
current_size = 0;
for size = split_size
    
    filled = 0;
    while filled == 0
        %randomly pick a well position
        idx = randi([1,max_row],1);
        if ~ismember(idx,chosen_id)
            chosen_id = [chosen_id idx];
            current_size = current_size + og_matrix.cellnum(idx);
        end
        
        if current_size > size
            filled = 1;
        end
    end
    matrix = og_matrix(chosen_id,:);
    writetable(matrix,sprintf('/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/TrainingImageWithCellNum%d.csv',size));
    disp('done with size')
    disp(size)
end