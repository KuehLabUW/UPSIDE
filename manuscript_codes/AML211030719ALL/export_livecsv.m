%this function takes in info of live cells and make csv list of dir files
%that are in the live gate
function export_livecsv(objects,TotalInfo,csvname)

dirname = [];

for d = 1:numel(TotalInfo) 
    info = TotalInfo(d);
    tifname = string(objects(info.t).obj(info.cell).dir);
    dirname = [dirname;tifname];
    %keyboard
end

dirname = cellstr(dirname);
T = table(dirname);
writetable(T,csvname);
end
