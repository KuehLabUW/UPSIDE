clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'CombinedUMAPDirFluoClusterZ.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
cluster = [];
Clusters = {[0,1,3],[2],[4,5,6],[7,8],[9]};
for i = 1:height(datamatrix_all)
    if ismember(datamatrix_all.group(i),cell2mat(Clusters(1)))
        cluster = [cluster,1];
    elseif ismember(datamatrix_all.group(i),cell2mat(Clusters(2)))
        cluster = [cluster,2];
    elseif ismember(datamatrix_all.group(i),cell2mat(Clusters(3)))
        cluster = [cluster,3];
    elseif ismember(datamatrix_all.group(i),cell2mat(Clusters(4)))
        cluster = [cluster,4];
    elseif ismember(datamatrix_all.group(i),cell2mat(Clusters(5)))
        cluster = [cluster,5];
    end
end

datamatrix_all('cluster') = cluster';
writetable(datamatrix_all,[root_dir,'CombinedUMAPDirFluoClusterZcluster.csv']);