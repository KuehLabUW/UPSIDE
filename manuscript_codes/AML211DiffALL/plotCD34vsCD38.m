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
matrix = datamatrix(rows,:);
%matrix = datamatrix;

%% plot CD34 vs CD38
for c =1:8
    figure(c)
    submatrix = matrix(matrix.cluster==c,:);
    H = hist3([log10(submatrix.PE_corr+1),log10(submatrix.APC_corr+1)],'CdataMode','auto','edges',{0:0.1:4 0:0.1:3});
    hist3([log10(submatrix.PE_corr+1),log10(submatrix.APC_corr+1)],'CdataMode','auto','edges',{0:0.1:4 0:0.1:3});
    xlabel('logCD34')
    ylabel('logCD38')
    colorbar()
    colormap(jet(256))
    caxis([0 max(H(:))-max(H(:))*0.2]);
    view(2)
    
end
%% for all cells
H = hist3([log10(matrix.PE_corr+1),log10(matrix.APC_corr+1)],'CdataMode','auto','edges',{0:0.1:4 0:0.1:3});
hist3([log10(matrix.PE_corr+1),log10(matrix.APC_corr+1)],'CdataMode','auto','edges',{0:0.1:4 0:0.1:3});
xlabel('logCD34')
ylabel('logCD38')
colorbar()
colormap(jet(256))
caxis([0 max(H(:))-max(H(:))*0.2]);
view(2)
%% Plot CD34 CD38 fraction
CD34thresh = 1.5;
CD38thresh = 2.0;

ONOFFmatrix = matrix(matrix.APC_corr > 10^(CD34thresh) & matrix.PE_corr < 10^(CD38thresh),:);
OFFONmatrix = matrix(matrix.APC_corr < 10^(CD34thresh) & matrix.PE_corr > 10^(CD38thresh),:);
ONONmatrix = matrix(matrix.APC_corr > 10^(CD34thresh) & matrix.PE_corr > 10^(CD38thresh),:);

ONOFF = [];
OFFON = [];
ONON = [];
for c =[1,3,5,6,7,8,4,2]
    ONOFF = [ONOFF height(ONOFFmatrix(ONOFFmatrix.cluster==c,:))];
    OFFON = [OFFON height(OFFONmatrix(OFFONmatrix.cluster==c,:))];
    ONON = [ONON height(ONONmatrix(ONONmatrix.cluster==c,:))];
end
y = [ONOFF./sum(ONOFF);OFFON./sum(OFFON);ONON./sum(ONON)];
bar(y,'stack')

    