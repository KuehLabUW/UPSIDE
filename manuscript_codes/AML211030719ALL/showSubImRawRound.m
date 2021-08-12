clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
csvfilename = 'AML211_ALLSubstractedDir.csv';
cd(code_dir)


matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %f %s %f %f %f %f %f');
cd('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat')
load('roundcells_drug_dir.mat'); %get dirname for dividing cells TotalDirnameNONDRUG
load('roundcells_nondrug_dir.mat'); %get dirname for dead round cells TotalDirnameDRUG


%concatenate dirname file
TotalDir = [TotalDirnameNONDRUG;TotalDirnameDRUG];

%INDEX_Round = [];
%DEAD_Round = [];

load('INDEX_Round.mat')
load('DEAD_Round.mat')

for cell = 1:numel(TotalDirnameDRUG)
    ind = randi([1,numel(TotalDirnameDRUG)]);
    if ~ismember(ind,INDEX_Round)
        im = imread(TotalDirnameDRUG(cell));
        imtool(im,[0,1.5])
        
        dead = input('dead? :'); % 1 : dead 2 : live 3 : dividing
        if ~isempty(dead)
            DEAD_Round = [DEAD_Round dead];
            INDEX_Round = [INDEX_Round find(matrix.dirname == TotalDir(cell))];
        else
            disp('SKIP!')
        end
        close all
    end
    if rem(numel(INDEX_Round),50) == 0
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/DEAD_Round.mat','DEAD_Round')
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/INDEX_Round.mat','INDEX_Round')
        disp('saved')
        disp('File size:')
        disp(numel(INDEX_Round))
        disp('%%%%%%%%%%%%')
    end
        
    
end

