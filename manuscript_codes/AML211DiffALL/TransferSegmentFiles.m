%This script transfers segmented files from all cell types into one folder
trial1dir = '/media/phnguyen/Data2/Imaging/RawData/DifferentiationTrial1 - processed/pos %d/';
trial2dir = '/media/phnguyen/Data2/Imaging/RawData/DifferentiationTrial2 - processed/pos %d/';
trial3dir = '/media/phnguyen/Data2/Imaging/RawData/DifferentiationTrial3 - processed/pos %d/';

trial1pos = 32;
trial2pos = 147;
trial3pos = 147;

unidir1 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial1/segment_files/';
unidir2 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial2/segment_files/';
unidir3 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial3/segment_files/';

poscount = 0;
%%
for i =1:trial1pos
    poscount = poscount +1;
    oldfilename = [trial1dir 'segment.mat'];
    oldfilename = sprintf(oldfilename,i);
    
    newfilename = sprintf([unidir1 'segment_pos_%d.mat'],poscount);
    
    copyfile(oldfilename,newfilename)
end
disp('Trial1:');disp(poscount)
poscount = 0;
%%
for i =1:trial2pos
    poscount = poscount +1;
    oldfilename = [trial2dir 'segment.mat'];
    oldfilename = sprintf(oldfilename,i);
    
    newfilename = sprintf([unidir2 'segment_pos_%d.mat'],poscount);
    
    copyfile(oldfilename,newfilename)
end
disp('Trial2:');disp(poscount)
poscount = 0;
%%
for i =1:trial3pos
    poscount = poscount +1;
    oldfilename = [trial3dir 'segment.mat'];
    oldfilename = sprintf(oldfilename,i);
    
    newfilename = sprintf([unidir3 'segment_pos_%d.mat'],poscount);
    
    copyfile(oldfilename,newfilename)
end
disp('Trial3:');disp(poscount)
