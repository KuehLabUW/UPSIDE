% this script allows the user to select the cell crops for input into
% UPSIDE VAE. it outputs a mat file containing the index of selected
% cells in the mat/ folder. Run the script and enter '1' into the prompt to
% tag a cell crop for selection

% this script can be run multiple times to continue adding cells to existing
% dataset
clear
%% enter script's input

% enter directory of the script
code_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/code/crop_selection/AllCellTypes020420/';
% enter directory of the data folder
root_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/CellTypes020420/';
% enter name of the summary csv file
csvfilename = 'CombinedDirType.csv';
% choose specific condition if desirable, enter 0 if no data parsing is
% needed
parse_data = true;
if parse_data == true
    type = 1;
    trial = 1;
end
% choose whether this is the first run
first_run = true;


%% main script



cd(code_dir)

matrix = readtable(strcat(root_dir,'csvs/',csvfilename),'Delimiter', ',',...
'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f');

if parse_data == true
    matrix = matrix(matrix.trial == trial &  matrix.type == type,:);
end

if first_run == true % first run scenario
    
    % make a variable to store the indexes
    INDEX = [];
    TotalDirname = matrix.dirname;
    count = 0;
    
    % make a mat filename to save the indexes in
    if parse_data == true
        matname = sprintf('ChosenINDtype%dtrial%d.mat',type,trial);
    else
        matname = 'ChosenIND.mat';
    end
    
    % cell selection loop
    for cell = 1:numel(TotalDirname)
        count = count +1;
        ind = cell;
        if ~ismember(ind,INDEX)
            im = imread(string(matrix.dirname(ind)));
            tifname = string(matrix.dirname(ind));
            tifname_mask = char(tifname);
            tifname_mask = strcat(tifname_mask(1:end-4),'_mask.jpg');
            im_mask = imread(tifname_mask);
            im_mask = im_mask > 100;
            imtool(im,[0,1.5])
            
            commandwindow;
            good = input('choose cell? :');
            
            if good == 1
                INDEX = [INDEX ind];
            else
                disp('SKIP!')
            end
            
        end
        if rem(count,100) == 0
            
            save([strcat(root_dir,'mat/'),matname],'INDEX')
            disp('saved')
            disp('File size:')
            disp(numel(INDEX))
            disp('%%%%%%%%%%%%')
            imtool close all
        end
        
        if rem(count,100) == 0
            imtool close all
        end
        
    end
    
else % continuing run scenario
    
    cd(strcat(root_dir,'mat/'))
    
    % load the mat file
    if parse_data == true
        matname = sprintf('ChosenINDtype%dtrial%d.mat',type,trial);
        load(matname)
    else
        matname = 'ChosenIND.mat';
        load(matname)
    end
    
    TotalDirname = matrix.dirname;
    count = 0;
    for cell = max(INDEX)+1:numel(TotalDirname)

        count = count +1;
        ind = cell;
        if ~ismember(ind,INDEX)
            im = imread(string(matrix.dirname(ind)));
            tifname = string(matrix.dirname(ind));
            tifname_mask = char(tifname);
            tifname_mask = strcat(tifname_mask(1:end-4),'_mask.jpg');
            im_mask = imread(tifname_mask);
            im_mask = im_mask > 100;
            imtool(im,[0,1.5])
            
            commandwindow;
            good = input('choose cell? :');
            
            if good == 1
                INDEX = [INDEX ind];
            else
                disp('SKIP!')
            end
            
        end
        if rem(count,100) == 0
            
            save([strcat(root_dir,'mat/'),matname],'INDEX')
            disp('saved')
            disp('File size:')
            disp(numel(INDEX))
            disp('%%%%%%%%%%%%')
            imtool close all
        end
        
        if rem(count,100) == 0
            imtool close all
        end
        
    end
end