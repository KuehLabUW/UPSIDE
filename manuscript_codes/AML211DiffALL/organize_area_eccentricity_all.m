%This code organizes cell maskes based on area and eccentricity rather than
%VAE UMAP
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'Dataset1Complete.csv';
datacolumn = 208;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);

datamatrix = datamatrix_all(:,1:9);
datamatrix_Z = datamatrix_all(:,10:end);

%%

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
newmatrix = [newmatrix datamatrix_Z];
writetable(newmatrix,[root_dir 'Dataset1CompleteArea.csv']);
scatter(newmatrix.area,newmatrix.eccentricity,10,categorical(datamatrix.group))
