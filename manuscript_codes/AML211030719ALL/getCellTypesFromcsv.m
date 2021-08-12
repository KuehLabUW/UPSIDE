%This script allows you to manually annotate cell category when prompt with
%a cell picture
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
csvfilename = 'CombinedSubstractedDirUMAP_largeLIVE60z_nodropout.csv';
cd(code_dir)


matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f');
cd('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat')
CATEGORY = [];
INDEX = [];
%load(CATEGORY.mat');
%load('INDEX.mat');

cat_makeup = [1,2,3,4
    ];

for cell = 1:height(matrix)
    ind = randi([1,height(matrix)]);
    if ~ismember(ind,INDEX)
        im = imread(string(matrix.dirname(ind)));
        imtool(im,[0,1.5])
        
        cat = input('cell type? :');
        
        if ~isempty(cat)
            if ismember(cat,cat_makeup)
                CATEGORY = [CATEGORY cat];
                INDEX = [INDEX ind];
            else
                disp('Enter correct cell class!')
            end
        else
            disp('SKIP!')
        end
        
    end
    if rem(numel(INDEX),100) == 0
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/CATEGORY.mat','CATEGORY')
        save('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/mat/INDEX.mat','INDEX')
        disp('saved')
        disp('File size:')
        for i = 1:numel(cat_makeup)
            fprintf('cat %d:\n',i)
            disp(sum(CATEGORY(:)==i))
        end
        disp('%%%%%%%%%%%%')
        imtool close all
    end
        
    
end