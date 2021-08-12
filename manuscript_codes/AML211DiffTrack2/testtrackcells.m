%this script tracks cells in pairwise timepoints
clear all
BF_dir = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/DifferentiationTrack/EXPTrial%d_w1Camera BF_s%d_t%d.TIF';
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';
mat_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/mat/';
csvfilename = 'CombinedDir_LIVE_position_no_z.csv';
cd(code_dir)

matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f');

position = 5;

submatrix = matrix(matrix.pos == position,:);

t = 1000;

%% set tracking parameters
D_now = 40; % this sets the minimum distance the cell at time t must be away from other cells to be considered 
Dlower_next = 60%50; %this sets the maximum boundary away from cell(t) for cell(t+1) to be considered candidate partner
Dupper_next = 70; %this sets the minimum boundary the 2nd best partner to cell(t) has to be away for the match to be considered valid
%checkboundary(1,1,1,BF_dir,D_now,Dlower_next,Dupper_next)
%% perform assignment algorithm

% step 1: get the distance matrix of t and t+1
submatrix_now = submatrix(submatrix.t == t,:);
submatrix_next = submatrix(submatrix.t == t+1,:);
Dist_matrix_next = pdist2([submatrix_now.Xcenter,submatrix_now.Ycenter],[submatrix_next.Xcenter,submatrix_next.Ycenter]);
Dist_matrix_now = squareform(pdist([submatrix_now.Xcenter,submatrix_now.Ycenter]));

% step 2: choose the indices of cells at current time point that satisfy D_now
chosen_ind = [];
for i = 1:size(Dist_matrix_now,1)
    row = Dist_matrix_now(i,:);
    row = row(row ~= 0);
    if min(row) > D_now
        chosen_ind = [chosen_ind i];
    end
end

%step 3: loop through the chosen cells and assign partner according to
%Dlower and Dupper
partner_ind = [];
for i = chosen_ind
    row = Dist_matrix_next(i,:);
    %find the closest cell distance
    min_dist = min(row);
    %find the next closet cell distance
    min_dist_next = min(row(row ~= min_dist));
    %check their requirements
    if (min_dist < Dlower_next) && (min_dist_next > Dupper_next)
        idx  = find(row == min_dist);
        partner_ind = [partner_ind idx(1)];
    else
        partner_ind = [partner_ind 0];
    end
end

%step 4: sanity check and remove all pairs that have a common partner
pairs = [chosen_ind',partner_ind'];
[~, ind] = unique(pairs(:,2), 'rows');
% duplicate indices
duplicate_ind = setdiff(1:size(pairs, 1), ind);
% duplicate values
duplicate_value = pairs(duplicate_ind, 2);
% remove duplicated values
pairs_good = pairs(pairs(:,2) ~= unique(duplicate_value),:);

%% Add the partner cell number back into submatrix
pcell = [];
for i = 1:size(submatrix_now,1)
    if ismember(i,pairs_good(:,1))
        idx_next = find(pairs_good(:,1) == i);
        pcell = [pcell submatrix_next.cell(pairs_good(idx_next,2))];
    else
        pcell = [pcell 0];
    end
end
submatrix_now_tracked = [submatrix_now table(pcell','VariableNames', {'pcell'})];
submatrix_last = [submatrix_next table(zeros(size(submatrix_next,1),1),'VariableNames', {'pcell'})];
submatrix_track = [submatrix_now_tracked;submatrix_last];
%% Run manual track checking routine
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack'
checktrack(BF_dir,submatrix_track,mat_dir,code_dir)