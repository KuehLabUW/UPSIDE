sample_size = 60;
csvfilename = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/ModAML211_ALLDirFluo.csv';
correctedcsvfilename = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/ModAML211_ALLCorrectedDirFluo.csv';
matrix = readtable(csvfilename);
correctedmatrix = readtable(correctedcsvfilename);
%randomly picks index in the table
r = randi([1 numel(matrix.dirname(:))],1,sample_size);

%go through the table and get the images
TotalIm = [];
TotalIm_norm = [];
TotalIm_substracted = [];
for subim = 1:numel(r)
    
    tifname = string(matrix.dirname(r(subim)));
    im = imread(tifname);
    corrtifname = string(correctedmatrix.dirname(r(subim)));
    corrim = imread(corrtifname);
    
    corrim(corrim ~= 0) = 1;
    
    small_im = corrim;

    se = strel('disk',10);
    big_im = imdilate(small_im,se);

    mask_annulus = logical(big_im .* (~small_im));
    annulus = double(median(im(mask_annulus)));

    norm_im = im./annulus;
    substracted_im = im./annulus;
    
    TotalIm = cat(3,TotalIm,im);
    TotalIm_norm = cat(3,TotalIm_norm,norm_im);
    TotalIm_substracted = cat(3,TotalIm_substracted,substracted_im);
end

