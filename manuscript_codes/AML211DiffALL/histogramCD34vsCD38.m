
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

trial = 3;

matrix = datamatrix(datamatrix.trial == trial,:);

APC_log = log10(matrix.APC_corr + 1);
PE_log = log10(matrix.PE_corr + 1);

hist(APC_log,300);
figure()
hist(PE_log,300);
