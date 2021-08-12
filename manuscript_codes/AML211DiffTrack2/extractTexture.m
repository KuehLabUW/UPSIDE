clear
%This script loops through all segment.mat files in the 'segment files'
%directory and uses raw tif images to make cell patches tif files and a csv
%carrying information about each patch


pos_num = 6;

dirname.script = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack2';
dirname.segment = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/segment_files';
dirname.raw_tif = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/DifferentiationTrack2/';
dirname.subim_tif = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/SubImTexture/';
dirname.csvs = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/csvs/';


BF_name = 'EXPTrial2_w1Camera BF_s%d_t%d.TIF';
wSynth_name = 'EXPTrial2_w2Camera DAPI_s%d_t%d.TIF';
wCellTrace_name = 'EXPTrial2_w3Camera CellTrace_s%d_t%d.TIF';

for pos = 1%:pos_num %loop through all position in segmentfile
    
    cd(dirname.segment)
    seg_filename = 'segment_pos_%d.mat';
    seg_filename = sprintf(seg_filename,pos);
    load(seg_filename)
    
    cd(dirname.script)
    
    getdata_SubImTexture(objects,pos,dirname,BF_name,wSynth_name,wCellTrace_name)
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%')
    fprintf('done with pos %d\n',pos);
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%')
    
end
