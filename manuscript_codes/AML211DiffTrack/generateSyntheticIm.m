% this script allows you to specify a latent feature to visualize using VAE
% decoder

clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';

datadirfile = 'CombinedUMAPDirFluoClusterTCdist.csv';
datacolumn = 216;
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
var_range = 0:1:10;
idxM = [20,90,18,53,70,61];
count = 1;
for i = idxM+1
    for v = 1:numel(var_range)
        %keyboard
        newbarcode = codeM(1,:);
        newbarcode(i) = newbarcode(i) + var_range(v).*codeMstd(i);
        synbarcodeM(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'latent_z_100_VAE_Mask_subgate_scanDist.csv'),synbarcodeM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var_range = 0:1:10;
idxT = [102,134,122,190,110,101]-100;
count = 1;
for i = idxT+1
    for v = 1:numel(var_range)
        %keyboard
        newbarcode = codeT(1,:);
        newbarcode(i) = newbarcode(i) + var_range(v).*codeTstd(i);
        synbarcodeM(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'latent_z_100_VAE_Texture_subgate_scanDist.csv'),synbarcodeM)