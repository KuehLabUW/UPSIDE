% this script tracks cell pairwise over the entire dataset

clear all

% enter the code directory
code_dir =  '/media/phnguyen/Data2/Imaging/UPSIDEv1/code/pairwise_linking';
% enter the directory of the csv file containing cell information
root_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/csvs';
% enter the csv file name
csvfilename = 'LIVE_position_subgate.csv';
cd(code_dir)

% enter the number of data fields
datacolumn = 211;


% enter the parameters for tracking algorithm:

%D_now this sets the minimum distance the cell at time t must be away from 
%other cells to be considered 
%Dlower_next this sets the maximum boundary away from cell(t) for cell(t+1)
%to be considered candidate partner
%Dupper_next  this sets the minimum boundary the 2nd best partner to cell(t)
%has to be away for the match to be considered valid

D_now = 40;
Dlower_next = 60;
Dupper_next = 70;

%output file name
outfile = 'Live_tracked.csv';

%% main script

Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end

matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


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
        tracked_matrix = trackcellpairwise(submatrix,t,D_now,Dlower_next,Dupper_next);
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

writetable(table,strcat(root_dir,outfile))
