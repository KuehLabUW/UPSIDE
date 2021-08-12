%this script show a sample of image patches specified in gate file
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';
csvfilename = 'cellsWithZ.csv';
cd(code_dir)


datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%% select condition values
trial = 1;
figurenum = 5;


%% retrieve the table
%rows = (datamatrix.trial==trial & datamatrix.condition==condition & datamatrix.t>tlow & datamatrix.t<thigh);
rows = (datamatrix.trial==trial);
matrix = datamatrix(rows,:);
%matrix = datamatrix;
%% plot cell types
figure(figurenum)
%scatter(matrix.xumap,matrix.yumap,5,matrix.group,'filled')
g0c = [42 214 197]./255;
g1c = [129 131 186]./255;
g2c = [129 131 186]./255;
g3c = [96 163 83]./255;
g4c = [70 150 207]./255;
g5c = [220 81 149]./255;%%
g6c = [222 83 63]./255;
g7c = [150 137 164]./255;%%
g8c = [222 83 63]./255;%%
g9c = [167 217 104]./255;
g10c = [167 217 104]./255;
g11c = [96 163 83]./255;
gscatter(datamatrix.xumap,datamatrix.yumap,datamatrix.group,[g0c;g1c;g2c;g3c;g4c;g5c;g6c;g7c;g8c;g9c;g10c;g11c],[],8)

title('clusters')
%savefig('/home/phnguyen/Desktop/clusters.fig')
%close all
%% plot Area
figure(figurenum+1)
scatter(matrix.xumap,matrix.yumap,8,matrix.area,'filled')
title('Area')
axis('off')

%savefig('/home/phnguyen/Desktop/area.fig')
%close all
%% plot Ecc
figure(figurenum+2)
scatter(matrix.xumap,matrix.yumap,8,matrix.eccentricity,'filled')
title('Eccentricity')
axis('off')


%savefig('/home/phnguyen/Desktop/eccentricity.fig')
%close all
%% plot pixvalue
figure(figurenum+5)
scatter(matrix.xumap,matrix.yumap,8,matrix.sharpvalue,'filled')
title('max sharp value')
axis('off')

%savefig('/home/phnguyen/Desktop/sharpvalue.fig')
%close all

%% plot latent dimension
for i = 1:5
    figure(figurenum + 5 + i)
    eval(sprintf("scatter(matrix.xumap,matrix.yumap,8,matrix.m%d,'filled')",i))
    eval(sprintf("title('m%d')",i))
end
%% plot latent dimension
for i = 1:5
    figure(figurenum + 10 + i)
    eval(sprintf("scatter(matrix.xumap,matrix.yumap,8,matrix.t%d,'filled')",i))
    eval(sprintf("title('t%d')",i))
end