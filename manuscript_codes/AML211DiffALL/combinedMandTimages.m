clear
mask_dir = '/media/phnguyen/Data2/FakeImMask/';
texture_dir = '/media/phnguyen/Data2/FakeImTexture/';
fuse_dir = '/media/phnguyen/Data2/FakeImFused/';

Mdirfile = 'VAE_z_Mask_%d.TIF';
Tdirfile = 'VAE_z_Texture_%d.TIF';
Fdirfile = 'VAE_z_Fused_%d.TIF';


for i = 1:85938
    disp(i)
    m = rgb2gray(imread(sprintf([mask_dir,Mdirfile],i)));
    t = rgb2gray(imread(sprintf([texture_dir,Tdirfile],i)));
    
    m = m > 50;
    t(m==0) = 127;
    imwrite(imresize(t,[1080 1080]),sprintf([fuse_dir,Fdirfile],i));
end

%%
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'CombinedUMAPDirFluoClusterZ.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
for i = 1:85988
    im = imread(datamatrix_all.dirname(i));
    keyboard
end