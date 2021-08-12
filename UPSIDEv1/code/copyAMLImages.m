clear
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';

datadirfile = 'LIVE_total.csv';
new_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/SubImTextures/';

datacolumn = 5;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
dirname = [];
trial = [];
pos = [];
t = [];
cell = [];
dataset = [];

%%

for i = 1:height(datamatrix_all)
    current_name_full = char(datamatrix_all.dirname(i));
    s = find(current_name_full=='/');
    tif_name = current_name_full(s(end)+1:end);
    
    jpg_name = strcat(tif_name(1:end-4),'_mask.jpg');
    current_name_jpg = current_name_full(1:end-4);
    current_name_jpg = strcat(current_name_jpg,'_mask.jpg');
    if sum(current_name_full(46:61) == 'AML211DiffTrial2') == 16
        continue
    end
    
    if sum(current_name_full(46:61) == 'AML211DiffTrial3') == 16
        tif_name_new = tif_name;
        tif_name_new(1:16) ='AML211DiffTrial2';
        jpg_name_new = strcat(tif_name_new(1:end-4),'_mask.jpg');
        
        trial = [trial 2];
    else
        tif_name_new = tif_name;
        jpg_name_new = jpg_name;
        
        trial = [trial datamatrix_all.trial(i)];
    end
    
    current_name_full_new = strcat(new_dir,tif_name_new);
    current_name_jpg_new = strcat(new_dir,jpg_name_new);
    eval(sprintf('copyfile %s %s',current_name_full,current_name_full_new))
    eval(sprintf('copyfile %s %s',current_name_jpg,current_name_jpg_new))
    
    dirname = [dirname {current_name_full_new}];
    pos = [pos datamatrix_all.pos(i)];
    t = [t datamatrix_all.t(i)];
    cell = [cell datamatrix_all.cell(i)];
    dataset =[dataset datamatrix_all.dataset(i)];
    
    disp(i)
    
end

new_df = table(dirname',pos',t',cell',trial',dataset');
writetable(new_df,'/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/csvs/cell_list.csv')