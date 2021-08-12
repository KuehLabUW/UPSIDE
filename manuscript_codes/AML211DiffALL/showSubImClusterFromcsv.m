% this script lets you specify a list of features and a biological feature
% of interest and it will genera example images

clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211Total/';


cd(code_dir)
% enter properties name
prop_name_ini = 'APC_corr'; % 'APC_corr','PE_corr','distance'

%% decide which data to load
if strcmp(prop_name_ini,'distance') == 1
    root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';
    datadirfile = 'cluster_tracked_dist_area_dist_cond.csv';
    rawtif(1)= {'/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/DifferentiationTrack1/'};
    rawtif(2)= {'/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/DifferentiationTrack2/'};
    datacolumn = 217;
    Text = ['%s'];
    for i = 1:datacolumn
        Text = [Text ' %f'];
    end
    matrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
    matrix = matrix(matrix.pcell~=0,:);
else
    root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
    datadirfile = 'Dataset1CompleteAreaEdgeFluoClusterCenter.csv';
    raw_tif = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/Differentiation/';
    datacolumn = 219;
    Text = ['%s'];
    for i = 1:datacolumn
        Text = [Text ' %f'];
    end
    
    
    matrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
    matrix = matrix(matrix.trial ~= 2,:);
end


%% select condition values
trial = 1;
condition = 1;
cluster = 8;


%% retrieve the table
rows = (matrix.trial==trial & matrix.condition==condition & matrix.cluster==cluster);
rows = (matrix.cluster==cluster);
matrix = matrix(rows,:);



%% how image patch
num_im = 100;
%num_im = numel(TotalInfo);
num = height(matrix);
patch_ind = randi([1,num],1,num_im);

TotalIm = [];


for k = 1:numel(patch_ind)
    
    tifname = string(matrix.dirname(patch_ind(k)));
    %disp(tifname);
    im = imread(tifname);
    TotalIm = cat(3,TotalIm,im);
end    
%picked_im = TotalIm(:,:,patch_ind);
figure(8)
montage(TotalIm),imcontrast()
cd(root_dir)


