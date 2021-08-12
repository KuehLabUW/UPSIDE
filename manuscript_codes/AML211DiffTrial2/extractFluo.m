clear
%This script loops through all segment.mat files in the 'segment files'
%directory and uses raw tif images to make cell patches tif files and a csv
%carrying information about each patch


pos_num = 147;

dirname.script = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrial2';
dirname.segment = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial2/segment_files';
dirname.raw_tif = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/Differentiation/';
dirname.subim_tif = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial2/SubImTexture/';
dirname.csvs = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial2/csvs/';


BF_name = 'EXPTrial2_w1Camera BF_s%d_t%d.TIF';
w2_name = 'EXPTrial2_w2LDI 640_s%d_t%d.TIF';
w3_name = 'EXPTrial2_w3LDI 555_s%d_t%d.TIF';
wSynth_name = 'EXPTrial2_w4Camera DAPI_s%d_t%d.TIF';

segfunc_name = 'cellseg120518ML';

for pos = 1:pos_num %loop through all position in segmentfile
    
    cd(dirname.segment)
    seg_filename = 'segment_pos_%d.mat';
    seg_filename = sprintf(seg_filename,pos);
    load(seg_filename)
    
    cd(dirname.script)
    
    getdata_fluo(objects,pos,dirname,segfunc_name,BF_name,wSynth_name,w2_name,w3_name)
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%')
    fprintf('done with pos %d\n',pos);
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%')
    
end
