% script for running the segmentation
indir = {'/media/phnguyen/Data2/Imaging/UPSIDEv1/pytorch_fnet-master/pytorch_fnet/data/CellTypes020420'};
basenames = {'EXP2'};
outdir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/CellTypes020420/CellTypes020420 - segmented';

% generate parameter file for image procesing.
paramfile = 'params.mat';
makeparams(paramfile);
pipeline2(indir, basenames, outdir, paramfile);
