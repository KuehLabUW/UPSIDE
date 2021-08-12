%this script show a sample of image patches specified in gate file
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/';
csvfilename = 'ClusteredTypesShort.csv';
cd(code_dir)

datadirfile = 'ClusteredTypesChosen.csv';
datacolumn = 213;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
%% select condition values
trial = 1;
cluster = 7;
type = 4;


%% retrieve the table
%rows = (datamatrix.trial==trial & datamatrix.group==cluster);
rows = datamatrix.type==type;
matrix = datamatrix(rows,:);



%% how image patch
num_im = 20;
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


