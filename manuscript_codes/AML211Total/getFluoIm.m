% This function takes in the master table of cell crops, the idx of the
% cell crops of interest, the folder of the raw fluorescent images and
% returns the images of the cell in each channel

function [BF_texture, BF_crop, APC_crop, PE_crop] = getFluoIm(idx_chosen,matrix,raw_tif_dir)

% Extract info on the cells
meancell.dirname = matrix.dirname(idx_chosen);
meancell.trial = matrix.trial(idx_chosen);
meancell.pos = matrix.pos(idx_chosen);
meancell.t = matrix.t(idx_chosen);
meancell.x = matrix.Xcenter(idx_chosen);
meancell.y = matrix.Ycenter(idx_chosen);
% Extract images containing the cells
APC_im = imread([raw_tif_dir,sprintf('EXPTrial%d_w2LDI 640_s%d_t%d.TIF',meancell.trial,meancell.pos,meancell.t)]);
PE_im = imread([raw_tif_dir,sprintf('EXPTrial%d_w3LDI 555_s%d_t%d.TIF',meancell.trial,meancell.pos,meancell.t)]);
BF_im = imread([raw_tif_dir,sprintf('EXPTrial%d_w1Camera BF_s%d_t%d.TIF',meancell.trial,meancell.pos,meancell.t)]);
% Get the cell crop from each channel
d = 120;
X = round(meancell.x);
Y = round(meancell.y);
top_left = [X - d/2, Y - d/2];
top_right = [X + d/2 , Y - d/2];
bottom_left = [X - d/2 , Y + d/2];
bottom_right = [X + d/2 , Y + d/2];

%BF_crop = imresize(BF_im(top_left(2):bottom_left(2)-1,top_left(1):top_right(1)-1),[64,64]);
APC_crop = imresize(APC_im(top_left(2):bottom_left(2)-1,top_left(1):top_right(1)-1),[64,64]);
PE_crop = imresize(PE_im(top_left(2):bottom_left(2)-1,top_left(1):top_right(1)-1),[64,64]);



tifname_mask = char(meancell.dirname);
tifname_mask = strcat(tifname_mask(1:end-4),'_texture.TIF');
BF_crop = imread(char(meancell.dirname));
BF_texture = imread(tifname_mask);

end