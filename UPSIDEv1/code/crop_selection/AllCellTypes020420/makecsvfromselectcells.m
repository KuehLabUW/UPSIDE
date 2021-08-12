% this script takes the chosen cell crop indexes and extract the cell's information
% and compile them into a csv file

clear
%% enter script's input


% enter directory of the script
code_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/code/crop_selection/AllCellTypes020420/';
% enter directory of the data folder
root_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/CellTypes020420/';
% enter name of the summary csv file
csvfilename = 'CombinedDirType.csv';
% parse data if needed
parse_data = true;


cd(code_dir)


%%
matrix = readtable(strcat(root_dir,'csvs/',csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f');

cd(strcat(root_dir,'mat/'))

if parse_data == true
    typelist = [1,2,3];
    T = table();
    for i = 1: numel(typelist)
        for j = 1:2
            matname = sprintf('ChosenINDtype%dtrial%d.mat',typelist(i),j);
            submatrix = matrix(matrix.trial == j &  matrix.type == typelist(i),:);
            load(matname);
            chosenmatrix = submatrix(INDEX,:);
            T = [T;chosenmatrix];
        end
    end
    cd(strcat(root_dir,'csvs/'))
    writetable(T,'CombinedDirTypeChosen.csv')
else
    
    T = table();
    matname = 'ChosenIND.mat';
    load(matname);
    chosenmatrix = submatrix(INDEX,:);
    T = [T;chosenmatrix];
   
    cd(strcat(root_dir,'csvs/'))
    writetable(T,'CombinedDirTypeChosen.csv')
end