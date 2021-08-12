%this function takes in a datamatrix of cells and time point for tracking.
%It returns a matrix with the label of the cell partner of the current cell
%at time t. There are 3 parameters:

%D_now this sets the minimum distance the cell at time t must be away from other cells to be considered 
%Dlower_next this sets the maximum boundary away from cell(t) for cell(t+1) to be considered candidate partner
%Dupper_next  this sets the minimum boundary the 2nd best partner to cell(t) has to be away for the match to be considered valid

function tracked_matrix = trackcellpairwise(submatrix,t,D_now,Dlower_next,Dupper_next)

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
    if isempty(min_dist_next)
        min_dist_next = 1000;
    end
    if isempty(min_dist)
        min_dist = 1000;
    end
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
if ~isempty(pairs)
    [~, ind] = unique(pairs(:,2), 'rows');
    % duplicate indices
    duplicate_ind = setdiff(1:size(pairs, 1), ind);
    % duplicate values
    duplicate_value = pairs(duplicate_ind, 2);
    % remove duplicated values
    pairs_good = pairs(~ismember(pairs(:,2),[unique(duplicate_value)',0]),:); %remember having to remove 0 partner as well
else
    pairs_good = [0,0];
end

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
tracked_matrix = [submatrix_now table(pcell','VariableNames', {'pcell'})];


end