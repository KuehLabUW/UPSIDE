% this script allows you to specify a latent feature to visualize using VAE
% decoder

clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211Total/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';

datadirfile = 'cluster_tracked_dist_area_dist_cond.csv';
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
idxM = [69, 15, 19, 26, 63, 46, 17, 61, 24, 53, 62, 21, 55, 85, 18,  4, 92, 76, 87, 75, 58, 70, 31,  1, 80, 81, 27,  7, 47, 23, 11, 30, 77, 13, 5, 16, 38, 45, 99, 51]+1;
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
csvwrite(strcat(root_dir,'Mean_Mask_subgate_scanDistance.csv'),synbarcodeM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var_range = 0:7.5:15;
idxT = [22, 66, 94, 74, 28, 51, 64, 79, 61, 13, 60, 78, 32, 47, 40, 68, 75, 35, 21, 58, 65, 99, 17, 24, 33, 77, 82, 53,  9, 49, 29, 48,  6, 93, 63, 54, 81,  0, 45,  4]+1;
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
csvwrite(strcat(root_dir,'Mean_Texture_subgate_scanDistance.csv'),synbarcodeM)