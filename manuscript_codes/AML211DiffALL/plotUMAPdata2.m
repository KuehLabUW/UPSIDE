%this script show a sample of image patches specified in gate file
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


%% select condition values
trial = 1;
condition = 1;
%tlow = 69;
%thigh = 91;
tlow = 0;
thigh = 91;
figurenum = 5;


%% retrieve the table
rows = (datamatrix.trial==trial & datamatrix.condition==condition & datamatrix.t>tlow & datamatrix.t<thigh);
%rows = (datamatrix.trial==trial);
%matrix = datamatrix(rows,:);
matrix = datamatrix;

%% plot cluster
figure(figurenum)
g0c = [42 214 197]./255;
g1c = [20 81 149]./255;
g2c = [96 163 83]./255;
g3c = [200 214 197]./255;
g4c = [129 131 186]./255;
g5c = [129 0 0]./255;
g6c = [255 40 255]./255;
g7c = [255 165 0]./255;

gscatter(matrix.xumap,matrix.yumap,matrix.cluster,[g0c;g1c;g2c;g3c;g4c;g5c;g6c;g7c],[],8)

%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
title('clusters')
%savefig('/home/phnguyen/Desktop/clusters.fig')
%close all
%% plot Area
figure(figurenum+1)
scatter(matrix.xumap,matrix.yumap,5,matrix.area,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
%xlim([-6,8])
%ylim([-6,5])
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
%xlim([-6,8])
%ylim([-6,5])
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
xlim([-7,9])
ylim([-5,5])
title('CD34 Expression')
colormap jet
axis('off')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
caxis([0.5,2])
%savefig('/home/phnguyen/Desktop/CD34.fig')
%close all
%% plot CD38
figure(figurenum+4)
scatter(matrix.xumap,matrix.yumap,5,log10(matrix.PE_corr),'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
%xlim([-6,8])
%ylim([-6,5])
title('CD38 Expression')
colormap jet
axis('off')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/CD38.fig')
%close all
%% plot pixvalue
figure(figurenum+5)
scatter(matrix.xumap,matrix.yumap,5,matrix.sharpvalue,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
%xlim([-6,8])
%ylim([-6,5])
title('mean sharp value')
axis('off')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/sharpvalue.fig')
%close all