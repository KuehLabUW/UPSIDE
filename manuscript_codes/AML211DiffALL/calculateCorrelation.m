% this script plot correllation values between the latent variables
% and gene expression marker and time

clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'CombinedUMAPDirFluoClusterZ.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end

chosenL = 40;
datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
CorrFluoTimeTotal = zeros(chosenL*2,3,3);


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


%% Extract correlation matrix for each trial
for T = 1:3

datamatrix = datamatrix_all(datamatrix_all.trial == T, :);

logCD34 = log10(datamatrix.APC_corr);
logCD34(logCD34 == -Inf) = 0;

logCD38 = log10(datamatrix.PE_corr);
logCD38(logCD38 == -Inf) = 0;

features = [];
for i = 1:100
    eval(sprintf('features = [features,datamatrix.m%d];',i));
end

for i = 1:100
    eval(sprintf('features = [features,datamatrix.t%d];',i));
end

features = [features,logCD38,logCD34,datamatrix.t];

corrMatrix = corrcoef(features);
corrFluoTime = corrMatrix([chosenMIdx,100+chosenTIdx],end-2:end);

CorrFluoTimeTotal(:,:,T) = corrFluoTime;
end

%% calculate mean and std for the Correlation matrix and plot verticle bars
CorrMean = mean(CorrFluoTimeTotal,3);
CorrStd = std(CorrFluoTimeTotal,0,3);
propnames = {'CD38','CD34','time'};
for i = 1:3
    figure(i)
    hold on
    corr_m = CorrMean(:,i);
    corr_std = CorrStd(:,i);
    [corr_m_sorted, m_i] = sort(corr_m,'descend');
    corr_std_sorted = corr_std(m_i);
    Ytitle_sorted = Ytitle(m_i);
    X = categorical(Ytitle_sorted);
    X = reordercats(X,Ytitle_sorted);
    barh(X,corr_m_sorted,'FaceColor','r')
    xlabel('Correlation Coefficient')
    title(propnames{i})
    er = errorbar(corr_m_sorted,X,corr_std_sorted,corr_std_sorted,'.','horizontal','Color',[0 0 0]);
    hold off
end

%% plot heatmap pairwise of different variables
trial = 3;
figure(4)
h= heatmap({'CD38','CD34'},Ytitle,CorrFluoTimeTotal(:,[1,2],trial),'Colormap',jet);
figure(5)
h= heatmap({'CD38','time'},Ytitle,CorrFluoTimeTotal(:,[1,3],trial),'Colormap',jet);
figure(6)
h= heatmap({'CD34','time'},Ytitle,CorrFluoTimeTotal(:,[2,3],trial),'Colormap',jet);
%% get PCA of the correlations between the variables
%get the pca value for all samples;
[coeff, score, latent, tsquared, explained, mu] = pca(CorrMean);
PCA_latent_data = CorrMean*coeff(:,1:2);
datatotal = [CorrMean,PCA_latent_data];

rng(1); % For reproducibility
[idx,C] = kmeans([datatotal(:,end-1),datatotal(:,end)],3);


figure(7)
scatter(datatotal(:,end-1),datatotal(:,end),40,datatotal(:,3),'filled')
hold on
dx = 0.001; dy = 0.01; % displacement so the text does not overlay the data points
text(datatotal(:,end-1)+dx, datatotal(:,end)+dy, Ytitle,'Fontsize', 7);
caxis([-0.2,0.2])
hold off
title('time correlation')

figure(8)
scatter(datatotal(:,end-1),datatotal(:,end),40,datatotal(:,2),'filled')
hold on
dx = 0.001; dy = 0.01; % displacement so the text does not overlay the data points
text(datatotal(:,end-1)+dx, datatotal(:,end)+dy, Ytitle,'Fontsize', 7);
caxis([-0.2,0.2])
hold off
title('CD34 correlation')

figure(9)
scatter(datatotal(:,end-1),datatotal(:,end),40,datatotal(:,1),'filled')
hold on
dx = 0.001; dy = 0.01; % displacement so the text does not overlay the data points
text(datatotal(:,end-1)+dx, datatotal(:,end)+dy, Ytitle,'Fontsize', 7);
caxis([-0.2,0.2])
hold off
title('CD38 correlation')

figure(10)
scatter(datatotal(:,end-1),datatotal(:,end),40,idx,'filled')
hold on
dx = 0.001; dy = 0.01; % displacement so the text does not overlay the data points
text(datatotal(:,end-1)+dx, datatotal(:,end)+dy, Ytitle,'Fontsize', 7);
hold off
title('Kmeans cluster')
