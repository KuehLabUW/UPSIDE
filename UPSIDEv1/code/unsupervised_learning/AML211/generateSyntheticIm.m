% this script allows you to specify a latent feature to visualize using VAE
% decoder

clear
%%
%%%%%%%%%% Enter script's inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enter the code directory
code_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/code/AML211/unsupervised_learning/';
% enter the directory for the csv file containing barcode information
root_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/code/AML211/csvs/';
% enter the name of the summary csv file
datadirfile = 'combined_UMAP_cluster_z.csv';
% enter the number of properties (features+latent dims) in csvfile
datacolumn = 217;
% enter the mask feature list in brackets
idxM = [0:99];
% enter the texture feature list in brackets
idxT = [0:99];
% enter the output csv file name
outfile = 'decoded_features.csv';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

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

% %% randomly choose a cell latent var
% total_cell_number = size(datamatrix,1);
% chosen_i = randi(total_cell_number);

% %% generate syn images
%
% features = [];
% for i = 1:100
%     eval(sprintf('features = [features,datamatrix.m%d];',i));
% end
%
% for i = 1:100
%     eval(sprintf('features = [features,datamatrix.t%d];',i));
% end
%
% codeM = features(chosen_i,1:100);
% codeT = features(chosen_i,101:200);

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
var_range = 0:5:10;
count = 1;
for i = idxM+1 % +1 because matlab has 1 indexing instead of 0
    for v = 1:numel(var_range)
        %keyboard
        newbarcode = codeM(1,:);
        newbarcode(i) = newbarcode(i) + var_range(v).*codeMstd(i);
        synbarcodeM(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'Mask_',outfile),synbarcodeM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var_range = 0:7.5:15;
count = 1;
for i = idxT+1 %+1 because matlab has 1 indexing instead of 0
    for v = 1:numel(var_range)
        %keyboard
        newbarcode = codeT(1,:);
        newbarcode(i) = newbarcode(i) + var_range(v).*codeTstd(i);
        synbarcodeM(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'Texture_',outfile),synbarcodeM)
