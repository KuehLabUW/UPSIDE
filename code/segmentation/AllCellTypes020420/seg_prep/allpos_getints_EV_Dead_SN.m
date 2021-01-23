% agglomerate
YFPoffset = 1000; %used to be 1000
RFPoffset = 2000; %used to be 2000
P = 278;
Pcustom = 1;
Pinitial = 142;
dirname = '/data/phnguyen/Imaging/RawData/111617 - processed/';

for p = 1:142    % loop over all the stage positions
   pos(p) = load([dirname 'pos ' num2str(p) '/segtrackintsdead2.mat']);  % load all the objects
end

T = length(pos(p).objects);   % the number of timepoints
clear('objects');

objects = [];
placeholders = [];
k = 1;
for t = 1:T    % loop through all timepoints
    t
    obj = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for p = 1:142   % loop through all stage positions
        obj1 = pos(p).objects(t).obj;
        for i = 1:length(obj1)   % loop through all objects
            obj1(i).data.p = p;
            % log transform all the data points
            obj1(i).data.logCFP = log10(obj1(i).data.CFPcor);
            obj1(i).data.logYFP = log10(max(obj1(i).data.YFPcor+YFPoffset,1));
            obj1(i).data.logRFP = log10(max(obj1(i).data.RFPcor+RFPoffset,1));       
        end    
        obj = [obj obj1];
    end
    
 
    if isstruct(obj) == 1
    tind = find([obj.trno]<=0)    % select only the cells picked out to be real
    obj(tind) = [];
    objects(t).obj = obj;
    else
        disp('This timepoint has false values as placeholders.')
        placeholders(k) = t;
        k = k+1;
        s = struct('area',{1},'perim',{1},'x',{1},'y',{1},'NIRcor',{1},'NIRraw',{1},'CFPcor',{1},'CFPraw',{1},'YFPcor',{1},'YFPraw',{1},'RFPcor',{1},'RFPraw',{1},'p',{1},'logCFP',{1},'logYFP',{1},'logRFP',{1});
        objects(t).obj = struct('m',{1},'n',{1},'trno',{1},'x',{1},'y',{1},'b',{[1 1]},'data',{s},'gate',{0});
    end
end
gatenames = {'ALL'};
save([dirname 'segtracksint_EV111617RatioDead2.mat'],'objects','gatenames');


  
    