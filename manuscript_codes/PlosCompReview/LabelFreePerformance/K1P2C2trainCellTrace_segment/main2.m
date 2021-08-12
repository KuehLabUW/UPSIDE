% script for running the
indir = {'/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/K1P2C2trainCellTrace'};
basenames = {'EXP'};
outdir = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/K1P2C2trainCellTrace - processed';

% generate parameter file for image procesing.
paramfile = 'params.mat';
makeparams(paramfile);
pipeline2(indir, basenames, outdir, paramfile);
