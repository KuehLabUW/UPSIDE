clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
csvfilename = 'AML211_ALLSubstractedDir.csv';
cd(code_dir)


matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %f %s %f %f %f %f %f');
cd('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat')
%DEAD = [];
%INDEX = [];
load('DEAD.mat');
load('INDEX.mat');

for cell = 1:height(matrix)
    ind = randi([1,height(matrix)]);
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
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/DEAD.mat','DEAD')
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/INDEX.mat','INDEX')
        disp('saved')
        disp('File size:')
        disp(numel(INDEX))
        disp('%%%%%%%%%%%%')
        imtool close all
    end
        
    
end