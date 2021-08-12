%this function counts how many cells there are as a function of a given
%field

function [T, c] = getcellnum_vs_time(matrix,time_pos)
T = [];
c = [];
raw_time = table2array(matrix(:,time_pos));
unique_time = unique(raw_time);
for time = 1:numel(unique_time)
    correct = (raw_time == unique_time(time));
    cell_num = sum(correct(:) == 1);
    T =[T unique_time(time)];
    c = [c cell_num];
end     
end