clear
%this script evaluates the perfromance of a prediction channel by
%calculating the pearson coefficient between predicted and real
%fluorescence images

rootdir = '/media/phnguyen/Data2/Imaging/CellMorph/code/ModelPerformance/';
%%
datadir = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/results/3d/AML211080319CellTracetrain/test/';
predictim_tiffname = 'prediction_AML211080319CellTracetrain.tiff';
realim_tiffname = 'target.tiff';
%%%%%%get names of all files in datadir
files = dir(datadir);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

%get pearson corr from each im pair and calculate the mean
pearson_corr = [];
for i = 3:numel(subFolders)
    realim_name = [datadir subFolders(i).name '/' realim_tiffname];
    fakeim_name = [datadir subFolders(i).name '/' predictim_tiffname];
    
    realim = imread(realim_name);
    fakeim = imread(fakeim_name);
    
    pearson_corr = [pearson_corr getPearsonCorr(realim,fakeim)];
    
end

mean_corr = mean(pearson_corr);
std_corr = std(pearson_corr);
%%
%%%%%%get names of background files
datadir_raw = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/AML211080319Training/';
basename = 'EXP3';
positions = 99:1:108;
timepoints = 1:1:14;
imdim = 1080;

control_ims = zeros(imdim,imdim,numel(positions)*numel(timepoints));
count = 0;
for i = 1:numel(positions)
    for j = 1:numel(timepoints)
        count = count + 1;
        control_ims (:,:,count) = imread([datadir_raw basename sprintf('_w2LDI 405_s%d_t%d.TIF',positions(i),timepoints(j))]);
    end
end

%calculates mean variance square of the background images <N^2>
Var_control_ims = [];
for i = 1: count
    subvar = var(control_ims(:,:,i),0,'all');
    Var_control_ims = [Var_control_ims subvar];
end
mean_Var_ctrl = mean(Var_control_ims,'all');

%%
%%%%%%get names of fluorescence files
datadir_raw = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/AML211080319Training/';
basename = 'EXP3';
positions = 1:1:49;
timepoints = 1:1:14;
imdim = 1080;

fluo_ims = zeros(imdim,imdim,numel(positions)*numel(timepoints));
count = 0;
for i = 1:numel(positions)
    for j = 1:numel(timepoints)
        count = count + 1;
        fluo_ims (:,:,count) = imread([datadir_raw basename sprintf('_w2LDI 405_s%d_t%d.TIF',positions(i),timepoints(j))]);
    end
end
%calculates mean variance square of the fluorescence images <T^2>
Var_real_ims = [];
for i = 1: count
    
    subvar = var(fluo_ims(:,:,i),0,'all');
    Var_real_ims = [Var_real_ims subvar];  
end
mean_Var_real = mean(Var_real_ims,'all');


%%
%calulate mean variance square of the predicted images <S^2>
mean_Var_fake = mean_Var_real - mean_Var_ctrl;

%calculate upper corr estimate
SNR = mean_Var_fake/mean_Var_ctrl;
Cmax = sqrt(SNR/(1+SNR));

%%
disp('Pearson_corr_mean: '); disp(mean_corr);
disp('Pearson_corr_std: '); disp(std_corr);
disp('upper estimate: '); disp(Cmax);
