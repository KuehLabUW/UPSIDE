%this code aligns all latent variable of VAE and chosse to retain those
%with largest stdev

clear
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/';
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypesShapes/';

latent_var_name = 'style_CellTypes_VAE_LargeMaskLong.csv';

cd(code_dir)


z_matrix = csvread(strcat(root_dir,latent_var_name));
%labels_matrix = csvread(strcat(root_dir,labels_name));

%calculate std of each latent var element
z_matrix_std = std(z_matrix,1);
[z_std_sorted Index] = sort(z_matrix_std,'descend');
plot(1:1:100,z_std_sorted)
hold on
scatter(1:1:100,z_std_sorted)
%choose the first 15 elements with the largest std
idx_element_matter = Index(1:20);
%keyboard
%randomly choose a cell latent var
total_cell_number = 4000;
chosen_i = randi(total_cell_number);
chosen_i = 3950;
%var_range = 0:0.1:1;
var_range = 0:1:10;

synbarcode = z_matrix(chosen_i,:);
count = 1;
for i = 1:numel(idx_element_matter)
    for v = 1:numel(var_range)
        newbarcode = synbarcode(1,:);
        newbarcode(idx_element_matter(i)) = newbarcode(idx_element_matter(i)) + var_range(v); 
        synbarcode(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'latent_z_100_VAE_LargeMask_subgate_scanLong2.csv'),synbarcode)


