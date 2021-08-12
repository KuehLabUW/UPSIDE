% this script lets you specify a list of features and a biological feature
% of interest and it will genera example images

clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211Total/';


cd(code_dir)
% enter properties name
prop_name_ini = 'APC_corr'; % 'APC_corr','PE_corr','distance'
% enter the list of features
flist = [{'t35'}];
% enter the feature value threshold
thresh = 3.0;
%thresh = 1.0;
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

%% show the mean image

% first make a feature vectors containing all the feature values
features = [];
for i = 1:100
    eval(sprintf('features = [features,matrix.m%d];',i-1));
end

for i = 1:100
    eval(sprintf('features = [features,matrix.t%d];',i-1));
end
% then calculate the mean vector
codeM = mean(features(:,1:100),1);
codeT = mean(features(:,101:200),1);
code = [codeM,codeT];
% find the distance and index of the object with the closest vectors to the
% mean vector
D = pdist2(code,features,'euclidean');
[d,idx] = mink(D,10);
%%% get dirname and show image randomly chosen from the closest vectors set
idx_chosen = idx(randperm(length(idx),1)); %idx 73995 looks good!
if strcmp(prop_name_ini,'distance') == 0
    [BFtexture_mean,BF_mean, APC_mean, PE_mean] = getFluoIm(idx_chosen,matrix,raw_tif);
    imtool(BF_mean,[0,2])
    imtool(BFtexture_mean,[0 1])
    imtool(APC_mean,[600,1000])
    imtool(PE_mean,[1100,2000])
else
    BF_mean = imread(char(matrix.dirname(idx_chosen)));
    imtool(BF_mean)
end

%% loop through the specified features and show example image

for feature = flist
    % extract submatrix with feature value larger than a specific threshold
    for prop_name = matrix.Properties.VariableNames
        if strcmp(char(prop_name),char(feature)) == 1
            eval(sprintf('submatrix = matrix(matrix.%s > %d,:);',char(feature),thresh));
            break
        end
    end
    % randomly choose a cell; show its image in each channel, 
    idx_chosen = randperm(height(submatrix),1);
    %idx_chosen = 111;
    disp(idx_chosen)
    if strcmp(prop_name_ini,'distance') == 0
        eval(sprintf('[BFtexture_%s, BF_%s, APC_%s, PE_%s] = getFluoIm(idx_chosen,submatrix,raw_tif);',char(feature),char(feature),char(feature),char(feature)));
        eval(sprintf('imtool(BF_%s,[0,2]);',char(feature)))
        %eval(sprintf('imtool(BFtexture_%s,[0,1]);',char(feature)))
        eval(sprintf('imtool(APC_%s,[600,1000]);',char(feature)))
        %eval(sprintf('imtool(PE_%s,[500,3000]);',char(feature)))
    else
        eval(sprintf('BF_%s = imread(char(submatrix.dirname(idx_chosen)));',char(feature)));
        eval(sprintf('imtool(BF_%s,[0.6 1.25]);',char(feature)));
    end
    
end
