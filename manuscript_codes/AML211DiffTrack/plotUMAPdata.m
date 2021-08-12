%this script show a sample of image patches specified in gate file
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';
csvfilename = 'LIVE_tracked_Area_Sharp.csv';
cd(code_dir)


datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%% select condition values
trial = 1;
condition = 1;
%tlow = 69;
%thigh = 91;
tlow = 0;
thigh = 1800;
figurenum = 5;


%% retrieve the table
%rows = (datamatrix.trial==trial & datamatrix.condition==condition & datamatrix.t>tlow & datamatrix.t<thigh);
rows = (datamatrix.trial==trial);
matrix = datamatrix(rows,:);
%matrix = datamatrix;
%% plot cluster
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

%xlim([-6,6])
%ylim([-5,5])
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
title('clusters')
camroll(90)
savefig('/home/phnguyen/Desktop/clusters.fig')
%close all
%% plot Area
figure(figurenum+1)
scatter(matrix.xumap,matrix.yumap,5,matrix.area,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
%xlim([-6,6])
%ylim([-5,5])
title('Area')
axis('off')
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
camroll(90)
savefig('/home/phnguyen/Desktop/area.fig')
%close all
%% plot Ecc
figure(figurenum+2)
scatter(matrix.xumap,matrix.yumap,5,matrix.eccentricity,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
%xlim([-6,6])
%ylim([-5,5])
title('Eccentricity')
axis('off')
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
camroll(90)
savefig('/home/phnguyen/Desktop/eccentricity.fig')
%close all
%% plot pixvalue
figure(figurenum+5)
scatter(matrix.xumap,matrix.yumap,5,matrix.sharpvalue,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
%xlim([-6,6])
%ylim([-5,5])
title('mean sharp value')
axis('off')
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
camroll(90)
savefig('/home/phnguyen/Desktop/sharpvalue.fig')
%close all