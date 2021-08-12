%clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/';

datadirfile = 'ClusteredTypesChosen.csv';
datacolumn = 213;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);

parse = 0;
if parse == 1
    trial = 3;
    condition = 2;
    t = 5;
    datamatrix = datamatrix(datamatrix.trial == trial & datamatrix.condition == condition & datamatrix.t == t, :);
end



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
codet(1) = {[14,22,42,24,75,86,78,57,49,95] + 1};
codet(2)= {[82,23,27,96,67] + 1};
codet(3) = {[58,21,13] + 1};
codet(4) = {[20,51,72,26,6,88,63,45,32,90,19,2,59,44,55,7,61,0,69,9,18,94] + 1};

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