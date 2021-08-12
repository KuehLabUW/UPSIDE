%this script show a sample of image patches specified in gate file
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';
datadirfile = 'CombinedUMAPDirFluoClusterTCdist.csv';
datacolumn = 216;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
min_track_length = 10;

pos_total = {};
for p = 1:10
%%
pos = p;
submatrix = datamatrix(datamatrix.pos == pos,:);
disp('#######')
disp(pos)
disp('#######')
% define a variable that store all used cells amd a var that store all the
% tracks
Used = cell(max(submatrix.t),1);
Tracks = struct();
count = 0;
% start with the first timepoint and grow tracks
for t = 1:max(submatrix.t)-1
    disp(t)
    submatrix_t = submatrix(submatrix.t == t,:);
    for c = 1:size(submatrix_t,1)
        T = connectPairs(submatrix,t,submatrix_t.cell(c));
        %keyboard
        if numel(T) > min_track_length - 1 %only record tracks with more than 1 cells
            
            while ~ismember(T(1),Used{t})
                
                count = count + 1;
            
                Tracks(count).t = t;
                Tracks(count).tr = T;
            
                for j = 1:numel(T)
                    Used{t+j-1} = [Used{t+j-1} T(j)];
                end
            end
            
        end
    end
end

pos_total{p} = Tracks;
end

%% save tracks to csv
track = [];
pos = [];
cell = [];
t = [];
cluster = [];
xumap = [];
yumap = [];

count = 0;
for i = 1:numel(pos_total)
    Tracks = pos_total{i};
    for j = 1:numel(Tracks)
        count  = count + 1;
        tr = Tracks(j).tr;
        t_start = Tracks(j).t;
        
        track = [track count*ones(1,numel(tr))];
        pos = [pos i*ones(1,numel(tr))];
        t = [t (t_start + [0:numel(tr)-1])];
        cell = [cell tr];
        
        
        
        poslist = i*ones(1,numel(tr));
        tlist = (t_start + [0:numel(tr)-1]);
        celllist = tr;
        clusterlist = [];
        xumaplist = [];
        yumaplist = [];
        for k = 1:numel(poslist)
            cond1 = datamatrix.pos == poslist(k);
            cond2 = datamatrix.t == tlist(k);
            cond3 = datamatrix.cell == celllist(k);
            submatrix = datamatrix(cond1 & cond2 & cond3,:);
            if size(submatrix,1) == 1
                clusterlist = [clusterlist submatrix.cluster];
                xumaplist = [xumaplist submatrix.xumap];
                yumaplist = [yumaplist submatrix.yumap];
            else
                keyboard
            end            
        end        
        cluster = [cluster clusterlist];
        xumap = [xumap xumaplist];
        yumap = [yumap yumaplist];
        
    end
end
tab = table(track',pos',cell',t',cluster',xumap',yumap','VariableNames',{'track','pos','cell','t','cluster','xumap','yumap'});
writetable(tab,[root_dir 'Tracks.csv'])


    