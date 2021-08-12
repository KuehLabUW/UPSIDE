%this code aligns all latent variable of VAE and chosse to retain those
%with largest stdev

clear
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';

latent_var_name_mask = 'style_AML211_VAE_Mask2.csv';
latent_var_name_texture = 'style_AML211_VAE_Texture2.csv';

labels_mask = 'root_AML211_VAE_Mask2.csv';
labels_texture = 'root_AML211_VAE_Texture2.csv';


cd(code_dir)


z_matrix_Mask = csvread(strcat(root_dir,latent_var_name_mask));
label_matrix_Mask = csvread(strcat(root_dir,labels_mask));

z_matrix_Texture = csvread(strcat(root_dir,latent_var_name_texture));
label_matrix_Texture = csvread(strcat(root_dir,labels_texture));




%% calculate std of each latent var element
z_mask_std = std(z_matrix_Mask,1);
[z_mask_std_sorted, IndexM] = sort(z_mask_std,'descend');
plot(1:1:100,z_mask_std_sorted)
figure(1)
hold on
scatter(1:1:100,z_mask_std_sorted)
hold off

z_texture_std = std(z_matrix_Texture,1);
[z_texture_std_sorted, IndexT] = sort(z_texture_std,'descend');
figure(2)

plot(1:1:100,z_texture_std_sorted)
hold on
scatter(1:1:100,z_texture_std_sorted)
hold off



%% choose the first 100 elements with the largest std
z_matrix_Mask = z_matrix_Mask(:,IndexM);
z_matrix_Texture = z_matrix_Texture(:,IndexT);

[~,idx_revM] = intersect(IndexM,1:100); % store index instruction for og sequence construction
[~,idx_revT] = intersect(IndexT,1:100); % store index instruction for og sequence construction

z_mask = z_matrix_Mask(:,1:100);
z_texture = z_matrix_Texture(:,1:100);

%% add that back into a table
Pos = label_matrix_Mask(:,1);
T = label_matrix_Mask(:,2);
cell = label_matrix_Mask(:,3);
trial = label_matrix_Mask(:,4);

Vname = {'pos','t','cell','trial'};
for i = 1:100
    eval(sprintf("Vname = [Vname,'m%d']",i));
end
for i = 1:100
    eval(sprintf("Vname = [Vname,'t%d']",i));
end
datamatrix = array2table([Pos,T,cell,trial,z_mask,z_texture],'VariableNames',Vname);
writetable(datamatrix,strcat(root_dir,'cellsWithZ100.csv'))
keyboard
%% Generate synthetic cell barcode
position = 1;
t = 10;
submatrix = datamatrix(datamatrix.pos == position & datamatrix.t == t,:);

%randomly choose a cell latent var
total_cell_number = size(submatrix,1);

chosen_i = randi(total_cell_number);
%var_range = 0:0.1:1;


codeM = table2array(submatrix(chosen_i,5:104));
codeT = table2array(submatrix(chosen_i,105:204));

var_range = 0:1:10;
count = 1;
for i = 1:5
    for v = 1:numel(var_range)
        %keyboard
        newbarcode = codeM(1,:);
        newbarcode(i) = newbarcode(i) + var_range(v);
        newbarcode = newbarcode(idx_revM); % revert the sequence back to its og position
        synbarcodeM(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'latent_z_100_VAE_Mask_subgate_scan.csv'),synbarcodeM)

var_range = 0:10:100;
count = 1;
for i = 1:5
    for v = 1:numel(var_range)
        newbarcode = codeT(1,:);
        newbarcode(i) = newbarcode(i) + var_range(v);
        newbarcode = newbarcode(idx_revT); % revert the sequence back to its og position
        synbarcodeT(count,:) = newbarcode;
        count = count + 1;
    end
end
csvwrite(strcat(root_dir,'latent_z_100_VAE_Texture_subgate_scan.csv'),synbarcodeT)


