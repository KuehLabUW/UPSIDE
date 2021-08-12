%this script show a sample of image patches specified in gate file
clear
close all
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';

datadirfile = 'CombinedUMAPDirFluoClusterTCdist.csv';
datacolumn = 216;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end

trackfilename = 'Tracks.csv';
cd(code_dir)


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
trackmatrix = readtable(strcat(root_dir,trackfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %f %f %f %f %f %f');

%%
datamatrix = datamatrix(datamatrix.pos > 5 & datamatrix.pos < 11, :);
trackmatrix = trackmatrix(trackmatrix.pos > 5 & trackmatrix.pos < 11, :);

figure(3)
g0c = [42 214 197]./255;
g1c = [129 131 186]./255;
g2c = [0 131 186]./255;
g3c = [96 163 83]./255;
g4c = [70 150 207]./255;

gscatter(datamatrix.xumap,datamatrix.yumap,datamatrix.cluster)
%legend('on')
hold on

%% plot the trajectory
track_num = 2080;
subtrackmatrix = trackmatrix(trackmatrix.track == track_num,:);
total_im = [];
X = [];
Y = [];
clusters = {'1','2','3','4','5'};
clusters = [2,5,1,4,3,4];
C = [];
for i = 1:size(subtrackmatrix,1)-1
   
    imtool close all
    XY = [subtrackmatrix.xumap(i),subtrackmatrix.yumap(i)];
    XYnext = [subtrackmatrix.xumap(i+1),subtrackmatrix.yumap(i+1)];
    DXY = [XYnext(1) - XY(1), XYnext(2) - XY(2)];
    quiver(XY(1),XY(2),DXY(1),DXY(2),'color',[0 0 0],'LineWidth',2)
    
    % get cell picture
    pos = subtrackmatrix.pos(i);
    t = subtrackmatrix.t(i);
    cell = subtrackmatrix.cell(i);
    im_matrix = datamatrix(datamatrix.pos == pos & datamatrix.t == t & datamatrix.cell == cell,:);
    im_name = im_matrix.dirname;
    im = imread(string(im_name));
    if i ==1
        total_im = im;
        X = [XY(1)];
        Y = [XY(2)];
        C = [clusters(im_matrix.cluster)];
    end
    X = [X XYnext(1)];
    Y = [Y XYnext(2)];
   
    
    
    posnext = subtrackmatrix.pos(i+1);
    tnext = subtrackmatrix.t(i+1);
    cellnext = subtrackmatrix.cell(i+1);
    im_matrixnext = datamatrix(datamatrix.pos == posnext & datamatrix.t == tnext & datamatrix.cell == cellnext,:);
    im_namenext = im_matrixnext.dirname;
    imnext = imread(string(im_namenext));
    C = [C clusters(im_matrixnext.cluster)];
    imstrip = [im, imnext];
    total_im = [total_im, imnext];
    imtool(imstrip,[0.5,1.2])
    disp('cluster now')
    disp(im_matrix.cluster)
    disp('cluster next')
    disp(im_matrixnext.cluster)
    %keyboard
    
end

imtool(total_im,[0.5,1.2])
figure(100)
stem(1:numel(C),C,'filled','r')
xlim([0,numel(C)])
ylim([0,5])
set(gca, 'YTick', 1:5)
keyboard
%%
figure(2)
Z = 1:numel(X);
gscatter(datamatrix.xumap,datamatrix.yumap,datamatrix.group,[g0c;g1c;g2c;g3c;g4c;g5c;g6c;g7c;g8c;g9c;g10c;g11c],[],8)
hold on
camroll(-90)
scatter(X,Y,40,Z,'filled');colormap('copper')
legend('off')