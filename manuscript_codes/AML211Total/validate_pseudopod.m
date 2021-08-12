clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211Total/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';
datadirfile = 'cluster_tracked_dist_area_dist_cond.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


matrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
matrix = matrix(matrix.pcell~=0,:);

%get matrix for pseudopod data
mean_matrix = matrix;
pseudo_matrix_small1 = matrix(matrix.m85 > 3,:);
pseudo_matrix_small2 = matrix(matrix.m4 > 3,:);
pseudo_matrix_small3 = matrix(matrix.m75 > 3,:);

pseudo_matrix_large1 = matrix(matrix.m45 > 3,:);
pseudo_matrix_large2 = matrix(matrix.m99 > 3,:);
pseudo_matrix_large3 = matrix(matrix.m51 > 3,:);



%% display the pseduopod cells

% TotalIm = [];
% TotalIm_mask = [];
% randind = randperm(height(pseudo_matrix_guided_small),100);
% for k = randind
%     
%     tifname = string(pseudo_matrix_guided_small.dirname(k));
%     %disp(tifname);
%     im = imread(tifname);
%     TotalIm = cat(3,TotalIm,im);
%     
%     tifname_mask = char(tifname);
%     tifname_mask = strcat(tifname_mask(1:end-4),'_mask.jpg');
%     im_mask = imread(tifname_mask);
%     im_mask = im_mask > 100;
%     TotalIm_mask = cat(3,TotalIm_mask,im_mask);
% end    
% 
% figure(8)
% montage(TotalIm),imcontrast()
% figure(24)
% montage(TotalIm_mask)


%% calculate mean CD38 or CD34 expression
m        = mean(matrix.distance)*0.1625;
s        = std(matrix.distance)*0.1625;

m_small1 = mean(pseudo_matrix_small1.distance)*0.1625;
s_small1 = std(pseudo_matrix_small1.distance)*0.1625;
m_small2 = mean(pseudo_matrix_small2.distance)*0.1625;
s_small2 = std(pseudo_matrix_small2.distance)*0.1625;
m_small3 = mean(pseudo_matrix_small3.distance)*0.1625;
s_small3 = std(pseudo_matrix_small3.distance)*0.1625;

m_large1 = mean(pseudo_matrix_large1.distance)*0.1625;
s_large1 = std(pseudo_matrix_large1.distance)*0.1625;
m_large2 = mean(pseudo_matrix_large2.distance)*0.1625;
s_large2 = std(pseudo_matrix_large2.distance)*0.1625;
m_large3 = mean(pseudo_matrix_large3.distance)*0.1625;
s_large3 = std(pseudo_matrix_large3.distance)*0.1625;

% bar([1,2,3,4,5,6,7],[m,m_small1,m_small2,m_small3,m_large1,m_large2,m_large3]); hold on
% errorbar([1,2,3,4,5,6,7],[m,m_small1,m_small2,m_small3,m_large1,m_large2,m_large3],[s,s_small1,s_small2,s_small3,s_large1,s_large2,s_large3],[s,s_small1,s_small2,s_small3,s_large1,s_large2,s_large3])

bar([1,2,3],[m,m_small1,m_large3]); hold on
errorbar([1,2,3],[m,m_small1,m_large3],[s,s_small1,s_large3],[s,s_small1,s_large3])

[h1,p1,ci1,stats1] = ttest2(matrix.distance,pseudo_matrix_small1.distance);
[h2,p2,ci2,stats2] = ttest2(pseudo_matrix_small1.distance,pseudo_matrix_large1.distance);
%% ask cluster makeup
cluster_num = numel(unique(pseudo_matrix.cluster));
num =[];
for i = 1:cluster_num
    num = [num height(pseudo_matrix(pseudo_matrix.cluster == i,:))];
end
num_f = num./height(pseudo_matrix);
num_f = num_f([1,3,5,6,7,8,2,4]);
bar(1:cluster_num,num_f)
