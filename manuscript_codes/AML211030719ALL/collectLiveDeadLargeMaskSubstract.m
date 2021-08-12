clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
csvfilename = 'AML211_ALLLargeMaskSubstractedDir.csv';
cd(code_dir)


matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %f %s %f %f %f %f %f');
cd('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat')
load('DEAD_largeMask.mat')
load('INDEX_largeMask.mat')
%keyboard
%concatenate dirname file
TotalDirname = matrix.dirname;



for cell = 1:numel(TotalDirname)
    ind = randi([1,numel(TotalDirname)]);
    if ~ismember(ind,INDEX)
        im = imread(string(TotalDirname(ind)));
        imtool(im,[0,1.5])
        
        dead = input('dead? :'); % 1 : dead 2 : live 3 : double
        if ~isempty(dead)
            DEAD = [DEAD dead];
            INDEX = [INDEX find(string(matrix.dirname) == string(TotalDirname(ind)))];
        else
            disp('SKIP!')
        end
        close all
    end
    if rem(numel(INDEX),100) == 0
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/DEAD_largeMask.mat','DEAD')
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/INDEX_largeMask.mat','INDEX')
        disp('saved')
        disp('File size:')
        disp(numel(INDEX))
        disp('%%%%%%%%%%%%')
        imtool close all
    end
        
    
end

