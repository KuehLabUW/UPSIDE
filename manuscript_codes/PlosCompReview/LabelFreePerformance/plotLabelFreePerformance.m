clear
%this script evaluates the perfromance of a prediction channel by
%calculating the pearson coefficient between predicted and real
%fluorescence images

rootdir = '/media/phnguyen/Data2/Imaging/CellMorph/code/PlosCompReview/LabelFreePerformance';
cellnumlist = [250,500,1000,2000,13000,26000,50000,74000,98000];
listCorr = zeros(1800,numel(cellnumlist));
meanCorr = [];
stdCorr = [];
count = 1;
for cellnum = cellnumlist
    %%
    datadir = sprintf('/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/results/3d/TrainingImageWithCellNum%d/test/',cellnum);
    predictim_tiffname = sprintf('prediction_TrainingImageWithCellNum%d.tiff',cellnum);
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
        
        %keyboard
    end
    
    mean_corr = mean(pearson_corr);
    std_corr = std(pearson_corr);
    
    meanCorr = [meanCorr mean_corr];
    stdCorr = [stdCorr std_corr];
    
    
    %listCorr(:,count) = pearson_corr';
    count = count + 1;
end

%% plot cellnum vs performance
num = [];
imnum = [];
for cellnum = cellnumlist
    og_csv = sprintf('/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/TrainingImageWithCellNum%d.csv',cellnum);
    og_matrix = readtable(og_csv,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', ['%s' '%s' '%f']);
    num = [num sum(og_matrix.cellnum(:))];
    imnum = [imnum height(og_matrix)];
end

errorbar(cellnumlist,meanCorr,stdCorr./sqrt(353))
ylabel('mean Pearson Correlation between predicted and real images')
xlabel('cell number')