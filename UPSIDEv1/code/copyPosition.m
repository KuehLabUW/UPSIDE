clear all

root_dir1 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';
datadirfile1 = 'cluster_tracked_dist_area_dist_cond.csv';


datacolumn = 216;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end

datamatrix_pos = readtable(strcat(root_dir1,datadirfile1),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


root_dir2 = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/csvs/';
datadirfile2= 'cell_list.csv';

datacolumn = 5;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end

datamatrix_new = readtable(strcat(root_dir2,datadirfile2),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);

%% curate the raw dataset
d_track = datamatrix_new(datamatrix_new.dataset ~= 1,:);
d_diff = datamatrix_new(datamatrix_new.dataset ==1,:);

bad_j =[];
Xcenter = [];
Ycenter = [];

for i = 1:height(d_track)
    flag = 0;
    for j = 1:height(datamatrix_pos)
        if ismember(j,bad_j)
            flag = 1;
            break
        end
        
        pos = d_track.pos(i);
        t = d_track.t(i);
        cell = d_track.cell(i);
        trial = d_track.trial(i);
        dataset = d_track.dataset(i);
        
        pos_ref = datamatrix_pos.pos(j);
        t_ref = datamatrix_pos.t(j);
        cell_ref = datamatrix_pos.cell(j);
        trial_ref = datamatrix_pos.trial(j);
        dataset_ref = datamatrix_pos.dataset(j);
        
        if (pos == pos_ref && t == t_ref && cell == cell_ref && trial == trial_ref && dataset == dataset_ref)
            Xcenter = [Xcenter;datamatrix_pos.Xcenter(j)];
            Ycenter = [Ycenter;datamatrix_pos.Ycenter(j)];
            flag = 1;
            break
        end
        
    end
    
    if flag == 1
        Xcenter = [Xcenter;0];
        Ycenter = [Ycenter;0];
    end
    
end

%% Add center data back into df_track
df_track_c = df_track;
df_track_c.Xcenter = Xcenter;
df_track_c.Ycenter = Ycenter;

df_track_c = df_track_c(df_track_c.Xcenter ~= 0,:);
df_track_short = df_track_c(:,1:6);
%% make a new cell list
df = [df_diff;df_track_short];
writetable(new_df,'/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/csvs/cell_list_short.csv')
writetable(df_track_c,'/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/csvs/cel_list_XYcenter.csv')
