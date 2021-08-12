%this script show a sample of image patches specified in gate file
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';
csvfilename = 'LIVE_tracked_Area_Sharp.csv';
cd(code_dir)


datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');

%% select condition values
trial = 1;
condition = 1;
cluster = 2;


%% retrieve the table
rows = (datamatrix.trial==trial & datamatrix.condition==condition & datamatrix.cluster==cluster);
rows = (datamatrix.cluster==cluster);
matrix = datamatrix(rows,:);



%% how image patch
num_im = 100;
%num_im = numel(TotalInfo);
num = height(matrix);
patch_ind = randi([1,num],1,num_im);

TotalIm = [];
TotalIm_mask = [];

for k = 1:numel(patch_ind)
    
    tifname = string(matrix.dirname(patch_ind(k)));
    tifname_mask = char(tifname);
    tifname_mask = strcat(tifname_mask(1:end-4),'_texture.TIF');
    im = imread(tifname);
    im_mask = imread(tifname_mask);
    TotalIm = cat(3,TotalIm,im);
    TotalIm_mask = cat(3,TotalIm_mask,im_mask);
end    
%picked_im = TotalIm(:,:,patch_ind);
figure(8)
montage(TotalIm),imcontrast()
cd(root_dir)

figure(9)
montage(TotalIm_mask),imcontrast()


