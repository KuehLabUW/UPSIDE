% this script allows you to specify a latent feature to visualize using VAE
% decoder

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

parse = 0;
if parse == 1
    trial = 3;
    condition = 2;
    t = 5;
    datamatrix = datamatrix(datamatrix.trial == trial & datamatrix.condition == condition & datamatrix.t == t, :);
end

cluster_condition = 0;
if cluster_condition ~= 0
    datamatrix = datamatrix(datamatrix.cluster == cluster_condition,:);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%var_range = 0:0.5:1.5;
var_range = -10:5:10;
idxM = [87, 27, 53, 58, 81, 92, 13, 31, 85, 4, 61, 7, 18, 75, 21, 23, 38, 30, 45, 46, 76, 99, 11, 24, 51, 16, 5, 77, 62, 19, 55, 1, 47, 80, 63, 17, 52, 25, 98, 33]+1;
count = 1;
for i = idxM
    for v = 1:numel(var_range)
        %keyboard
        newbarcode = codeM(1,:);
        newbarcode(i) = newbarcode(i) + var_range(v).*codeMstd(i);
        synbarcodeM(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'Mean_Mask_subgate_scanCD34_negative.csv'),synbarcodeM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var_range = -15:7.5:15;
idxT =[45, 0, 54, 81, 53, 63, 77, 24, 4, 93, 21, 9, 6, 82, 48, 17, 58, 33, 49, 68, 65, 47, 29, 99, 40, 78, 79, 75, 61, 13, 51, 66, 74, 26, 22, 94, 28, 35, 60, 64]+1;
count = 1;
for i = idxT
    for v = 1:numel(var_range)
        %keyboard
        newbarcode = codeT(1,:);
        newbarcode(i) = newbarcode(i) + var_range(v).*codeTstd(i);
        synbarcodeM(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'Mean_Texture_subgate_scanCD34_negative.csv'),synbarcodeM)