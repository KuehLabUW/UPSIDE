%this code combines csv file chunks that comes out of the classifier
LIVEfilename1 = '/home/phnguyen/Documents/NeuralNetWorkAML211/test_LIVE_LargeMaskWatershed_p1.csv';
LIVEfilename2 = '/home/phnguyen/Documents/NeuralNetWorkAML211/test_LIVE_LargeMaskWatershed_p2.csv';
LIVEfilename3 = '/home/phnguyen/Documents/NeuralNetWorkAML211/test_LIVE_LargeMaskWatershed_p3.csv';
LIVEfilename4 = '/home/phnguyen/Documents/NeuralNetWorkAML211/test_LIVE_LargeMaskWatershed_p4.csv';

DEADfilename1 = '/home/phnguyen/Documents/NeuralNetWorkAML211/test_DEAD_LargeMaskWatershed_p1.csv';
DEADfilename2 = '/home/phnguyen/Documents/NeuralNetWorkAML211/test_DEAD_LargeMaskWatershed_p2.csv';
DEADfilename3 = '/home/phnguyen/Documents/NeuralNetWorkAML211/test_DEAD_LargeMaskWatershed_p3.csv';
DEADfilename4 = '/home/phnguyen/Documents/NeuralNetWorkAML211/test_DEAD_LargeMaskWatershed_p4.csv';

LIVEmatrix1 = readtable(LIVEfilename1,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');
LIVEmatrix2 = readtable(LIVEfilename2,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');
LIVEmatrix3 = readtable(LIVEfilename3,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');
LIVEmatrix4 = readtable(LIVEfilename4,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');

DEADmatrix1 = readtable(DEADfilename1,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');
DEADmatrix2 = readtable(DEADfilename2,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');
DEADmatrix3 = readtable(DEADfilename3,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');
DEADmatrix4 = readtable(DEADfilename4,'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f');

root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
LIVEcsvfilename = 'test_LIVE_largeMaskWatershed.csv';
DEADcsvfilename = 'test_DEAD_largeMaskWatershed.csv';

LIVEmatrix = [LIVEmatrix1;LIVEmatrix2;LIVEmatrix3;LIVEmatrix4];

DEADmatrix = [DEADmatrix1;DEADmatrix2;DEADmatrix3;DEADmatrix4];

writetable(LIVEmatrix,strcat(root_dir,LIVEcsvfilename));
writetable(DEADmatrix,strcat(root_dir,DEADcsvfilename));
