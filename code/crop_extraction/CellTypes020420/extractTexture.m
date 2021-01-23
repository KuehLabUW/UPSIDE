clear
%This script loops through all segment.mat files in the 'segment files'
%directory and uses raw tif images to make cell patches tif files and a csv
%carrying information about each patch

% enter the number of well positions
pos_num = 240;

%enter the directory of the image crop generation script
script_dir ='/media/phnguyen/Data2/Imaging/UPSIDEv1/code/crop_extraction/CellTypes020420/';
%enter the directory of the data files
data_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/CellTypes020420/';
%enter the directory of the raw brightfield images
im_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/pytorch_fnet-master/pytorch_fnet/data/CellTypes020420/';

%enter base name of MM image
basename = 'EXP2';
%enter channel name for the synthetic image
synth_name = 'w2Camera CellTrace';
%enter segmentation function's name
seg_name = 'cellseg120518MLCellTrace';

dirname.script = script_dir;
dirname.segment = [data_dir 'segment_files/'];
dirname.raw_tif = im_dir;
dirname.subim_tif = [data_dir 'SubImTexture/'];
dirname.csvs = [data_dir 'csvs/'];



BF_name = [basename '_' 'w1Camera BF' '_s%d_t%d.TIF'];
wSynth_name = [basename '_' synth_name '_s%d_t%d.TIF'];
wCellTrace_name = wSynth_name;

for pos = 1:pos_num %loop through all position in segmentfile
    
    cd(dirname.segment)
    seg_filename = 'segment_pos_%d.mat';
    seg_filename = sprintf(seg_filename,pos);
    load(seg_filename)
    
    cd(dirname.script)
    
    getdata_SubImTexture(objects,pos,dirname,BF_name,wSynth_name,wCellTrace_name,seg_name)
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%')
    fprintf('done with pos %d\n',pos);
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%')
    
end
