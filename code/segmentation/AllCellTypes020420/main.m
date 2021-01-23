% script for running the 
indir = {'/data/kueh/060117 - Bcl11b-YFP-RFP-CFP'};
basenames = {'exp1'}
outdir = '/data/kueh/060117 - Bcl11b-YFP-RFP-CFP ANALYZED/';

% generate parameter file for image procesing.
paramfile = 'params.mat';
makeparams(paramfile);
pipeline(indir, basenames, outdir, paramfile);