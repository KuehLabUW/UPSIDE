% this script tracks cell pairwise over the entire dataset

clear all
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';
csvfilename = 'LIVE_position_subgate.csv';
cd(code_dir)

matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f');

% loop through the positions and track the cells in each
for p = unique(matrix.pos)'
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('working on position: '); disp(p)
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    %extract matrix with position p
    submatrix = matrix(matrix.pos == p,:);
    timespan = unique(submatrix.t)';
    %track the cells and add the result back into a dataframe
    for t = timespan(1:end-1)
        tracked_matrix = trackcellpairwise(submatrix,t,40,60,70);
        data.pos(p).time{t} = tracked_matrix;
    end    
    % don't forget to formate the last time point
    submatrix_last = submatrix(submatrix.t == timespan(end),:);
    submatrix_last = [submatrix_last table(zeros(size(submatrix_last,1),1),'VariableNames', {'pcell'})];
    data.pos(p).time{timespan(end)} = submatrix_last;
end
disp('Done!Saving ... ')
%compile everything into a csv again
table = [];
for p = unique(matrix.pos)'
    for t = unique(matrix.t)'
        %table = [table size(data.pos(p).time{t},1)];
        table = [table ; data.pos(p).time{t}];
    end
end
writetable(table,'/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/LIVE_tracked.csv')
