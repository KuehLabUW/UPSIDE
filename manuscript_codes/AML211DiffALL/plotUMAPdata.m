%this script show a sample of image patches specified in gate file
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
datadirfile = 'CombinedUMAPDirFluoClusterZC.csv';
datacolumn = 218;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


cd(code_dir)


%datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%% select condition values
trial = 1;
condition = 2;
%tlow = 69;
%thigh = 91;
tlow = 69;
thigh = 86;
figurenum = 5;


%% retrieve the table
rows = (datamatrix.trial==trial & datamatrix.condition==condition & datamatrix.t>tlow & datamatrix.t<thigh);
%rows = (datamatrix.trial==trial);
matrix = datamatrix(rows,:);
%matrix = datamatrix;
%% plot cluster
figure(figurenum)
%scatter(matrix.xumap,matrix.yumap,5,matrix.group,'filled')
g0c = [96 163 83]./255;
g1c = [150 50 164]./255;
g2c = [70 150 207]./255;
g3c = [222 200 63]./255;
g4c = [129 131 186]./255;
%g5c = [167 217 104]./255;%%
% % g6c = [222 83 63]./255;
% % g7c = [42 214 197]./255;%%
% % g8c = [150 137 164]./255;%%
% % g9c = [220 81 149]./255;
% % g10c = [96 163 83]./255;
% gscatter(datamatrix.xumap,datamatrix.yumap,datamatrix.group,[g0c;g1c;g2c;g3c;g4c;g5c;g6c;g7c;g8c;g9c;g10c],[],8)
gscatter(datamatrix.xumap,datamatrix.yumap,datamatrix.cluster,[g0c;g1c;g2c;g3c;g4c],[],8)
xlim([-6,8])
ylim([-6,5])
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
title('clusters')
%savefig('/home/phnguyen/Desktop/clusters.fig')
%close all
%% plot Area
figure(figurenum+1)
scatter(matrix.xumap,matrix.yumap,5,matrix.area,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-6,8])
ylim([-6,5])
title('Area')
axis('off')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/area.fig')
%close all
%% plot Ecc
figure(figurenum+2)
scatter(matrix.xumap,matrix.yumap,5,matrix.eccentricity,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-6,8])
ylim([-6,5])
title('Eccentricity')
axis('off')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/eccentricity.fig')
%close all
%% plot CD34
figure(figurenum+3)
scatter(matrix.xumap,matrix.yumap,5,log10(matrix.APC_corr),'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-6,8])
ylim([-6,5])
title('CD34 Expression')
axis('off')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
caxis([0.5,2.5])
%savefig('/home/phnguyen/Desktop/CD34.fig')
%close all
%% plot CD38
figure(figurenum+4)
scatter(matrix.xumap,matrix.yumap,5,log10(matrix.PE_corr),'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-6,8])
ylim([-6,5])
title('CD38 Expression')
axis('off')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/CD38.fig')
%close all
%% plot pixvalue
figure(figurenum+5)
scatter(matrix.xumap,matrix.yumap,5,matrix.sharpvalue,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-6,8])
ylim([-6,5])
title('mean sharp value')
axis('off')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/sharpvalue.fig')
%close all