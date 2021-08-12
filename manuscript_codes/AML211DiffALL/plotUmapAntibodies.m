clear all
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'combined_CD_tube_1_AML211.csv';

datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%keyboard
figure(1)

condition = 0;  cname = 'UM condition';
tname = 'CD34+CD38-';

submatrix = datamatrix(datamatrix.condition == condition,:);

cmax = 1.5;
cmin = 0;
for i = 0:8
   subplot(3,3,i+1)
   scatter(submatrix.xumap,submatrix.yumap,4,table2array(submatrix(:,20+i)),'filled')
   xlim([-10,15])
   ylim([-2,10])
   colormap('jet')
   caxis([cmin,cmax])
   colorbar()
   t = char(datamatrix.Properties.VariableNames(20+i));
   title(t(4:end))
end

sgtitle(sprintf("%s AML211 after 3 days culture stained with Tube 1 Ab in %s",string(tname),string(cname)))


figure(2)

condition = 1;  cname = ' no UM condition';
tname = 'CD34+CD38-';

submatrix = datamatrix(datamatrix.condition == condition,:);

for i = 0:8
   subplot(3,3,i+1)
   scatter(submatrix.xumap,submatrix.yumap,4,table2array(submatrix(:,20+i)),'filled')
   xlim([-10,15])
   ylim([-2,10])
   colormap('jet')
   caxis([cmin,cmax])
   colorbar()
   t = char(datamatrix.Properties.VariableNames(20+i));
   title(t(4:end))
end

sgtitle(sprintf("%s AML211 after 3 days culture stained with Tube 1 Ab in %s",string(tname),string(cname)))

%%

datadirfile = 'combined_CD_tube_2_AML211.csv';

datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');

figure(3)

condition = 0;  cname = 'UM condition';
tname = 'CD34+CD38-';

submatrix = datamatrix(datamatrix.condition == condition,:);


for i = 0:4
   subplot(3,3,i+1)
   scatter(submatrix.xumap,submatrix.yumap,4,table2array(submatrix(:,20+i)),'filled')
   xlim([-10,10])
   ylim([-5,8])
   colormap('jet')
   caxis([cmin,cmax])
   colorbar()
   t = char(datamatrix.Properties.VariableNames(20+i));
   title(t(4:end))
end

sgtitle(sprintf("%s AML211 after 3 days culture stained with Tube 2 Ab in %s",string(tname),string(cname)))


figure(4)

condition = 1;  cname = ' no UM condition';
tname = 'CD34+CD38-';

submatrix = datamatrix(datamatrix.condition == condition,:);

for i = 0:4
   subplot(3,3,i+1)
   scatter(submatrix.xumap,submatrix.yumap,4,table2array(submatrix(:,20+i)),'filled')
   xlim([-10,10])
   ylim([-5,8])
   colormap('jet')
   caxis([cmin,cmax])
   colorbar()
   t = char(datamatrix.Properties.VariableNames(20+i));
   title(t(4:end))
end

sgtitle(sprintf("%s AML211 after 3 days culture stained with Tube 2 Ab in %s",string(tname),string(cname)))


% figure(3)
% 
% condition = 1;  cname = 'no UM condition';
% type = 2; tname = 'CD34-CD38+';
% 
% submatrix = datamatrix(datamatrix.condition == condition & datamatrix.type == type,:);
% 
% for i = 0:8
%    subplot(3,3,i+1)
%    scatter(submatrix.xumap,submatrix.yumap,4,table2array(submatrix(:,21+i)),'filled')
%    xlim([-15,15])
%    ylim([-15,15])
%    colormap('jet')
%    caxis([cmin,cmax])
%    colorbar()
%    title(string(submatrix.Properties.VariableNames(21+i)))
% end
% 
% sgtitle(sprintf("%s after 3 days culture in %s",string(tname),string(cname)))
% 
% figure(4)
% 
% condition = 2;  cname = 'UM condition';
% type = 2; tname = 'CD34-CD38+';
% 
% submatrix = datamatrix(datamatrix.condition == condition & datamatrix.type == type,:);
% 
% for i = 0:8
%    subplot(3,3,i+1)
%    scatter(submatrix.xumap,submatrix.yumap,4,table2array(submatrix(:,21+i)),'filled')
%    xlim([-15,15])
%    ylim([-15,15])
%    colormap('jet')
%    caxis([cmin,cmax])
%    colorbar()
%    title(string(submatrix.Properties.VariableNames(21+i)))
% end
% 
% sgtitle(sprintf("%s after 3 days culture in %s",string(tname),string(cname)))