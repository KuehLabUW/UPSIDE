%This code organizes cell maskes based on area and eccentricity rather than
%VAE UMAP
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';

csvfilename = 'LIVE_tracked_Area.csv';

datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f');
sharpvalue =[];
im_size = 64;
%loop through each mask and calculate sharpness
for i = 1:height(datamatrix)
    tifname = char(datamatrix.dirname(i));
    tifname_mask = strcat(tifname(1:end-4),'_mask.jpg');
    im_mask = imread(tifname_mask);
    im_mask = im_mask > 100;
    im      = imread(tifname);
    [Gmag, Gdir] = imgradient(im,'prewitt');
    Gmag = Gmag.*im_mask;
    sharpvalue = [sharpvalue max(abs(Gmag(:)))];
    disp(i)
    %keyboard
    
end
%%
sharpvalue = sharpvalue';
newmatrix = [datamatrix table(sharpvalue)];
writetable(newmatrix,[root_dir 'LIVE_tracked_Area_Sharp.csv']);

