% this script calculates correllation matrix between the latent variables
% and gene expression marker

clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'CombinedUMAPDirFluoClusterZ.csv';
datacolumn = 217;
text = ['%s'];
for i = 1:datacolumn
    text = [text ' %f'];
end

datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', text);

parse = 1;
if parse == 1
    trial = 2;
    %condition = 2;
    %datamatrix = datamatrix(datamatrix.trial == trial & datamatrix.condition == condition, :);
    
    datamatrix = datamatrix(datamatrix.trial == trial, :);
end
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
%% calculate std of each latent var element
z_mask_std = std(features(:,1:100),1);
[z_mask_std_sorted, IndexM] = sort(z_mask_std,'descend');
%plot(1:1:100,z_mask_std_sorted)
%figure(1)
%hold on
%scatter(1:1:100,z_mask_std_sorted)
%hold off

z_texture_std = std(features(:,101:200),1);
[z_texture_std_sorted, IndexT] = sort(z_texture_std,'descend');
%figure(2)

%plot(1:1:100,z_texture_std_sorted)
%hold on
%scatter(1:1:100,z_texture_std_sorted)
%hold off

%%
chosenL = 60;
chosenMIdx = IndexM(1:chosenL);
chosenTIdx = IndexT(1:chosenL);


%%
Xtitle = {'logCD38','logCD34','timestep'};
Ytitle = {};
for i = chosenMIdx
    eval(sprintf("Ytitle = [Ytitle,'m%d'];",i));
end

for i = chosenTIdx
    eval(sprintf("Ytitle = [Ytitle,'t%d'];",i));
end
corrMatrix = corrcoef(features);
corrFluoTime = corrMatrix([chosenMIdx,100+chosenTIdx],end-2:end);
figure(1)
h= heatmap(Xtitle,Ytitle,corrFluoTime,'Colormap',jet);
caxis([-0.5,0.5])
%sorty(h,'logCD34','descend')