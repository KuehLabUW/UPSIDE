%this script show a sample of image patches specified in gate file
clear
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/mat/';
gatefilename = 'gates_mask.mat';
load(strcat(root_dir,gatefilename));
%%
showgate = 'root:good';

%find gate numberobjects
for i = 1:numel(gatenames)
    if strcmp(showgate,char(gatenames(i))) == 1
        gate_ind = i-1;
        break
    end
    
end


%go through the table and get the images
%TotalIm = [];
TotalInfo =[];
for t = 1:numel(objects)
    disp(t)
    for cell = 1:numel(objects(t).obj)
        if objects(t).obj(cell).gate == gate_ind
            info.t = t;
            info.cell = cell;
            TotalInfo = [TotalInfo info];
            
        end
    end
end

%show image patch
num_im = numel(TotalInfo);
%num_im = numel(TotalInfo);
TotalDirname =[];

num = numel(TotalInfo);


Totalcell = [];
Totalpos  = [];
Totaltime = [];
TotalDirname = [];
picked_Info = TotalInfo;
for k = 1:numel(picked_Info)
    info = picked_Info(k);
    tifname = string(objects(info.t).obj(info.cell).dir);

    
    %tifname_mask = char(tifname);
    %tifname_mask = strcat(tifname_mask(1:end-4),'_mask.jpg');
        
    %Totaltime = [Totaltime;info.t];
    %Totalcell = [Totalcell;info.cell];
    
    TotalDirname = [TotalDirname;tifname];
end
dirname = TotalDirname;
T = table(dirname);
writetable(T,'/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/LIVE_subgate_new.csv')

