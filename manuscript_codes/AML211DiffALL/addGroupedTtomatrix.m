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
T1 = 113+[58,49,68,65,29,6,99,47,17,78,75,40,22,66,74,13,26,79,51,28,94,64,60,35,33];
T2 = 113+[81,53,21,77,24,61];
T3 = 113+[4,54,48,93,45,0,63,82,9];

T1all = [];
T2all = [];
T3all = [];
for i = 1:height(datamatrix)
    T1all = [T1all mean(table2array(datamatrix(i,T1)))];
    T2all = [T2all mean(table2array(datamatrix(i,T2)))];
    T3all = [T3all mean(table2array(datamatrix(i,T3)))];
    
end
%%
datamatrix.T1 = T1all';
datamatrix.T2 = T2all';
datamatrix.T3 = T3all';

%%
writetable(datamatrix,strcat(root_dir,'Dataset1CompleteAreaEdgeFluoClusterGroupT.csv'))


