%This code organizes cell maskes based on PCA into 100 rather than
%VAE
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/';

datadirfile = 'ChosenCells_Area_Sharp.csv';

datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f %f %f %f %f');

imsize = 64;
raw_data = zeros(height(datamatrix),imsize*imsize);


%straighthen out all the images into a line and stitch them together

for i = 1:height(datamatrix)
    tifname_mask = char(datamatrix.dirname(i));
    tifname_mask = strcat(tifname_mask(1:end-4),'_texture.TIF');
    im_mask = imread(tifname_mask);
    
    raw_data(i,:) = double(im_mask(:));
    disp(i)
end

%get the pca value for all samples;
[coeff, score, latent, tsquared, explained, mu] = pca(raw_data);
PCA_latent_data = raw_data*coeff(:,1:100);

writematrix(PCA_latent_data,[root_dir 'style_PCA_CellTypes_VAE_textureChosen.csv']);



