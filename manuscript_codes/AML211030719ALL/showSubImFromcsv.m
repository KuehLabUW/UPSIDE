%this script show a sample of image patches specified in gate file
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
csvfilename = 'CombinedSubstractedDir_CAT_Survivor.csv';
cd(code_dir)


%matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');
matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
cd('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat')
%%

%show image patch
num_im = 500;
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
figure(7)
montage(TotalIm),imcontrast()
cd(root_dir)


