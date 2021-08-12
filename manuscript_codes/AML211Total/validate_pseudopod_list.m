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
featurelist = [85,18,4,92,75,58,31,27,47,23,11,30,77,16,38,45,99,51];
%get matrix for pseudopod data
mean_matrix = matrix;

for i = featurelist
    eval(sprintf('pseudo_matrix%d = matrix(matrix.m%d > 2.5,:);',i,i));
end

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

M = [m];
S = [s];
for i = featurelist
    M = [M eval(sprintf('mean(pseudo_matrix%d.distance)*0.1625;',i))];
    S = [S eval(sprintf('std(pseudo_matrix%d.distance)*0.1625;',i))];

end
bar(1:numel(featurelist)+1,M); hold on
errorbar(1:numel(featurelist)+1,M,S,S)

% [h1,p1,ci1,stats1] = ttest2(matrix.distance,pseudo_matrix_small1.distance);
% [h2,p2,ci2,stats2] = ttest2(pseudo_matrix_small1.distance,pseudo_matrix_large1.distance);
%% ask cluster makeup
cluster_num = numel(unique(pseudo_matrix.cluster));
num =[];
for i = 1:cluster_num
    num = [num height(pseudo_matrix(pseudo_matrix.cluster == i,:))];
end
num_f = num./height(pseudo_matrix);
num_f = num_f([1,3,5,6,7,8,2,4]);
bar(1:cluster_num,num_f)
