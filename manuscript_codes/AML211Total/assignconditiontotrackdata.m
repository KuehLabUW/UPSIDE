%This code organizes cell maskes based on area and eccentricity rather than
%VAE UMAP
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211Total/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';

datadirfile = 'cluster_tracked_dist_area.csv';
datacolumn = 215;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);

%datamatrix = datamatrix_all(:,1:9);
%datamatrix_Z = datamatrix_all(:,10:end);

%%

condition = [];
%loop through each mask and calculate area and eccentricity
for i = 1:height(datamatrix)
    
    if (datamatrix.trial(i) == 1) && (datamatrix.pos(i) < 6)
        condition = [condition 1];
    elseif (datamatrix.trial(i) == 1) && (datamatrix.pos(i) > 5)
        condition = [condition 2];
    elseif (datamatrix.trial(i) == 2) && (datamatrix.pos(i) < 4)
        condition = [condition 1];
    elseif (datamatrix.trial(i) == 2) && (datamatrix.pos(i) > 3)
        condition = [condition 2];
    end
    
    disp(i)
end

newmatrix = [datamatrix table(condition')];
writetable(newmatrix,[root_dir 'cluster_tracked_dist_area_dist_cond.csv']);
%scatter(newmatrix.area,newmatrix.eccentricity,10,categorical(datamatrix.group))
