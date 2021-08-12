clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'combined_CD_tube_1_HSC1_noMFI.csv';

datacolumn = 32;
text = [];
for i = 1:datacolumn
    text = [text ' %f'];
end

datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', text);
%%
figure(1)

cmax = 5;
cmin = 0;
for i = 0:8
   subplot(3,3,i+1)
   scatter(datamatrix.xumap,datamatrix.yumap,4,table2array(datamatrix(:,21+i)),'filled')
   xlim([-15,15])
   ylim([-10,12])
   colormap('jet')
   h = colorbar;
   %ylabel(h, 'gene expression score')
   caxis([cmin,cmax])
   colorbar()
   t = char(datamatrix.Properties.VariableNames(21+i));
   title(t(4:end))
end

sgtitle("HSC-GCSF1-Tube1 log fluorescent intensity")
