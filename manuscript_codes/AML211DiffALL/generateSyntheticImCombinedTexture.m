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
codet(1) = {[58,49,68,65,29,6,99,47,17,78,75,40,22,66,74,13,26,79,51,28,94,64,60,35,33] + 1};
codet(2)= {[81,53,21,77,24,61] + 1};
codet(3) = {[4,54,48,93,45,0,63,82,9] + 1};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var_range = 0:5:30;
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
csvwrite(strcat(root_dir,'latent_z_100_VAE_Texture_subgate_scanGroupT.csv'),synbarcodeM)