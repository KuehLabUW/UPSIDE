%this code aligns all latent variable of VAE and chosse to retain those
%with largest stdev

clear
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
latent_var_name = 'style_AML211_VAE_v2_mask.csv';

cd(code_dir)


z_matrix = csvread(strcat(root_dir,latent_var_name));


%calculate std of each latent var element
z_matrix_std = std(z_matrix,1);
[z_std_sorted Index] = sort(z_matrix_std,'descend');
z_matrix_sorted = z_matrix(:,Index);

high_std = 30;

z_matrix_sorted = z_matrix_sorted(:,1:high_std);

target_Index = [2 9 10 11 12 14 16 17 18 20 22 23];

A = z_matrix_sorted;
A(:,target_Index) = [];
csvwrite(strcat(root_dir,'style_AML211_VAE_v2_mask_truncated.csv'),A)

%high_std = 30;

%z_std_sorted = z_std_sorted(:,1:high_std);
%target_Index = [2 9 10 11 12 14 16 17 18 20 22 23];

%A = z_std_sorted;
%A(:,target_Index) = [];
%csvwrite(strcat(root_dir,'style_AML211_VAE_v2_mask_truncated.csv'),synbarcode)


