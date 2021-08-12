% This script transfers segmented files from all cell types into one folder
% and prepare neccessary data folders

% enter directory of segment file
segment_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/CellTypes020420/CellTypes020420 - segmented/';

% enter the number of positions
pos_num = 240;

% enter the directory to store all analyzed data
data_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/CellTypes020420/';



segment_dir = [segment_dir 'pos %d/'];
mkdir([data_dir 'segment_files']);
mkdir([data_dir 'csvs']);
mkdir([data_dir 'mat']);
mkdir([data_dir 'NNData']);
mkdir([data_dir 'NNDataTexture']);
mkdir([data_dir 'SubImTexture']);
poscount = 0;
%%
for i =1:pos_num
    poscount = poscount +1;
    oldfilename = [segment_dir 'segment.mat'];
    oldfilename = sprintf(oldfilename,i);
    
    newfilename = sprintf([data_dir,'segment_files/', 'segment_pos_%d.mat'],poscount);
    
    copyfile(oldfilename,newfilename)
end
disp('completed:');disp(poscount)
poscount = 0;
