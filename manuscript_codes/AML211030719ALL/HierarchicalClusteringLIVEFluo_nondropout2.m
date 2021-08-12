clear
%This script performs hierarchichal clustering on the latent z_dimension of
%AML211
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
rootfilename = 'CombinedSubstractedDirUMAP_mixgaus_largeLIVEFLUO60z_nodropout2_nostyle.csv';
stylefilename = 'style_CombinedSubstractedDirUMAP_mixgaus_largeLIVEFLUO60z_nodropout2.csv';

cd(code_dir)
matrix_root = readtable(strcat(root_dir,rootfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
matrix_style = readtable(strcat(root_dir,stylefilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', false, 'Format', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
matrix_style = table2array(matrix_style);
%T = clusterdata(matrix_style,4);
%cat = T;
%cat = table(cat);
%matrix_root = [matrix_root cat];

%% get the features with largest variations
Var = mean(matrix_style,1);
matrix_style_small = [];
matrix_style_large = [];
for i=1:1:60
    if Var(i) < 5
        matrix_style_small = [matrix_style_small matrix_style(:,i)];
    else
        matrix_style_large = [matrix_style_large matrix_style(:,i)];
    end
end

csvwrite(strcat(root_dir,'small_',stylefilename),matrix_style_small);
csvwrite(strcat(root_dir,'large_',stylefilename),matrix_style_large);