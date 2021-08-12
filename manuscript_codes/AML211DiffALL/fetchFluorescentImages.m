%This script returns cells from a specific cluster and their fluorescent
%pictures

%% get datamatrix
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
csvfilename = 'CombinedMaskDirFluoClusterAreaTsharp.csv';
cd(code_dir)

datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');

%% extract cluster
cluster = 0;
trial = 1;
rows = (datamatrix.group == cluster & datamatrix.trial == trial);
matrix = datamatrix(rows,:);

%% randomly get a index of a few cells in dataset
num_im = 1;
[numrow,numcol] = size(matrix);
patch_ind = randi([1,numrow],1,num_im);

%% get pictures for those cells
w1_name = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/Differentiation/EXPTrial%d_w1Camera BF_s%d_t%d.TIF';
w2_name = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/Differentiation/EXPTrial%d_w2LDI 640_s%d_t%d.TIF';
w3_name = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/Differentiation/EXPTrial%d_w3LDI 555_s%d_t%d.TIF';

TotalIm_BF = [];
TotalIm_CD34 = [];
TotalIm_CD38 = [];
for i = 1:numel(patch_ind)
    % first get trial, pos, t information and fetch the raw image
    trial = matrix.trial(patch_ind(i));
    pos = matrix.pos(patch_ind(i));
    t = matrix.t(patch_ind(i));
    im = imread(sprintf(w1_name,trial,pos,t));
    APC_im = imread(sprintf(w2_name,trial,pos,t));
    PE_im = imread(sprintf(w3_name,trial,pos,t));
    % now get the location of the cell and grab the cell patches
    s_Center = [round(matrix.Xcenter(patch_ind(i))),round(matrix.Ycenter(patch_ind(i)))]; %(X,Y)
    s_Xlength = 64;
    s_Ylength = 64;
    s_TopLeft = [s_Center(1) - s_Xlength/2,s_Center(2) - s_Ylength/2];
    subim_w1 = im(s_TopLeft(2):s_TopLeft(2)+s_Ylength,s_TopLeft(1):s_TopLeft(1)+s_Xlength);
    subim_w2 = APC_im(s_TopLeft(2):s_TopLeft(2)+s_Ylength,s_TopLeft(1):s_TopLeft(1)+s_Xlength);
    subim_w3 = PE_im(s_TopLeft(2):s_TopLeft(2)+s_Ylength,s_TopLeft(1):s_TopLeft(1)+s_Xlength);
    
    % adjust fluorescent level
    subim_w2 = imadjust(double(subim_w2)./10^5,[100/10^5,10^4/10^5]);
    subim_w3 = imadjust(double(subim_w3)./10^5,[100/10^5,10^4/10^5]);
    
    % Add each patch into a stack
    TotalIm_BF = cat(3,TotalIm_BF,subim_w1);
    TotalIm_CD34 = cat(3,TotalIm_CD34,subim_w2);
    TotalIm_CD38 = cat(3,TotalIm_CD38,subim_w3);
end

%% show the images
figure(1)
montage(TotalIm_BF),imcontrast()
figure(10)
montage(TotalIm_CD34),imcontrast()
figure(20)
montage(TotalIm_CD38),imcontrast()