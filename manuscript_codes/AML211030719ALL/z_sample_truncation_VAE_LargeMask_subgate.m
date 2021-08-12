%this code aligns all latent variable of VAE and chosse to retain those
%with largest stdev

clear
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
latent_var_name = 'style_AML211_VAE_LargeMask_subgate.csv';
root_var_name = 'root_AML211_VAE_LargeMask_subgate.csv';
cd(code_dir)


z_matrix = csvread(strcat(root_dir,latent_var_name));
label_matrix = csvread(strcat(root_dir,root_var_name));


%calculate std of each latent var element
target_Index = [95,45,20,15];

A = z_matrix;
A = z_matrix(:,target_Index);
%csvwrite(strcat(root_dir,'style_AML211_VAE_LargeMask_subgate.csv'),A)


value1 = A(:,1);
value2 = A(:,2);
value3 = A(:,3);
value4 = A(:,4);


treated = label_matrix(:,1);
pos = label_matrix(:,2);
t = label_matrix(:,3);
cell = label_matrix(:,4);

T = table(value1,value2,value3,value4,treated,pos,t,cell);

writetable(T,strcat(root_dir,'AML211_VAE_LargeMask_subgate_truncatedZ.csv'))