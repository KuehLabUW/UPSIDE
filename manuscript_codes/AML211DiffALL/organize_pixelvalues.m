%This code organizes cell maskes based on area and eccentricity rather than
%VAE UMAP
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

csvfilename = 'CombinedMaskDirFluoClusterAreaT.csv';

datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
pixvalue =[];
im_size = 64;
%loop through each mask and calculate area and eccentricity
for i = 1:height(datamatrix)
    tifname = char(datamatrix.dirname(i));
    tifname_mask = strcat(tifname(1:end-4),'_mask.jpg');
    %tifname = strcat(tifname(1:end-4),'_texture.TIF'); %%%
    im_mask = imread(tifname_mask);
    im_mask = im_mask > 100;
    im      = imread(tifname);
    R = regionprops(im_mask,im,'MeanIntensity','Area','Eccentricity','Centroid');
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
        pixvalue = [pixvalue;0];
        
    end
    if numel(R) > 1
        pixvalue = [pixvalue;R(idx).MeanIntensity];
        
    else
        pixvalue = [pixvalue;R.MeanIntensity];
        
    end
    %keyboard
    disp(i)
    
    
end
%%
newmatrix = [datamatrix table(pixvalue)];
writetable(newmatrix,[root_dir 'CombinedMaskDirFluoClusterAreaTpix.csv']);

