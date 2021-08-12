clear
%this function takes in CSV files with UMAP data and put them into a
%struct file that is compatible to view with cytometry2
%need to remove numbering column of the input csv files first!
%% get data
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack2/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/csvs/';

umapfilename = 'CombinedDirUMAP_Mask.csv';
%umapfilename = 'CombinedUMAPDirFluoClusterT.csv';
cd(code_dir)


%read bulk csv file

matrix = readtable(strcat(root_dir,umapfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f');


% dirname	pos	t	cell	Xcenter	Ycenter	APC_corr	APC	PE_corr	PE	x-umap	y-umap

%% extract time info
%get raw timepoints
%timeperiods = 3/60; %Hours
timepoints = max(matrix.t);
raw_timepoints = 1:1:timepoints;
%raw_timepoints = (raw_timepoints - raw_timepoints(1)) .* 3/60;
acq.tr = raw_timepoints;
%find timepoints available in umap file
avail_t = unique(matrix.t);
tlist = zeros(1,timepoints);
for i = 1:1:numel(avail_t)
    tlist(avail_t(i)) = 1;
end
acq.C(2).tlist = tlist;
save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/mat/acqMask.mat','acq')

%%%%%%%%%%%%% get data you want
%% get UM and nonUM compound samples

objects = bundle_mat_forcyto2(matrix,8,9); %bundle the table into a .mat format for visualization

save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/mat/objects_T.mat','objects')



