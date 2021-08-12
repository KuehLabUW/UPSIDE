%this script show a sample of image patches specified in gate file
clear
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/mat/';
gatefilename = 'gate_cluster10.mat';
load(strcat(root_dir,gatefilename));
%%
showgate = 'root:G';

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
num_im =2;
%num_im = numel(TotalInfo);
TotalDirname =[];

num = numel(TotalInfo);
patch_ind = randi([1,num],1,num_im);

TotalIm = [];
TotalIm_mask = [];
Totaltime = [];
picked_Info = TotalInfo(patch_ind);
for k = 1:numel(picked_Info)
    info = picked_Info(k);
    tifname = string(objects(info.t).obj(info.cell).dir);
    im = imread(tifname);
    
    tifname_mask = char(tifname);
    tifname_mask = strcat(tifname_mask(1:end-4),'_mask.jpg');
    im_mask = imread(tifname_mask);
    im_mask = im_mask > 100;
    
    Totaltime = [Totaltime info.t];
    TotalIm = cat(3,TotalIm,im);
    TotalIm_mask = cat(3,TotalIm_mask,im_mask);
    
    TotalDirname = [TotalDirname;tifname];
end    
%picked_im = TotalIm(:,:,patch_ind);
figure(26)
montage(TotalIm),imcontrast()
%figure(24)
%montage(TotalIm_mask)

cd(root_dir)

%figure (100)
%histogram(Totaltime)

