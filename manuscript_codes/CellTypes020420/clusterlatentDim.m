clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/';

datadirfile = 'ClusteredTypesChosen.csv';
datacolumn = 213;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
chosenL = 50;

% for i = 1:numel(datamatrix_all)
%     if datamatrix_all.group(i) == 4
%         datamatrix_all.group(i) = 2;
%     elseif datamatrix_all.group(i) == 5
%         datamatrix_all.group(i) = 4;
%     end
%     
% end
%% get the index of the first 40 highest std latent value for all dataset

z_texture_std = std(table2array(datamatrix_all(:,214-99:214)),1);
[z_texture_std_sorted, IndexT] = sort(z_texture_std,'descend');


z_mask_std = std(table2array(datamatrix_all(:,114-99:114)),1);
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

for i = 0:99
    for j = 1:8
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix_all.m%d);',i));
        eval(sprintf('std_z = std(datamatrix_all.m%d);',i));
        % then get the mean of the z over specific group
        submatrix = datamatrix_all(datamatrix_all.group == j-1,:);
        eval(sprintf('m_z_sub = mean(submatrix.m%d);',i));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(i+1,j) = z_score;
    end
end

for i = 0:99
    for j = 1:8
        % first get the mean and std of z over all population
        eval(sprintf('m_z = mean(datamatrix_all.t%d);',i));
        eval(sprintf('std_z = std(datamatrix_all.t%d);',i));
        % then get the mean of the z over specific group
        submatrix = datamatrix_all(datamatrix_all.group == j-1,:);
        eval(sprintf('m_z_sub = mean(submatrix.t%d);',i));
        % calculate z_score and add to matrix
        z_score = (m_z_sub-m_z)/std_z;        
        Z_matrix(101+i,j) = z_score;
    end
end
%% cluster the z score data using clustergram
all_latent = 0;

if all_latent == 1
    YtitleAll = {};
    z_matrix = Z_matrix;
    for i = 0:99
        eval(sprintf("YtitleAll = [YtitleAll,'m%d'];",i));
    end
    
    for i = 0:99
        eval(sprintf("YtitleAll = [YtitleAll,'t%d'];",i));
    end
    
    cg = clustergram(z_matrix,'Colormap',jet,'RowLabels',YtitleAll,'ColumnLabels',["0","1","2","3","4","5","6","7"]);

elseif all_latent == 0
    z_matrix = Z_matrix;
    z_matrix = z_matrix([chosenMIdx,chosenTIdx+100],:);
    cg = clustergram(z_matrix,'Colormap',jet,'RowLabels',Ytitle,'ColumnLabels',["0","1","2","3","4","5","6","7"]);
end

%% Assign defining features set that is strong for each cluster
cluster0_idx = [119,48,144];
cluster1_idx = [15,142,129];
cluster2_idx = [62,40,160];
cluster3_idx = [27,136,22];
cluster4_idx = [190,102,171];
cluster5_idx = [37,93,150];
cluster6_idx = [3,98,70];
cluster7_idx = [157,175,142];
%% Calculate percentage of cells from each cluster

% first extract the same number of cells from each cell type and compile
% that into a new datamatrix
cell_num = height(datamatrix_all(datamatrix_all.type == 4, :));
datamatrix_sub = table();
for cell_type = 1:4
    submatrix = datamatrix_all(datamatrix_all.type == cell_type, :);
    idx = randperm(height(submatrix),cell_num);
    submatrix_type = submatrix(idx,:);
    datamatrix_sub = [datamatrix_sub;submatrix_type];
end
% now calculate the percentage

Mac = [];
K = [];
P = [];
A = [];

for i = 0:7
    submatrix = datamatrix_all(datamatrix_sub.group == i, :);
    m = sum(submatrix.type == 1);
    k = sum(submatrix.type == 2);
    p = sum(submatrix.type == 3);
    a = sum(submatrix.type == 4);
    
    s = m + k + p + a;
    Mac = [Mac m/s];
    K = [K k/s];
    P = [P p/s];
    A = [A a/s];
    %keyboard
end
x = 0:7;
y = [Mac(1) K(1) P(1) A(1); Mac(3) K(3) P(3) A(3); Mac(5) K(5) P(5) A(5); Mac(4) K(4) P(4) A(4); Mac(7) K(7) P(7) A(7); Mac(6) K(6) P(6) A(6); Mac(8) K(8) P(8) A(8); Mac(2) K(2) P(2) A(2)];
bar(x,y,'stacked')
ylim([0,1.2])
keyboard
%% sample image from each cluster
group = 2;

matrix = datamatrix_all(datamatrix_all.group == group,:);

num_im = 4;

num = height(matrix);
patch_ind = randi([1,num],1,num_im);

TotalIm = [];


for k = 1:numel(patch_ind)
    
    tifname = string(matrix.dirname(patch_ind(k)));
    %disp(tifname);
    im = imread(tifname);
    TotalIm = cat(3,TotalIm,im);
end    
%picked_im = TotalIm(:,:,patch_ind);
figure(8)
montage(TotalIm),imcontrast()
cd(root_dir)




