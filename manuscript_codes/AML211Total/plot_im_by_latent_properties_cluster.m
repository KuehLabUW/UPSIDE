% this script lets you specify a list of features and a biological feature
% of interest and it will genera example images

clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211Total/';


cd(code_dir)
% enter properties name
prop_name_ini = 'APC_corr'; % 'APC_corr','PE_corr','distance'
% enter the list of features
flist = [{'m23','m27','m18','m31','m51','m21','m47','m77','m11','m38','m55','m45'}];
flist2 = [{'m80','m7','m92','m81','m4','m85','m76'}];
flist3 = [{'m1','m51','m16','m99','m75'}];
flist3 = [{'m52'}];
% enter the feature value threshold
thresh = 3.0;
cluster = 1.0;
%% decide which data to load
if strcmp(prop_name_ini,'distance') == 1
    root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';
    datadirfile = 'cluster_tracked_dist_area_dist_cond.csv';
    rawtif(1)= {'/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/DifferentiationTrack1/'};
    rawtif(2)= {'/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/DifferentiationTrack2/'};
    datacolumn = 217;
    Text = ['%s'];
    for i = 1:datacolumn
        Text = [Text ' %f'];
    end
    matrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
    matrix = matrix(matrix.pcell~=0,:);
else
    root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
    datadirfile = 'Dataset1CompleteAreaEdgeFluoClusterCenter.csv';
    raw_tif = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/data/Differentiation/';
    datacolumn = 219;
    Text = ['%s'];
    for i = 1:datacolumn
        Text = [Text ' %f'];
    end
    
    
    matrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
    matrix = matrix(matrix.trial ~= 2,:);
end


%% loop through the specified features and extract subdf of cells enriched
% with such features then sample an image from there

t_matrix = table();

for feature = flist3
    % extract submatrix with feature value larger than a specific threshold
    for prop_name = matrix.Properties.VariableNames
        if strcmp(char(prop_name),char(feature)) == 1
            eval(sprintf('submatrix = matrix(matrix.%s > %d,:);',char(feature),thresh));
            break
        end
    end
    t_matrix = [t_matrix;submatrix];
end


t_matrix_u = unique(t_matrix,'rows');
t_matrix_u = t_matrix_u(t_matrix_u.cluster == cluster,:);

%%
% randomly choose a cell; show its image in each channel, 
idx_chosen = randperm(height(t_matrix_u),1);
%idx_chosen = 111;
disp(idx_chosen)
if strcmp(prop_name_ini,'distance') == 0
    eval(sprintf('[BFtexture_%s, BF_%s, APC_%s, PE_%s] = getFluoIm(idx_chosen,t_matrix_u,raw_tif);',char(feature),char(feature),char(feature),char(feature)));
    eval(sprintf('imtool(BF_%s,[0,2]);',char(feature)))
    %eval(sprintf('imtool(BFtexture_%s,[0,1]);',char(feature)))
    eval(sprintf('imtool(APC_%s,[600,1000]);',char(feature)))
    eval(sprintf('imtool(PE_%s,[500,3000]);',char(feature)))
else
    eval(sprintf('BF_%s = imread(char(submatrix.dirname(idx_chosen)));',char(feature)));
    eval(sprintf('imtool(BF_%s,[0.6 1.25]);',char(feature)));
end














