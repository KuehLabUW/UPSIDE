%this script validates manually pairwise tracks generated

clear all
BF_dir = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/DifferentiationTrack/EXPTrial%d_w1Camera BF_s%d_t%d.TIF';
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';
mat_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/mat/';
csvfilename = 'LIVE_tracked.csv';
cd(code_dir)

matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f');
[CORRECT,TINDEX] = checktrack(BF_dir,matrix,mat_dir,code_dir);