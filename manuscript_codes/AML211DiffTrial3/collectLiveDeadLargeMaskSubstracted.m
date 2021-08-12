clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypesShapes/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/';
csvfilename = 'CombinedLargeMaskSubstractedWatershedDir.csv';
cd(code_dir)


matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f');
cd('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/mat')
%DEAD = [];
%INDEX = [];
load('DEAD.mat');
load('INDEX.mat');
TotalDirname = matrix.dirname;
for cell = 1:numel(TotalDirname)
    ind = randi([1,numel(TotalDirname)]);
    if ~ismember(ind,INDEX)
        im = imread(string(matrix.dirname(ind)));
        imtool(im,[0,1.5])
        
        dead = input('dead? :');
        if ~isempty(dead)
            DEAD = [DEAD dead];
            INDEX = [INDEX ind];
        else
            disp('SKIP!')
        end
        
    end
    if rem(numel(INDEX),100) == 0
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/mat/DEAD.mat','DEAD')
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/mat/INDEX.mat','INDEX')
        disp('saved')
        disp('File size:')
        disp(numel(INDEX))
        disp('%%%%%%%%%%%%')
        imtool close all
    end
        
    
end