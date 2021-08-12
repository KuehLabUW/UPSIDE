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

%% choose starting image to the average over all images
features = [];
for i = 1:100
    eval(sprintf('features = [features,datamatrix.m%d];',i-1));
end

for i = 1:100
    eval(sprintf('features = [features,datamatrix.t%d];',i-1));
end

codeM = mean(features(:,1:100),1);
codeT = mean(features(:,101:200),1);
codeMstd = std(features(:,1:100),0,1);
codeTstd = std(features(:,101:200),0,1);
%%
codet = {};
count = 0;
for c = 1:39
    %% load grouped features
    load(sprintf('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/ClusterScan/Clustermemberset%d.csv',c))
    
    eval(sprintf('Clustermemberset = Clustermemberset%d;',c))
    for i = 1:size(Clustermemberset,1)
        row = Clustermemberset(i,:);
        row = row(row <2000);
        count = count +1;
        codet(count) = {row + 1};  
    end
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var_range = 0:7.5:15;
count = 1;
for i = 1:numel(codet)
    for v = 1:numel(var_range)
        locset = sort(cell2mat(codet(i)),'ascend');
        newbarcode = codeT(1,:);
        newbarcode(locset) = newbarcode(locset) + var_range(v);
        synbarcodeM(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'latent_z_100_VAE_Texture_subgate_scanGroupTALL.csv'),synbarcodeM)