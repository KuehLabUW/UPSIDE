%This script plots all the live cell number from UM and nonUM data
clear

%% extract drug and UM matrices
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
umapfilename = 'CombinedSubstractedDirUMAP_mixgaus_largeLIVEFLUO60z_nodropout2_nostyle.csv';

cd(code_dir)

matrix = readtable(strcat(root_dir,umapfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
matrix_nondrug = matrix(matrix.treated == 0, :);
matrix_drug = matrix(matrix.treated == 1, :);

matrix_nondrug_nonUM = matrix_nondrug(matrix_nondrug.pos <= 16,:);
matrix_nondrug_UM = matrix_nondrug(matrix_nondrug.pos > 16,:);

matrix_drug_nonUM = matrix_drug(matrix_drug.pos <= 16,:);
matrix_drug_UM = matrix_drug(matrix_drug.pos > 16,:);

%% set up fluorescence threshold
figure(1);histogram(log10(matrix.APC_corr));xlabel('log(APC)')
figure(2);histogram(log10(matrix.PE_corr));xlabel('log(PE)')
%APC_logthreshold = 1.8;
%PE_logthreshold = 2;
APC_logthreshold = 1.5;
PE_logthreshold = 2;

%% set up time sequence categories
time_interval = 5*20;

%create a cell variable to store all the time-series table
nonUM_T = cell(numel(0:round(max(matrix_nondrug_nonUM.t)/time_interval)),1);
UM_T = cell(numel(0:round(max(matrix_nondrug_nonUM.t)/time_interval)),1);

for t = 0:round(max(matrix_nondrug_nonUM.t)/time_interval)
    
    matrix_nondrug_nonUM_T= matrix_nondrug_nonUM((matrix_nondrug_nonUM.t >= 1+time_interval*t)& (matrix_nondrug_nonUM.t <= 5*20+time_interval*t),:);
    nonUM_T{t+1} = matrix_nondrug_nonUM_T;
    
    matrix_nondrug_UM_T= matrix_nondrug_UM((matrix_nondrug_UM.t >= 1+time_interval*t)& (matrix_nondrug_UM.t <= 5*20+time_interval*t),:);
    UM_T{t+1} = matrix_nondrug_UM_T;
end

nonUM_T_drug = cell(numel(0:round(max(matrix_drug_nonUM.t)/time_interval)),1);
UM_T_drug = cell(numel(0:round(max(matrix_drug_nonUM.t)/time_interval)),1);

for t = 0:round(max(matrix_drug_nonUM.t)/time_interval)
    
    matrix_drug_nonUM_T= matrix_drug_nonUM((matrix_drug_nonUM.t >= 1+time_interval*t)& (matrix_drug_nonUM.t <= 5*20+time_interval*t),:);
    nonUM_T_drug{t+1} = matrix_drug_nonUM_T;
    
    matrix_drug_UM_T= matrix_drug_UM((matrix_drug_UM.t >= 1+time_interval*t)& (matrix_drug_UM.t <= 5*20+time_interval*t),:);
    UM_T_drug{t+1} = matrix_drug_UM_T;
end

%% plot umaps for representative time chunks
Tchunks = [1,5,10,15];
figure(1)
map = [0.5 0.5 0.5;
       1 0 0];
for i = 1:numel(Tchunks)
    subplot(2,2,i)
    hold on
    on_set = ~(log10(nonUM_T{Tchunks(i)}.APC_corr)< APC_logthreshold) & (log10(nonUM_T{Tchunks(i)}.PE_corr)< PE_logthreshold);
    scatter(nonUM_T{Tchunks(i)}.x_umap,nonUM_T{Tchunks(i)}.y_umap,2,on_set,'filled')
    xlim([-6,6])
    ylim([-6,6])
    colormap(map)
    hold off
end

figure(3)
map = [0.5 0.5 0.5;
       1 0 0];
for i = 1:numel(Tchunks)
    subplot(2,2,i)
    hold on
    on_set = ~(log10(UM_T{Tchunks(i)}.APC_corr)< APC_logthreshold) & (log10(UM_T{Tchunks(i)}.PE_corr)< PE_logthreshold);
    scatter(UM_T{Tchunks(i)}.x_umap,UM_T{Tchunks(i)}.y_umap,2,on_set,'filled')
    xlim([-6,6])
    ylim([-6,6])
    colormap(map)
    hold off
end

figure(2)
R = [0:0.01:1]';
R = sort(R,'descend');
G = [0:0.01:1]';
G = sort(G,'descend');
B = [0:0.01:1]';
B = sort(B,'descend');
map = [R,G,B];
for i = 1:numel(Tchunks)
    subplot(2,2,i)
    hold on
    hist3([nonUM_T{Tchunks(i)}.x_umap,nonUM_T{Tchunks(i)}.y_umap],'CdataMode','auto','Ctrs',{-6:0.4:6 -6:0.4:6},'EdgeColor',[1 1 1]);
    xlim([-6,6])
    ylim([-6,6])
    view(2)
    colormap(map)
    hold off
end

figure(4)
R = [0:0.01:1]';
R = sort(R,'descend');
G = [0:0.01:1]';
G = sort(G,'descend');
B = [0:0.01:1]';
B = sort(B,'descend');
map = [R,G,B];
for i = 1:numel(Tchunks)
    subplot(2,2,i)
    hold on
    hist3([UM_T{Tchunks(i)}.x_umap,UM_T{Tchunks(i)}.y_umap],'CdataMode','auto','Ctrs',{-6:0.4:6 -6:0.4:6},'EdgeColor',[1 1 1]);
    xlim([-6,6])
    ylim([-6,6])
    view(2)
    colormap(map)
    hold off
end
%% plot umaps for representative time chunks Drug
Tchunks = [1,4,8,10];
figure(5)
map = [0.5 0.5 0.5;
       1 0 0];
for i = 1:numel(Tchunks)
    subplot(2,2,i)
    hold on
    on_set = ~(log10(nonUM_T_drug{Tchunks(i)}.APC_corr)< APC_logthreshold) & (log10(nonUM_T_drug{Tchunks(i)}.PE_corr)< PE_logthreshold);
    scatter(nonUM_T_drug{Tchunks(i)}.x_umap,nonUM_T_drug{Tchunks(i)}.y_umap,2,on_set,'filled')
    xlim([-6,6])
    ylim([-6,6])
    colormap(map)
    hold off
end

figure(7)
map = [0.5 0.5 0.5;
       1 0 0];
for i = 1:numel(Tchunks)
    subplot(2,2,i)
    hold on
    on_set = ~(log10(UM_T_drug{Tchunks(i)}.APC_corr)< APC_logthreshold) & (log10(UM_T_drug{Tchunks(i)}.PE_corr)< PE_logthreshold);
    scatter(UM_T_drug{Tchunks(i)}.x_umap,UM_T_drug{Tchunks(i)}.y_umap,2,on_set,'filled')
    xlim([-6,6])
    ylim([-6,6])
    colormap(map)
    hold off
end

figure(6)
R = [0:0.01:1]';
R = sort(R,'descend');
G = [0:0.01:1]';
G = sort(G,'descend');
B = [0:0.01:1]';
B = sort(B,'descend');
map = [R,G,B];
for i = 1:numel(Tchunks)
    subplot(2,2,i)
    hold on
    hist3([nonUM_T_drug{Tchunks(i)}.x_umap,nonUM_T_drug{Tchunks(i)}.y_umap],'CdataMode','auto','Ctrs',{-6:0.4:6 -6:0.4:6},'EdgeColor',[1 1 1],'LineWidth',0.01);
    xlim([-6,6])
    ylim([-6,6])
    view(2)
    colormap(map)
    hold off
end

figure(8)
R = [0:0.01:1]';
R = sort(R,'descend');
G = [0:0.01:1]';
G = sort(G,'descend');
B = [0:0.01:1]';
B = sort(B,'descend');
map = [R,G,B];
for i = 1:numel(Tchunks)
    subplot(2,2,i)
    hold on
    hist3([UM_T_drug{Tchunks(i)}.x_umap,UM_T_drug{Tchunks(i)}.y_umap],'CdataMode','auto','Ctrs',{-6:0.4:6 -6:0.4:6},'EdgeColor',[1 1 1],'LineWidth',0.01);
    xlim([-6,6])
    ylim([-6,6])
    view(2)
    colormap(map)
    hold off
end
%% plot umap fold enrichment drug

R = [0:0.01:1]';
R = sort(R,'descend');
G = [0:0.01:1]';
G = sort(G,'descend');
B = [0:0.01:1]';
B = sort(B,'descend');
map = [R,G,B];

binsize = {-6:0.4:6 -6:0.4:6};
Tchunks = [1,4,8,10];

TINY = 1e-6;

nonUM_drughistTo = hist3([nonUM_T_drug{Tchunks(1)}.x_umap,nonUM_T_drug{Tchunks(1)}.y_umap],'CdataMode','auto','Ctrs',binsize,'EdgeColor',[1 1 1],'LineWidth',0.01);
nonUM_drughistTend = hist3([nonUM_T_drug{Tchunks(end)}.x_umap,nonUM_T_drug{Tchunks(end)}.y_umap],'CdataMode','auto','Ctrs',binsize,'EdgeColor',[1 1 1],'LineWidth',0.01);
ratio_nonUM_drughistTo = (nonUM_drughistTo./sum(sum(nonUM_drughistTo))).*100 + TINY;
ratio_nonUM_drughistTend = (nonUM_drughistTend./sum(sum(nonUM_drughistTend))).*100 + TINY;
enriched_nonUM_drug = ratio_nonUM_drughistTend - ratio_nonUM_drughistTo;
figure(11)
surf(cell2mat(binsize(1)),cell2mat(binsize(2)),enriched_nonUM_drug','EdgeColor',[1 1 1]);
xlim([-6,6])
ylim([-6,6])
view(2)
colormap(map)
caxis([-1 1])

UM_drughistTo = hist3([UM_T_drug{Tchunks(1)}.x_umap,UM_T_drug{Tchunks(1)}.y_umap],'CdataMode','auto','Ctrs',binsize,'EdgeColor',[1 1 1],'LineWidth',0.01);
UM_drughistTend = hist3([UM_T_drug{Tchunks(end)}.x_umap,UM_T_drug{Tchunks(end)}.y_umap],'CdataMode','auto','Ctrs',binsize,'EdgeColor',[1 1 1],'LineWidth',0.01);
ratio_UM_drughistTo = (UM_drughistTo./sum(sum(UM_drughistTo))).*100 + TINY;
ratio_UM_drughistTend = (UM_drughistTend./sum(sum(UM_drughistTend))).*100 + TINY;
enriched_UM_drug = ratio_UM_drughistTend - ratio_UM_drughistTo;
figure(12)
surf(cell2mat(binsize(1)),cell2mat(binsize(2)),enriched_UM_drug','EdgeColor',[1 1 1]);
xlim([-6,6])
ylim([-6,6])
view(2)
colormap(map)
caxis([-1 1])
%% plot umap fold enrichment nondrug

R = [0:0.01:1]';
R = sort(R,'descend');
G = [0:0.01:1]';
G = sort(G,'descend');
B = [0:0.01:1]';
B = sort(B,'descend');
map = [R,G,B];

binsize = {-6:0.4:6 -6:0.4:6};
Tchunks = [1,5,10,15];

TINY = 1e-6;

nonUM_histTo = hist3([nonUM_T{Tchunks(1)}.x_umap,nonUM_T{Tchunks(1)}.y_umap],'CdataMode','auto','Ctrs',binsize,'EdgeColor',[1 1 1],'LineWidth',0.01);
nonUM_histTend = hist3([nonUM_T{Tchunks(end)}.x_umap,nonUM_T{Tchunks(end)}.y_umap],'CdataMode','auto','Ctrs',binsize,'EdgeColor',[1 1 1],'LineWidth',0.01);
ratio_nonUM_histTo = (nonUM_histTo./sum(sum(nonUM_histTo))).*100 + TINY;
ratio_nonUM_histTend = (nonUM_histTend./sum(sum(nonUM_histTend))).*100 + TINY;
enriched_nonUM = ratio_nonUM_histTend - ratio_nonUM_histTo;
figure(9)
surf(cell2mat(binsize(1)),cell2mat(binsize(2)),enriched_nonUM','EdgeColor',[1 1 1]);
xlim([-6,6])
ylim([-6,6])
view(2)
colormap(map)
caxis([-1 1])

UM_histTo = hist3([UM_T{Tchunks(1)}.x_umap,UM_T{Tchunks(1)}.y_umap],'CdataMode','auto','Ctrs',binsize,'EdgeColor',[1 1 1],'LineWidth',0.01);
UM_histTend = hist3([UM_T{Tchunks(end)}.x_umap,UM_T{Tchunks(end)}.y_umap],'CdataMode','auto','Ctrs',binsize,'EdgeColor',[1 1 1],'LineWidth',0.01);
ratio_UM_histTo = (UM_histTo./sum(sum(UM_histTo))).*100 + TINY;
ratio_UM_histTend = (UM_histTend./sum(sum(UM_histTend))).*100 + TINY;
enriched_UM = ratio_UM_histTend - ratio_UM_histTo;
figure(10)
surf(cell2mat(binsize(1)),cell2mat(binsize(2)),enriched_UM','EdgeColor',[1 1 1]);
xlim([-6,6])
ylim([-6,6])
view(2)
colormap(map)
caxis([-1 1])