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

cluster_condition = 6;
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
var_range = 0:5:50;
idxM = [13]+1;
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
csvwrite(strcat(root_dir,'APC_Mask_subgate_scan13.csv'),synbarcodeM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% var_range = 0:5:50;
% idxT = [179]-100+1;
% count = 1;
% for i = idxT
%     for v = 1:numel(var_range)
%         %keyboard
%         newbarcode = codeT(1,:);
%         newbarcode(i) = newbarcode(i) + var_range(v).*codeTstd(i);
%         synbarcodeM(count,:) = newbarcode;
%         count = count + 1;
%     end
% end
% csvwrite(strcat(root_dir,'PE_Texture_subgate_scan79.csv'),synbarcodeM)