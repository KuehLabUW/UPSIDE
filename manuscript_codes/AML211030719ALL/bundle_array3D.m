%this function turn table into a 3 element array
function array = bundle_array3D(table,props_pos,xumap_pos,yumap_pos)

xumap = table2array(table(:,xumap_pos));
yumap = table2array(table(:,yumap_pos));
property = table2array(table(:,props_pos));
%keyboard
array = [xumap,yumap,property];
end