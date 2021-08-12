%This script transfers segmented files from all cell types into one folder
trial1dir = '/media/phnguyen/Data2/Imaging/RawData/DiffTrack2 - processed/pos %d/';

trial1pos = 6;


unidir1 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/segment_files/';

poscount = 0;
%%
for i =1:trial1pos
    poscount = poscount +1;
    oldfilename = [trial1dir 'segment.mat'];
    oldfilename = sprintf(oldfilename,i);
    
    newfilename = sprintf([unidir1 'segment_pos_%d.mat'],poscount);
    
    copyfile(oldfilename,newfilename)
end
disp('Trial2:');disp(poscount)
poscount = 0;
