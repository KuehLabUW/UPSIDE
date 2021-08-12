%this function turn a table into a mat file that's readabile with
%cytometry2
function matfile = bundle_mat_forcyto2(table,xumap_pos,yumap_pos)
    %find all timepoints in the table
    avail_t = unique(table.t);
   
    %create objects function based on each timepoint
    for i = 1:numel(avail_t)
        %extract subtable with each timepoint
        subtable = table(table.t == avail_t(i),:);
        %findout how many objects there are
        [rowsnum colsnum] = size(subtable);
        %make objects
        for j = 1:rowsnum
            objects(avail_t(i)).obj(j).data.umapx = table2array(subtable(j,xumap_pos));
            objects(avail_t(i)).obj(j).data.umapy = table2array(subtable(j,yumap_pos));
            objects(avail_t(i)).obj(j).dir = cellstr(subtable.dirname(j));
            objects(avail_t(i)).obj(j).trno = 1;
        end 
    end
    %keyboard
    matfile = objects;
end