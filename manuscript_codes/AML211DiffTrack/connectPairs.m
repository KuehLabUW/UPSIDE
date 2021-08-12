function T = connectPairs(submatrix,t,cell)

T =[cell];
for i = t:max(submatrix.t)-1
    %find the cellnext value
    M = submatrix(submatrix.t == i,:);
    idx = M.cell == cell;
    cellnext = M.pcell(idx);
    
    %find out whether cellnext is there in t + 1
    N = submatrix(submatrix.t == i + 1,:);
    flag = 0;
    %keyboard
    for c = 1:size(N,1)
        
        if N.cell(c) == cellnext
            % if found, add to T structure
            T = [T cellnext];
            flag = 1;
            break
        end 
    end
    % if not, stop the search and return T
    if flag == 0
        break
    end
    cell = cellnext;
end
    










end