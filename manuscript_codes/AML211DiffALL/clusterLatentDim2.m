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


%% plot cluster
figure(1)
g0c = [42 214 197]./255;
g1c = [20 81 149]./255;
g2c = [96 163 83]./255;
g3c = [200 214 197]./255;
g4c = [129 131 186]./255;
g5c = [129 0 0]./255;
g6c = [255 40 255]./255;
g7c = [255 165 0]./255;

gscatter(datamatrix.xumap,datamatrix.yumap,datamatrix.cluster,[g0c;g1c;g2c;g3c;g4c;g5c;g6c;g7c],[],8)

%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
title('clusters')
%savefig('/home/phnguyen/Desktop/clusters.fig')
%close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%% calculate z score for all latent variables in terms of each cluster
Z_matrix = zeros(200,numel(unique(datamatrix.cluster)));

for i = 1:100
    for j = 1:8
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix.m%d);',i-1));
        eval(sprintf('std_z = std(datamatrix.m%d);',i-1));
        % then get the mean of the z over specific group
        submatrix = datamatrix(datamatrix.cluster == j,:);
        eval(sprintf('m_z_sub = mean(submatrix.m%d);',i-1));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(i,j) = z_score;
    end
end

for i = 1:100
    for j = 1:8
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix.t%d);',i-1));
        eval(sprintf('std_z = std(datamatrix.t%d);',i-1));
        % then get the mean of the z over specific group
        submatrix = datamatrix(datamatrix.cluster == j,:);
        eval(sprintf('m_z_sub = mean(submatrix.t%d);',i-1));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(100+i,j) = z_score;
    end
end

%% cluster the z score data using clustergram
all_latent = 0;

if all_latent == 1
    YtitleAll = {};
    for i = 1:100
        eval(sprintf("YtitleAll = [YtitleAll,'m%d'];",i-1));
    end
    
    for i = 1:100
        eval(sprintf("YtitleAll = [YtitleAll,'t%d'];",i-1));
    end
    
    cg = clustergram(Z_matrix,'Colormap',jet,'RowLabels',YtitleAll,'ColumnLabels',["1","2","3","4","5","6","7","8"]);

elseif all_latent == 0
    Z_matrix = Z_matrix([chosenMIdx,chosenTIdx+100],:);
    cg = clustergram(Z_matrix,'Colormap',jet,'RowLabels',Ytitle,'ColumnLabels',["1","2","3","4","5","6","7","8"]);
end

%% generate example synthetic image for each clusters

syn_im_totalM = [];
syn_im_totalT = [];

for i = 1:numel(unique(datamatrix.cluster))
    submatrix = datamatrix(datamatrix.cluster == i,:);
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
csvwrite(strcat(root_dir,'latent_z_100_VAE_Mask_Mean.csv'),syn_im_totalM)
csvwrite(strcat(root_dir,'latent_z_100_VAE_Texture_Mean.csv'),syn_im_totalT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%% plot correlations between these z dim with CD34 and CD38 and time
%%%%%%%%% 

%% Extract correlation matrix for each trial
datanum = 40;
CorrFluoTimeTotal = zeros(datanum*2,3,3);

if ~exist('YtitleAll')
     YtitleAll = {};
    for i = 1:100
        eval(sprintf("YtitleAll = [YtitleAll,'m%d'];",i-1));
    end
    
    for i = 1:100
        eval(sprintf("YtitleAll = [YtitleAll,'t%d'];",i-1));
    end
end




YtitleAll_compacted = YtitleAll([chosenMIdx',(chosenTIdx+100)']);
for T = 1:3

datamatrix_t = datamatrix(datamatrix.trial == T, :);

logCD34 = log10(datamatrix_t.APC_corr+0.00001);
logCD34(logCD34 == -Inf) = 0;

logCD38 = log10(datamatrix_t.PE_corr+0.00001);
logCD38(logCD38 == -Inf) = 0;

features = [];
for i = 1:100
    eval(sprintf('features = [features,datamatrix_t.m%d];',i-1));
end

for i = 1:100
    eval(sprintf('features = [features,datamatrix_t.t%d];',i-1));
end

features = [features,logCD38,logCD34,datamatrix_t.t];

corrMatrix = corrcoef(features);
corrFluoTime = corrMatrix([chosenMIdx,chosenTIdx],end-2:end);

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





