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
%%
figure(1)
g0c = [42 214 197]./255;
g1c = [0 0 0]./255;
g2c = [70 0 207]./255;
g3c = [167 217 104]./255;
g4c = [129 131 186]./255;
g5c = [167 100 104]./255;%%
g6c = [222 83 63]./255;
g7c = [42 214 10]./255;%%
g8c = [0 137 164]./255;%%
g9c = [220 81 149]./255;
g10c = [96 163 83]./255;

gscatter(datamatrix_all.xumap,datamatrix_all.yumap,datamatrix_all.group,[g0c;g1c;g2c;g3c;g4c;g5c;g6c;g7c;g8c;g9c;g10c],[],8)
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

%% calculate z score for all latent variables in terms of each cluster
Z_matrix = zeros(200,numel(unique(datamatrix_all.group)));

for i = 1:100
    for j = 0:9
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix_all.m%d);',i));
        eval(sprintf('std_z = std(datamatrix_all.m%d);',i));
        % then get the mean of the z over specific group
        submatrix = datamatrix_all(datamatrix_all.group == j,:);
        eval(sprintf('m_z_sub = mean(submatrix.m%d);',i));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(i,j+1) = z_score;
    end
end

for i = 1:100
    for j = 0:9
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix_all.t%d);',i));
        eval(sprintf('std_z = std(datamatrix_all.t%d);',i));
        % then get the mean of the z over specific group
        submatrix = datamatrix_all(datamatrix_all.group == j,:);
        eval(sprintf('m_z_sub = mean(submatrix.t%d);',i));
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
        eval(sprintf("YtitleAll = [YtitleAll,'m%d'];",i));
    end
    
    for i = 1:100
        eval(sprintf("YtitleAll = [YtitleAll,'t%d'];",i));
    end
    
    cg = clustergram(Z_matrix,'Colormap',jet,'RowLabels',YtitleAll,'ColumnLabels',["0","1","2","3","4","5","6","7","8","9"]);

elseif all_latent == 0
    Z_matrix = Z_matrix([chosenMIdx,chosenTIdx+100],:);
    cg = clustergram(Z_matrix,'Colormap',jet,'RowLabels',Ytitle,'ColumnLabels',["0","1","2","3","4","5","6","7","8","9"]);
end
%% join groups into clusters
Clusters = {[0,1,3],[2],[4,5,6],[7,8],[9]};
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
g1c = [220 81 149]./255;
g2c = [96 163 83]./255;
g3c = [200 214 197]./255;
g4c = [129 131 186]./255;



gscatter(datamatrix_all.xumap,datamatrix_all.yumap,datamatrix_all.cluster,[g0c;g1c;g2c;g3c;g4c],[],8)
%% generate example synthetic image for each clusters

syn_im_totalM = [];
syn_im_totalT = [];

for i = 1:numel(unique(datamatrix_all.cluster))
    submatrix = datamatrix_all(datamatrix_all.cluster == i,:);
    % first find the mean and std of the z dim
    m_vec_M = [];
    std_vec_M = [];
    for j = 1:100
       eval(sprintf("m_vec_M = [m_vec_M mean(submatrix.m%d)];",j));
       eval(sprintf("std_vec_M = [std_vec_M std(submatrix.m%d)];",j));
    end
    
    m_vec_T = [];
    std_vec_T = [];
    for j = 1:100
       eval(sprintf("m_vec_T = [m_vec_T mean(submatrix.t%d)];",j));
       eval(sprintf("std_vec_T = [std_vec_T std(submatrix.t%d)];",j));
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
%% plot CD34 and CD38 histograms for each cluster in each clusters
countM = 0;
condition = 2;
figure(5)
for i = 1:5
    submatrix = datamatrix_all(datamatrix_all.cluster == i & datamatrix_all.condition == condition,:);
    subplot(5,3,countM + 1)
    histogram(log10(submatrix.APC_corr),100);
    xlim([-2,4])
    subplot(5,3,countM + 2)
    histogram(log10(submatrix.PE_corr),100);
    xlim([-2,4])
    subplot(5,3,countM + 3)
    histogram(submatrix.t,100);
    countM = countM + 3;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot barplots of ranked z scores and pick the highest 50
datanum = 50;
Clusters = {[0,1,3],[2],[4,5,6],[7,8],[9]};
Clusters_Z = [];

for i = 1:5
    c_z = mean(Z_matrix(:,cell2mat(Clusters(i))+1),2);
    Clusters_Z = [Clusters_Z,c_z];
end 

Clusters_Z_stdT =std(Clusters_Z(101:200,:),0,2);
[cluster_z_std_sortedT,idxT] = sort(Clusters_Z_stdT,'descend');
X = categorical(YtitleAll(idxT+100));
XM = reordercats(X,YtitleAll(idxT+100));
bar(XM,cluster_z_std_sortedT)
figure()
Clusters_Z_stdM =std(Clusters_Z(1:100,:),0,2);
[cluster_z_std_sortedM,idxM] = sort(Clusters_Z_stdM,'descend');
X = categorical(YtitleAll(idxM));
XM = reordercats(X,YtitleAll(idxM));
bar(XM,cluster_z_std_sortedM)

idxT_chosen = idxT(1:datanum)+100;
idxM_chosen = idxM(1:datanum);

features = [];
for i = 1:100
    eval(sprintf('features = [features,datamatrix_all.m%d];',i));
end

for i = 1:100
    eval(sprintf('features = [features,datamatrix_all.t%d];',i));
end
code = mean(features(:,1:200),1);
codeMstd = std(features(:,1:100),0,1);
codeTstd = std(features(:,101:200),0,1);
M_chosen_std = codeMstd(idxM_chosen);
T_chosen_std = codeTstd(idxT_chosen-100);

% only choose dimension with high stdev from mask
[~,idx] = sort(M_chosen_std,'descend');
idxM_chosen = idxM_chosen(idx(1:21));

[~,idx] = sort(T_chosen_std,'descend');
idxT_chosen = idxT_chosen(idx(1:21));

Clusters_Z_compacted = Clusters_Z([idxM_chosen;idxT_chosen],:);
YtitleAll_compacted = YtitleAll([idxM_chosen;idxT_chosen]);
cg = clustergram(Clusters_Z_compacted,'Colormap',jet,'RowLabels',YtitleAll_compacted,'ColumnLabels',["1","2","3","4","5"]);

%% Assign defining features set that is strong for each cluster
cluster2_idx = [101,107,110,115,117,118,119,120,128,139,155,156,158,162,171,176];
cluster1_idx = [12,43,59,89,92];
cluster3_idx = [33,42,48,51,56,58,80,84,94,110];
cluster5_idx = [4,40,45,87,90,99,159,144,164,172,110,128];

%% generate example synthetic image originate from population mean and reaches out to each clusters
features = [];
for i = 1:100
    eval(sprintf('features = [features,datamatrix_all.m%d];',i));
end

for i = 1:100
    eval(sprintf('features = [features,datamatrix_all.t%d];',i));
end
code = mean(features(:,1:200),1);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var_rangeM = 0:0.5:1.5;
var_rangeT = 0:2.5:7.5;
idx_set = {cluster1_idx,cluster2_idx,cluster3_idx,cluster5_idx};
countM = 1;
countT = 1;
synbarcodeM = [];
synbarcodeT = [];

for i = idx_set
    set = cell2mat(i);
    M_set = sort(set(set <101));
    T_set = sort(set(set > 100));
    
    if ~isempty(M_set)
        for v = 1:numel(var_rangeM)
            newbarcode = code(1:100);
            newbarcode(M_set) = newbarcode(M_set) + var_rangeM(v);
            synbarcodeM(countM,:) = newbarcode;
            countM = countM + 1;
        end
    else
        for v = 1:numel(var_rangeM)
            synbarcodeM(countM,:) = code(1:100);
            countM = countM + 1;
        end
    end
    
    if ~isempty(T_set)
        for v = 1:numel(var_rangeT)
            newbarcode = code(101:200);
            newbarcode(T_set-100) = newbarcode(T_set-100) + var_rangeT(v);
            synbarcodeT(countT,:) = newbarcode;
            countT = countT + 1;
            %disp(newbarcode)
            %keyboard
        end
    else
        for v = 1:numel(var_rangeT)
            synbarcodeT(countT,:) = code(101:200);
            countT =  countT + 1;
        end
    end
    
end
csvwrite(strcat(root_dir,'latent_z_100_VAE_Mask_subgate_scan.csv'),synbarcodeM)
csvwrite(strcat(root_dir,'latent_z_100_VAE_Texture_subgate_scan.csv'),synbarcodeT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%% plot correlations between these z dim with CD34 and CD38 and time
%%%%%%%%% 

%% Extract correlation matrix for each trial
datanum = 21;
CorrFluoTimeTotal = zeros(datanum*2,3,3);
YtitleAll_compacted = YtitleAll([idxM_chosen',idxT_chosen']);
for T = 1:3

datamatrix = datamatrix_all(datamatrix_all.trial == T, :);

logCD34 = log10(datamatrix.APC_corr+0.00001);
logCD34(logCD34 == -Inf) = 0;

logCD38 = log10(datamatrix.PE_corr+0.00001);
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
corrFluoTime = corrMatrix([idxM_chosen,idxT_chosen],end-2:end);

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
    Ytitle_sorted = YtitleAll_compacted(m_i);
    X = categorical(Ytitle_sorted);
    X = reordercats(X,Ytitle_sorted);
    barh(X,corr_m_sorted,'FaceColor','r')
    xlabel('Correlation Coefficient')
    title(propnames{i})
    er = errorbar(corr_m_sorted,X,corr_std_sorted,corr_std_sorted,'.','horizontal','Color',[0 0 0]);
    hold off
end





