%This code organizes cell maskes based on area and eccentricity rather than
%VAE UMAP
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/';

datadirfile = 'CombinedDirTypeChosen2.csv';

datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f %f');
area =[];
eccentricity = [];
im_size = 64;
%loop through each mask and calculate area and eccentricity
for i = 1:height(datamatrix)
    tifname_mask = char(datamatrix.dirname(i));
    tifname_mask = strcat(tifname_mask(1:end-4),'_mask.jpg');
    im_mask = imread(tifname_mask);
    im_mask = im_mask > 100;
    R = regionprops(im_mask,'Area','Eccentricity','Centroid');
    D = [];
    if numel(R) > 1
               %identify the correct object if there's more than one
               for r = 1:numel(R)
                d = im_size;
                center = [d/2,d/2];
                Dis_to_center = sqrt(sum((R(r).Centroid - center) .^ 2));
                D = [D Dis_to_center];
               end
               [value,idx] = min(D);
            
    end
    if isempty(R)
        area = [area;0];
        eccentricity = [eccentricity;0];
    end
    if numel(R) > 1
        area = [area;R(idx).Area];
        eccentricity = [eccentricity;R(idx).Eccentricity];
    else
        area = [area;R.Area];
        eccentricity = [eccentricity;R.Eccentricity];
    end
    
    disp(i)
    
end

newmatrix = [datamatrix table(area) table(eccentricity)];
writetable(newmatrix,[root_dir 'ChosenCells_Area.csv']);
scatter(newmatrix.area,newmatrix.eccentricity,10,categorical(datamatrix.group))
