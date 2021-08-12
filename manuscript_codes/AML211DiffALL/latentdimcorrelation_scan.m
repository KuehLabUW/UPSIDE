clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
datadirfile = 'Dataset1CompleteAreaEdgeFluoCluster.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


cd(code_dir)
%% get the index of the first 40 highest std latent value for all dataset
chosenL = 40;
z_texture_std = std(table2array(datamatrix(:,113:113+99)),1);
[z_texture_std_sorted, IndexT] = sort(z_texture_std,'descend');


z_mask_std = std(table2array(datamatrix(:,13:13+99)),1);
[z_mask_std_sorted, IndexM] = sort(z_mask_std,'descend');

chosenMIdx = IndexM(1:chosenL);
chosenTIdx = IndexT(1:chosenL);

Ytitle = {};
for i = chosenMIdx
    eval(sprintf("Ytitle = [Ytitle,'m%d'];",i-1));
end

for i = chosenTIdx
    eval(sprintf("Ytitle = [Ytitle,'t%d'];",i-1));
end

%% calculate correlation matrix for mask and texture
datamatrix_mask = datamatrix(:,13:112);
datamatrix_texture = datamatrix(:,113:212);

datamatrix_mask_chosen = datamatrix_mask(:,chosenMIdx);
datamatrix_texture_chosen = datamatrix_texture(:,chosenTIdx);

R_mask = corrcoef(table2array(datamatrix_mask_chosen));
R_texture = corrcoef(table2array(datamatrix_texture_chosen));

%% get clustergram for each
%cg_mask = clustergram(R_mask,'Colormap',jet,'RowLabels',Ytitle(1:40),'ColumnLabels',Ytitle(1:40));
cg_texture = clustergram(R_texture,'Colormap',jet,'RowLabels',Ytitle(41:end),'ColumnLabels',Ytitle(41:end));
%% do cluster dendrogram
Ytitle_texture = Ytitle(41:end);
tree = linkage(R_texture,'average');
Cluster = struct();
count = 0;
for c = 2:40
    count = count +1;
   [H,T,outperm] = dendrogram(tree,c);
   Cluster(count).clusternum = c;
   % loop through each cluster members and save data
   for g =1:c
       featurelist = Ytitle_texture(T == g);
       Cluster(count).group(g).clustermember = featurelist;
   end
   
end

%%
save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/mat/ClusterScan.mat','Cluster')