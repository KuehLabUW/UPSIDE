% this script assigns a cell number to the each TIF image in the training
% dataset
clear all
og_csv = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/LiveDeadValidated.csv';
og_matrix = readtable(og_csv,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', ['%s' '%f' '%f' '%f' '%f' '%f' '%f']);

%find out how many misclassified live cells
live_matrix = og_matrix(og_matrix.live> og_matrix.dead,:);

true_live = live_matrix(live_matrix.DEAD == 0,:);
true_dead = og_matrix(og_matrix.DEAD == 1,:);
disp('fraction of true positive:')
disp(height(true_live)/height(live_matrix))
%keyboard
%create 3 csvs, each with 0 , 85, 301 dead cells
% first sample true live cells matrices
matrix_0 = true_live(randperm(height(true_live)),:);
matrix_7 = matrix_0(1:1117,:);
matrix_25 = matrix_0(1:901,:);

% then include the dead cells
matrix_75 = true_dead(randperm(height(true_dead),301),:);
matrix_93 = matrix_75(1:85,:);

%combine both
matrix100 = matrix_0;
matrix93 = [matrix_93;matrix_7];
matrix75 = [matrix_75;matrix_25];

%save
writetable(matrix100,'/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/LiveDead100.csv');
writetable(matrix93,'/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/LiveDead93.csv');
writetable(matrix75,'/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/LiveDead75.csv');

