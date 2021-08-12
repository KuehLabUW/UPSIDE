clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
datadirfile = 'Dataset1CompleteAreaEdgeFluoCluster.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


matrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


cd(code_dir)

matname = 'ChosenIND_pseudopod.mat';
matrix = matrix(matrix.trial ~= 2,:);

cd('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/mat')


load(matname)

%get matrix for pseudopod data

pseudo_matrix = matrix(INDEX,:);
pseudo_matrix_guided_small = matrix(matrix.m47 > 2.5,:);
pseudo_matrix_guided_large = matrix(matrix.m58 > 2.5,:);
%get random cells from the data
% chosen_ind = randperm(height(matrix),height(pseudo_matrix));
% chosen_matrix = matrix(chosen_ind,:);
chosen_matrix = matrix;

%% display the pseduopod cells

TotalIm = [];
TotalIm_mask = [];
randind = randperm(height(pseudo_matrix_guided_small),100);
for k = randind
    
    tifname = string(pseudo_matrix_guided_small.dirname(k));
    %disp(tifname);
    im = imread(tifname);
    TotalIm = cat(3,TotalIm,im);
    
    tifname_mask = char(tifname);
    tifname_mask = strcat(tifname_mask(1:end-4),'_mask.jpg');
    im_mask = imread(tifname_mask);
    im_mask = im_mask > 100;
    TotalIm_mask = cat(3,TotalIm_mask,im_mask);
end    

figure(8)
montage(TotalIm),imcontrast()
figure(24)
montage(TotalIm_mask)


%% calculate mean CD38 or CD34 expression

fluo = 1; % 1 for CD34 and 2 for CD38

if fluo == 1
    fluo_rand = log10(chosen_matrix.APC_corr+1);
    fluo_pseudo = log10(pseudo_matrix.APC_corr+1);

    fluo_pseudo_guided_small = log10(pseudo_matrix_guided_small.APC_corr+1);
    fluo_pseudo_guided_large = log10(pseudo_matrix_guided_large.APC_corr+1);
elseif fluo == 2
    fluo_rand = log10(chosen_matrix.PE_corr+1);
    fluo_pseudo = log10(pseudo_matrix.PE_corr+1);

    fluo_pseudo_guided_small = log10(pseudo_matrix_guided_small.PE_corr+1);
    fluo_pseudo_guided_large = log10(pseudo_matrix_guided_large.PE_corr+1);
end

bar([1,2,3],[mean(fluo_rand),mean(fluo_pseudo_guided_small),mean(fluo_pseudo_guided_large)]); hold on
%bar([1,2],[mean(fluo_rand),mean(fluo_pseudo)]); hold on
errorbar([1,2,3],[mean(fluo_rand),mean(fluo_pseudo_guided_small),mean(fluo_pseudo_guided_large)],[std(fluo_rand),std(fluo_pseudo_guided_small),std(fluo_pseudo_guided_large)],[std(fluo_rand),std(fluo_pseudo_guided_small),std(fluo_pseudo_guided_large)])
%errorbar([1,2],[mean(fluo_rand),mean(fluo_pseudo)],[std(fluo_rand),std(fluo_pseudo)],[std(fluo_rand),std(fluo_pseudo)])
ylim([0,2.8])

[h1,p1,ci1,stats1] = ttest2(fluo_rand,fluo_pseudo_guided_small);
[h2,p2,ci2,stats2] = ttest2(fluo_rand,fluo_pseudo_guided_large);
%% ask cluster makeup
cluster_num = numel(unique(pseudo_matrix.cluster));
num =[];
for i = 1:cluster_num
    num = [num height(pseudo_matrix(pseudo_matrix.cluster == i,:))];
end
num_f = num./height(pseudo_matrix);
num_f = num_f([1,3,5,6,7,8,2,4]);
bar(1:cluster_num,num_f)
