clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
datadirfile = 'Dataset1CompleteAreaEdgeFluoCluster.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


matrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


cd(code_dir)
type = 3;
trial = 2;
matname = sprintf('ChosenINDtype%dtrial%d.mat',type,trial);
matrix = matrix(matrix.trial == trial &  matrix.type == type,:);

cd('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/mat')

%INDEX = [];
load(matname)
TotalDirname = matrix.dirname;
count = 0;
for cell = max(INDEX)+1:numel(TotalDirname)
%for cell = 1:numel(TotalDirname)
    count = count +1;
    ind = cell;
    %ind = randi([1,numel(TotalDirname)]);
    if ~ismember(ind,INDEX)
        im = imread(string(matrix.dirname(ind)));
        tifname = string(matrix.dirname(ind));
        tifname_mask = char(tifname);
        tifname_mask = strcat(tifname_mask(1:end-4),'_mask.jpg');
        im_mask = imread(tifname_mask);
        im_mask = im_mask > 100;
        %imtool(im_mask)
        imtool(im,[0,1.5])
        
        commandwindow;
        good = input('good? :');
        
        if good == 1
            INDEX = [INDEX ind];
        else
            disp('SKIP!')
        end
        
    end
    if rem(count,100) == 0
        
        save(['/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/mat/',matname],'INDEX')
        disp('saved')
        disp('File size:')
        disp(numel(INDEX))
        disp('%%%%%%%%%%%%')
        imtool close all
    end
    
    if rem(count,100) == 0
        imtool close all
    end
    
end