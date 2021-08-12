clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'Dataset1CompleteArea.csv';
datacolumn = 210;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);

datamatrix = datamatrix_all(:,1:11);
datamatrix_Z = datamatrix_all(:,12:end);



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
newmatrix = [newmatrix datamatrix_Z];
writetable(newmatrix,[root_dir 'Dataset1CompleteAreaEdge.csv']);

