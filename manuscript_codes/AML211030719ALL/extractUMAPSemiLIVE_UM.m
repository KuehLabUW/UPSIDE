clear
%this function takes in CSV files with UMAP data and put them into a
%struct file that is compatible to view with cytometry2
%need to remove numbering column of the input csv files first!
%% get data
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
umapfilename = 'CombinedSubstractedDirFluoUMAPdrug_onehot_largeLIVE2.csv';

cd(code_dir)

matrix = readtable(strcat(root_dir,umapfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f');

%read bulk csv file
matrix_nondrug = matrix(matrix.treated == 0, :);
matrix_drug = matrix(matrix.treated == 1,:);
% dirname	pos	t	cell	Xcenter	Ycenter	APC_corr	APC	PE_corr	PE	x-umap	y-umap

%% extract time info
%get raw timepoints
%timeperiods = 3/60; %Hours
timepoints = max(matrix_nondrug.t);
raw_timepoints = 1:1:timepoints;
%raw_timepoints = (raw_timepoints - raw_timepoints(1)) .* 3/60;
acq.tr = raw_timepoints;
%find timepoints available in umap file
avail_t = unique(matrix_nondrug.t);
tlist = zeros(1,timepoints);
for i = 1:1:numel(avail_t)
    tlist(avail_t(i)) = 1;
end
acq.C(2).tlist = tlist;
save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/acq.mat','acq')

%% extract time info for Drug data
%get raw timepoints
%timeperiods = 3/60; %Hours
timepoints = max(matrix_drug.t);
raw_timepoints = 1:1:timepoints;
%raw_timepoints = (raw_timepoints - raw_timepoints(1)) .* 3/60;
acq_drug.tr = raw_timepoints;
%find timepoints available in umap file
avail_t = unique(matrix_drug.t);
tlist = zeros(1,timepoints);
for i = 1:1:numel(avail_t)
    tlist(avail_t(i)) = 1;
end
acq.C(2).tlist = tlist;
save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/acq_drug.mat','acq')

%%%%%%%%%%%%% get data you want
%% get nonUM compound samples drug and non drug
matrix_nondrug_UM = matrix_nondrug(matrix_nondrug.pos > 16,:);

array_nondrug_UM = bundle_array3D(matrix_nondrug_UM,6,8,9); %get time data , xumap, yumap and put into an array format

objects = bundle_mat_forcyto2(matrix_nondrug_UM,8,9); %bundle the table into a .mat format for visualization
%%
matrix_drug_UM = matrix_drug(matrix_drug.pos > 16,:);

array_drug_UM = bundle_array3D(matrix_drug_UM,6,8,9); %get time data , xumap, yumap and put into an array format

objects_drug = bundle_mat_forcyto2(matrix_drug_UM,8,9); %bundle the table into a .mat format for visualization

%%
%add two drug and non drug structs together
for i = 1:numel(objects_drug)
    objects(end+1) = objects_drug(i);
end

%objects = bundle_mat_forcyto2([matrix_nondrug;matrix_drug]); %bundle the table into a .mat format for visualization
%figure(1)
%scatter(array_nondrug_nonUM(:,1),array_nondrug_nonUM(:,2),1,array_nondrug_nonUM(:,3),'filled')

%save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/objectSubstractedDrugNonDrug.mat','objects')



%% get time montage
Tseries = 1:20:1771;

for t = 1:numel(Tseries)
   submatrix =  matrix_nondrug_nonUM(matrix_nondrug_nonUM.t==Tseries(t),:);
   subarray = bundle_array3D(submatrix,6,8,9);
   Tmatrix(t).xumap = subarray(:,1);
   Tmatrix(t).yumap = subarray(:,2);
   Tmatrix(t).t     = subarray(:,3);
end

F(numel(Tseries)) = struct('cdata',[],'colormap',[]);
for p = 1:numel(Tseries)
    %figure(p)
    %scatter(Tmatrix(p).xumap,Tmatrix(p).yumap,3,'filled')
    %xlim([-8,10])
    %ylim([-8,10])
    %drawnow
    %F(p) = getframe;
    submatrix =  matrix_nondrug(matrix_nondrug.t==Tseries(p),:);
    objects = bundle_mat_forcyto2(submatrix);
    objects = objects(Tseries(p));
    save(sprintf('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/tseries/nodrug_noUM_onehotT%d.mat',p),'objects')
    %%keyboard
end
%% get time montage drug nondrug
tseries = 1:20:numel(objects);
p = 1;
for t = 1:20:1761
    submatrix =  matrix_nondrug_UM(matrix_nondrug_UM.t==t,:);
    subarray = bundle_array3D(submatrix,6,8,9);
    Tmatrix(t).xumap = subarray(:,1);
    Tmatrix(t).yumap = subarray(:,2);
    Tmatrix(t).t     = subarray(:,3);
    scatter(Tmatrix(t).xumap,Tmatrix(t).yumap,3,'r','filled')
    xlim([-8,6])
    ylim([-8,10])
    drawnow
    F(p) = getframe;
    p = p+1;
end
disp(p);
for t = 1:20:981
    submatrix =  matrix_drug_UM(matrix_drug_UM.t==t,:);
    subarray = bundle_array3D(submatrix,6,8,9);
    Tmatrix(t+1761).xumap = subarray(:,1);
    Tmatrix(t+1761).yumap = subarray(:,2);
    Tmatrix(t+1761).t     = subarray(:,3);
    scatter(Tmatrix(t+1761).xumap,Tmatrix(t+1761).yumap,3,'b','filled')
    xlim([-8,6])
    ylim([-8,10])
    drawnow
    F(p) = getframe;
    p = p+1;
end


