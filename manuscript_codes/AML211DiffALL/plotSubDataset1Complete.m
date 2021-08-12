clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
datadirfile = 'SubDataset1CompleteAreaEdgeFluoCluster.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


cd(code_dir)


%% select condition values
trial = 3;
condition = 2;
%tlow = 69;
%thigh = 91;
tlow = 70;
thigh = 90;
figurenum = 5;


%% retrieve the table
rows = (datamatrix.trial==trial & datamatrix.condition==condition & datamatrix.t>tlow & datamatrix.t<thigh);
%rows = (datamatrix.trial==trial);
matrix = datamatrix(rows,:);
%matrix = datamatrix;

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

gscatter(matrix.xumap,matrix.yumap,matrix.cluster,[g0c;g1c;g2c;g3c;g4c;g5c;g6c;g7c],[],15)

%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
title('clusters')
%savefig('/home/phnguyen/Desktop/clusters.fig')
%close all
%% plot Area
figure(figurenum+1)
scatter(matrix.xumap,matrix.yumap,10,matrix.area,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-4,6])
ylim([-2,6])
title('Area')
axis('on')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/area.fig')
%close all
%% plot Ecc
figure(figurenum+2)
scatter(matrix.xumap,matrix.yumap,10,matrix.eccentricity,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-4,6])
ylim([-2,6])
title('Eccentricity')
axis('on')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/eccentricity.fig')
%close all
%% plot CD34
figure(figurenum+10)
scatter(matrix.xumap,matrix.yumap,60,log10(matrix.APC_corr),'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-4,6])
ylim([-2,6])
title('CD34 Expression')
axis('off')
colormap jet
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
caxis([0.5,2.5])
%savefig('/home/phnguyen/Desktop/CD34.fig')
%close all
%% plot CD38
figure(figurenum+4)
scatter(matrix.xumap,matrix.yumap,60,log10(matrix.PE_corr),'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-4,6])
ylim([-2,6])
title('CD38 Expression')
axis('off')
colormap jet
caxis([0.5,2.5])
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/CD38.fig')
%close all
%% plot pixvalue
figure(figurenum+5)
scatter(matrix.xumap,matrix.yumap,10,matrix.sharpvalue,'filled')
%scatter(datamatrix.xumap,datamatrix.yumap,10,categorical(datamatrix.group),'filled')
xlim([-4,6])
ylim([-2,6])
title('mean sharp value')
axis('on')
%set(gca,'Ydir','reverse')
%set(gca,'Xdir','reverse')
%savefig('/home/phnguyen/Desktop/sharpvalue.fig')
%close all