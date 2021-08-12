%this function shows pictures of one cells and its tracked partner and
%allow you to validate
function [CORRECT,TINDEX] = checktrack(BF_dir,submatrix_track,mat_dir,code_dir)
cd(mat_dir)
%get the cells that are tracked
tracked_matrix = submatrix_track(submatrix_track.pcell ~= 0,:);

try
    load('CORRECT.mat')
    load('TINDEX.mat')
    load('CINDEX.mat')
catch
    disp('No previous data. Making new data...')
    CORRECT = [];
    TINDEX = [];
    chosen_idx = [];
end

cd(code_dir)
while numel(chosen_idx) ~= size(tracked_matrix,1)
    
    %randomly draw a pair of tracked cell and its partner from this matrix
    picked_idx = randi([1,size(tracked_matrix,1)]);
    
    if ismember(picked_idx,chosen_idx) == 0 % proceed if it's a new idx
        %find location of the cell
        Xnow = tracked_matrix.Xcenter(picked_idx);
        Ynow = tracked_matrix.Ycenter(picked_idx);
        tnow = tracked_matrix.t(picked_idx);
        posnow = tracked_matrix.pos(picked_idx);
        cellnow = tracked_matrix.cell(picked_idx);
        idxnow = find(submatrix_track.pos ==  posnow & submatrix_track.t ==  tnow & submatrix_track.cell ==  cellnow);

        %find location of its partner
        cellnext = tracked_matrix.pcell(picked_idx);
        idxnext = find(submatrix_track.pos ==  posnow & submatrix_track.t ==  tnow+1 & submatrix_track.cell ==  cellnext);
        Xnext = submatrix_track.Xcenter(idxnext);
        Ynext = submatrix_track.Ycenter(idxnext);

        %get picture at time t and draw circle around the cell
        im_now = imadjust(imread(sprintf(BF_dir,1,posnow,tnow)));
        im_now_labeled = circle(im_now,Ynow,Xnow,40);

        %get picture at time t and draw circle around the cell
        im_next = imadjust(imread(sprintf(BF_dir,1,posnow,tnow+1)));
        im_next_labeled = circle(im_next,Ynext,Xnext,40);
    
        %fuse them together
        im = imfuse(im_now_labeled,im_next_labeled,'falsecolor');
        imtool(im)
        %keyboard
        %Ask for manual validation
        correct = input('Correct track? : ');
        
        % add to the data
        if isempty(correct)
            disp('SKIP!')
        elseif    correct == 1 || correct == 2 
            CORRECT = [CORRECT correct];
            TINDEX = [TINDEX idxnow];
        else
            disp('SKIP!')
        end
        %update chosen idx bin
        chosen_idx = [chosen_idx picked_idx]; 
        
        % save data every 100 entries
        if rem(numel(TINDEX),100) == 0
            save([mat_dir 'CORRECT.mat'],'CORRECT')
            save([mat_dir 'TINDEX.mat'],'TINDEX')
            save([mat_dir 'CINDEX.mat'],'chosen_idx')
            disp('saving..')
            disp(numel(TINDEX))
            imtool close all
        end
    end
end




end