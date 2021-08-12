% script for running the
indir = {'/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/CellTypeTrain112319'};
basenames = {'EXP2'};
outdir = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LabelFreePerformance/CellTypeTrain112319 - processed';

% generate parameter file for image procesing.
paramfile = 'params.mat';
makeparams(paramfile);
pipeline2(indir, basenames, outdir, paramfile);
