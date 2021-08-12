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
chosenL = 40;

%% get the index of the first 40 highest std latent value for all dataset

z_texture_std = std(table2array(datamatrix_all(:,end-99:end)),1);
[z_texture_std_sorted, IndexT] = sort(z_texture_std,'descend');


z_mask_std = std(table2array(datamatrix_all(:,end-199:end-100)),1);
[z_mask_std_sorted, IndexM] = sort(z_mask_std,'descend');

chosenMIdx = IndexM(1:chosenL);
chosenTIdx = IndexT(1:chosenL);

Ytitle = {};
for i = chosenMIdx
    eval(sprintf("Ytitle = [Ytitle,'m%d'];",i));
end

for i = chosenTIdx
    eval(sprintf("Ytitle = [Ytitle,'t%d'];",i));
end


YtitleAll = {};
for i = 1:100
    eval(sprintf("YtitleAll = [YtitleAll,'m%d'];",i));
end

for i = 1:100
    eval(sprintf("YtitleAll = [YtitleAll,'t%d'];",i));
end

%% Extract correlation matrix for each trial

for T = 1:3

datamatrix = datamatrix_all(datamatrix_all.trial == T, :);



features = [];
for i = 1:100
    eval(sprintf('features = [features,datamatrix.m%d];',i));
end

for i = 1:100
    eval(sprintf('features = [features,datamatrix.t%d];',i));
end



corrMatrix = corrcoef(features);

CorrFluoTimeTotal(:,:,T) = corrMatrix;
end

%% calculate mean and std for the Correlation matrix and plot verticle bars
CorrMean = mean(CorrFluoTimeTotal,3);
CorrStd = std(CorrFluoTimeTotal,0,3);

cg = clustergram(corrMatrix,'Colormap',jet,'RowLabels',YtitleAll,'ColumnLabels',YtitleAll);

%%
subM = corrMatrix( [chosenMIdx,chosenTIdx+100],[chosenMIdx,chosenTIdx+100]);
cg = clustergram(subM,'Colormap',jet,'RowLabels',Ytitle,'ColumnLabels',Ytitle);