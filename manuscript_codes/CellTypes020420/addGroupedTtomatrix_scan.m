clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/CellTypes020420/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/';

matfile = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/mat/ClusterScan.mat';
datadirfile = 'ClusteredTypesChosen.csv';
datacolumn = 213;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
datamatrix_short = datamatrix(:,1:14);
load(matfile)

cd(code_dir)


for c = 1:numel(Cluster)
    disp(c)
    %% first save a csv file detailing the members of each group
    maxnow = 0;
    for i = 1:numel(Cluster(c).group)
        maxnext = numel(Cluster(c).group(i).clustermember);
        if maxnext > maxnow
            maxnow = maxnext;
        end
    end
    Gmember = zeros(numel(Cluster(c).group),maxnow)+2000;
    
    for i = 1:numel((Cluster(c).group))
        for j = 1:numel((Cluster(c).group(i).clustermember))
            fname = char((Cluster(c).group(i).clustermember(j)));
            Gmember(i,j) = str2double(fname(2:end));
        end
    end
    writematrix(Gmember,sprintf('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/ClusterScan/Clustermemberset%d.csv',c))
    %continue
    %% now export datamatrix with groupedTexture
    for i =  1:numel(Cluster(c).group)
        trow = Gmember(i,:);
        trow = trow(trow< 2000);
        eval(sprintf('T%d = 113 +trow;',i))
        eval(sprintf('T%dall = [];',i))
        for j = 1:height(datamatrix)
            eval(sprintf('T%dall = [T%dall mean(table2array(datamatrix(j,T%d)))];',i,i,i))
        end
        eval(sprintf('datamatrix_short.T%d = transpose(T%dall);',i,i))   
    end
    writetable(datamatrix_short,sprintf('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/ClusterScan/datamatrixGroupT%d.csv',c))
    %keyboard
end
%%



