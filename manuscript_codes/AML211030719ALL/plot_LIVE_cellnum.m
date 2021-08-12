%This script plots all the live cell number from UM and nonUM data
clear

%% extract drug and UM matrices
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
umapfilename = 'test_LIVE_truncated.csv';

cd(code_dir)

matrix = readtable(strcat(root_dir,umapfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');

matrix_nondrug = matrix(matrix.treated == 0, :);
matrix_drug = matrix(matrix.treated == 1, :);

matrix_nondrug_nonUM = matrix_nondrug(matrix_nondrug.pos <= 16,:);
matrix_nondrug_UM = matrix_nondrug(matrix_nondrug.pos > 16,:);

matrix_drug_nonUM = matrix_drug(matrix_drug.pos <= 16,:);
matrix_drug_UM = matrix_drug(matrix_drug.pos > 16,:);

%% plot data nonUm

[raw_time,cell_num] = getcellnum_vs_time(matrix_nondrug_nonUM,7);
[raw_timedrug,cell_numdrug] = getcellnum_vs_time(matrix_drug_nonUM,7);

raw_time_total = [raw_time raw_timedrug];
cell_num_total = [cell_num cell_numdrug];

figure(1)
yy = smooth(cell_num_total,5);
plot(1:1:numel(raw_time_total),yy)
hold on
plot(89.*ones(1,500),1:1:500)
%ylim([100,500])
xlim([1,numel(yy)-2])
%hold off

%% plot data Um

[raw_time,cell_num] = getcellnum_vs_time(matrix_nondrug_UM,7);
[raw_timedrug,cell_numdrug] = getcellnum_vs_time(matrix_drug_UM,7);

raw_time_total = [raw_time raw_timedrug];
cell_num_total = [cell_num cell_numdrug];

%figure(2)
yy = smooth(cell_num_total,5);
plot(1:1:numel(raw_time_total),yy)
hold on
plot(89.*ones(1,800),1:1:800)
%ylim([100,500])
xlim([1,numel(yy)-2])
hold off
