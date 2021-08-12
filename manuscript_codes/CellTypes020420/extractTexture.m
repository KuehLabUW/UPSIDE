clear
%This script loops through all segment.mat files in the 'segment files'
%directory and uses raw tif images to make cell patches tif files and a csv
%carrying information about each patch


pos_num = 240;

dirname.script = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420';
dirname.segment = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/segment_files';
dirname.raw_tif = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/CellTypes020420/';
dirname.subim_tif = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/SubImTexture/';
dirname.csvs = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/';


BF_name = 'EXP2_w1Camera BF_s%d_t%d.TIF';
wSynth_name = 'EXP2_w2Camera CellTrace_s%d_t%d.TIF';
wCellTrace_name = 'EXP2_w2Camera CellTrace_s%d_t%d.TIF';

for pos = 1:pos_num %loop through all position in segmentfile
    
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
