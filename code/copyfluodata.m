clear
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'fluo.csv';
new_dir = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/csvs/';

datacolumn = 5;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end

datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


dirname = [];
condition  = [];
CD34_APC = [];
CD38_PE = [];


%%

for i = 1:height(datamatrix_all)
    current_name_full = char(datamatrix_all.dirname(i));
    s = find(current_name_full=='/');
    tif_name = current_name_full(s(end)+1:end);
    
    
    if sum(current_name_full(46:61) == 'AML211DiffTrial2') == 16
        continue
    end
    
    if sum(current_name_full(46:61) == 'AML211DiffTrial3') == 16
        tif_name_new = tif_name;
        tif_name_new(1:16) ='AML211DiffTrial2';
        
    else
        tif_name_new = tif_name;
        
    end
    
    current_name_full_new = strcat(new_dir,tif_name_new);

    dirname = [dirname {current_name_full_new}];
    condition = [condition datamatrix_all.condition(i)];
    CD34_APC = [CD34_APC datamatrix_all.APC_corr(i)];
    CD38_PE = [CD38_PE datamatrix_all.PE_corr(i)];
    
    disp(i)
end

new_df = table(dirname',condition',CD34_APC',CD38_PE');
writetable(new_df,'/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/csvs/fluorescent_cel_list.csv')