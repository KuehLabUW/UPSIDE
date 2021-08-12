clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211Total/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';

datadirfile1 = 'Dataset1Complete.csv';
datadirfile2 = 'Dataset2Complete.csv';
datadirfile3 = 'Dataset3Complete.csv';

datacolumn = 208;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix_all1 = readtable(strcat(root_dir,datadirfile1),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
datamatrix_all2 = readtable(strcat(root_dir,datadirfile2),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
datamatrix_all3 = readtable(strcat(root_dir,datadirfile3),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


datamatrix_all = [datamatrix_all1;datamatrix_all2;datamatrix_all3];

chosenL = 40;
%%
figure(1)
% g0c = [42 214 197]./255;
% g1c = [0 0 0]./255;
% g2c = [70 0 207]./255;
% g3c = [167 217 104]./255;
% g4c = [129 131 186]./255;
% g5c = [167 100 104]./255;%%
% g6c = [222 83 63]./255;
% g7c = [42 214 10]./255;%%
% g8c = [0 137 164]./255;%%
% g9c = [220 81 149]./255;
% g10c = [96 163 83]./255;
% g11c = [96 163 183]./255;

%gscatter(datamatrix_all.xumap,datamatrix_all.yumap,datamatrix_all.group,[g0c;g1c;g2c;g3c;g4c;g5c;g6c;g7c;g8c;g9c;g10c;g11c],[],8)
gscatter(datamatrix_all.xumap,datamatrix_all.yumap,datamatrix_all.group)
%% get the index of the first 40 highest std latent value for all dataset

z_texture_std = std(table2array(datamatrix_all(:,end-99:end)),1);
[z_texture_std_sorted, IndexT] = sort(z_texture_std,'descend');


z_mask_std = std(table2array(datamatrix_all(:,end-199:end-100)),1);
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

%% calculate z score for all latent variables in terms of each cluster
Z_matrix = zeros(200,numel(unique(datamatrix_all.group)));

for i = 1:100
    for j = 0:13
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix_all.m%d);',i-1));
        eval(sprintf('std_z = std(datamatrix_all.m%d);',i-1));
        % then get the mean of the z over specific group
        submatrix = datamatrix_all(datamatrix_all.group == j,:);
        eval(sprintf('m_z_sub = mean(submatrix.m%d);',i-1));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(i,j+1) = z_score;
    end
end

for i = 1:100
    for j = 0:13
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix_all.t%d);',i-1));
        eval(sprintf('std_z = std(datamatrix_all.t%d);',i-1));
        % then get the mean of the z over specific group
        submatrix = datamatrix_all(datamatrix_all.group == j,:);
        eval(sprintf('m_z_sub = mean(submatrix.t%d);',i-1));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(100+i,j+1) = z_score;
    end
end

%% cluster the z score data using clustergram
all_latent = 1;

if all_latent == 1
    YtitleAll = {};
    for i = 1:100
        eval(sprintf("YtitleAll = [YtitleAll,'m%d'];",i-1));
    end
    
    for i = 1:100
        eval(sprintf("YtitleAll = [YtitleAll,'t%d'];",i-1));
    end
    
    cg = clustergram(Z_matrix,'Colormap',jet,'RowLabels',YtitleAll,'ColumnLabels',["0","1","2","3","4","5","6","7","8","9","10","11","12","13"]);

elseif all_latent == 0
    Z_matrix = Z_matrix([chosenMIdx,chosenTIdx+100],:);
    cg = clustergram(Z_matrix,'Colormap',jet,'RowLabels',Ytitle,'ColumnLabels',["0","1","2","3","4","5","6","7","8","9","10","11","12","13"]);
end
%% join groups into clusters
Clusters = {[2,4],[3,10],[6,5],[7],[8],[12,0],[9,1],[11,13]};
C  = zeros(height(datamatrix_all),1);
for i = 1:numel(Clusters)
    for j = cell2mat(Clusters(i))
        idxT = datamatrix_all.group == j;
        C(idxT) = i;
    end
end
datamatrix_all.cluster = C;
%%
figure(2)
g0c = [42 214 197]./255;
g1c = [20 81 149]./255;
g2c = [96 163 83]./255;
g3c = [200 214 197]./255;
g4c = [129 131 186]./255;
g5c = [129 0 0]./255;
g6c = [255 40 255]./255;
g7c = [255 165 0]./255;


gscatter(datamatrix_all.xumap,datamatrix_all.yumap,datamatrix_all.cluster,[g0c;g1c;g2c;g3c;g4c;g5c;g6c;g7c],[],10)
gscatter(datamatrix_all.xumap,datamatrix_all.yumap,datamatrix_all.cluster,10)
%% generate example synthetic image for each clusters

syn_im_totalM = [];
syn_im_totalT = [];

for i = 1:numel(unique(datamatrix_all.cluster))
    submatrix = datamatrix_all(datamatrix_all.cluster == i,:);
    % first find the mean and std of the z dim
    m_vec_M = [];
    std_vec_M = [];
    for j = 1:100
       eval(sprintf("m_vec_M = [m_vec_M mean(submatrix.m%d)];",j-1));
       eval(sprintf("std_vec_M = [std_vec_M std(submatrix.m%d)];",j-1));
    end
    
    m_vec_T = [];
    std_vec_T = [];
    for j = 1:100
       eval(sprintf("m_vec_T = [m_vec_T mean(submatrix.t%d)];",j-1));
       eval(sprintf("std_vec_T = [std_vec_T std(submatrix.t%d)];",j-1));
    end
    
    varange = [0];
    for j = varange
        syn_im_totalM = [syn_im_totalM;m_vec_M + j*std_vec_M];
        syn_im_totalT = [syn_im_totalT;m_vec_T + j*std_vec_T];
    end
end
csvwrite(strcat(root_dir,'latent_z_100_VAE_Mask_subgate_scan_Mean.csv'),syn_im_totalM)
csvwrite(strcat(root_dir,'latent_z_100_VAE_Texture_subgate_scan_Mean.csv'),syn_im_totalT)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot barplots of ranked z scores and pick the highest 50
datanum = 21;
Clusters = {[2,4],[3,10],[6,5],[7],[8],[12,0],[9,1],[11,13]};
Clusters_Z = [];

for i = 1:8
    c_z = mean(Z_matrix(:,cell2mat(Clusters(i))+1),2);
    Clusters_Z = [Clusters_Z,c_z];
end 

% Clusters_Z_stdT =std(Clusters_Z(101:200,:),0,2);
% [cluster_z_std_sortedT,idxT] = sort(Clusters_Z_stdT,'descend');
% X = categorical(YtitleAll(idxT+100));
% XM = reordercats(X,YtitleAll(idxT+100));
% bar(XM,cluster_z_std_sortedT)
% figure()
% Clusters_Z_stdM =std(Clusters_Z(1:100,:),0,2);
% [cluster_z_std_sortedM,idxM] = sort(Clusters_Z_stdM,'descend');
% X = categorical(YtitleAll(idxM));
% XM = reordercats(X,YtitleAll(idxM));
% bar(XM,cluster_z_std_sortedM)
% 
% idxT_chosen = idxT(1:datanum)+100;
% idxM_chosen = idxM(1:datanum);

features = [];
for i = 1:100
    eval(sprintf('features = [features,datamatrix_all.m%d];',i-1));
end

for i = 1:100
    eval(sprintf('features = [features,datamatrix_all.t%d];',i-1));
end

codeMstd = std(features(:,1:100),0,1);
codeTstd = std(features(:,101:200),0,1);

[z_texture_std_sorted, IndexT] = sort(codeTstd,'descend');
[z_mask_std_sorted, IndexM] = sort(codeMstd,'descend');




% only choose dimension with high stdev from mask

idxM_chosen = IndexM(1:datanum);


idxT_chosen = IndexT(1:datanum)+100;

Clusters_Z_compacted = Clusters_Z([idxM_chosen;idxT_chosen],:);
YtitleAll_compacted = YtitleAll([idxM_chosen;idxT_chosen]);
cg = clustergram(Clusters_Z_compacted,'Colormap',jet,'RowLabels',YtitleAll_compacted,'ColumnLabels',["1","2","3","4","5","6","7","8"]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extract correlation matrix for each trial
datanum = 21;
%CorrFluoTimeTotal = zeros(datanum*2,3,3);
YtitleAll_compacted = YtitleAll([idxM_chosen',idxT_chosen']);
for T = 1

datamatrix = datamatrix_all((datamatrix_all.pos > 0) & (datamatrix_all.pos < 11) & (datamatrix_all.pcell~= 0) & (datamatrix_all.distance~= 0), :);


features = [];
for i = 1:100
    eval(sprintf('features = [features,datamatrix.m%d];',i-1));
end

for i = 1:100
    eval(sprintf('features = [features,datamatrix.t%d];',i-1));
end

features = [features,datamatrix.distance];

corrMatrix = corrcoef(features);
corrFluoTime = corrMatrix([idxM_chosen,idxT_chosen],end);

CorrFluoTimeTotal = corrFluoTime;
end

%% calculate mean and std for the Correlation matrix and plot verticle bars


propnames = {'distance'};
for i = 1
    figure(i)
    hold on
    corr_m = CorrFluoTimeTotal;
    
    [corr_m_sorted, m_i] = sort(corr_m,'descend');
    
    Ytitle_sorted = YtitleAll_compacted(m_i);
    X = categorical(Ytitle_sorted);
    X = reordercats(X,Ytitle_sorted);
    barh(X,corr_m_sorted,'FaceColor','r')
    xlabel('Correlation Coefficient')
    title(propnames{i})
    
    hold off
end

