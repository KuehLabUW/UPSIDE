clear
%plot all the size properties of segmented objects
positions = 1:1:36;
Timepoints = 1:1:3337;
maindir = '/media/phnguyen/Data2/Imaging/RawData/Kasumi_1CellTrace080518BF_DAPI_PI - processed/';
dir = '/media/phnguyen/Data2/Imaging/RawData/Kasumi_1CellTrace080518BF_DAPI_PI - processed/pos %d';
Area = [];
Perim = [];
PI = [];

for p = 1:numel(positions)
   workdir = sprintf(dir,positions(p));
   cd(workdir);
   load('segment.mat')
   for t = 1:numel(Timepoints)
       for o = 1:numel(objects(t).obj)
           Area = [Area objects(t).obj(o).data.area];
           Perim = [Perim objects(t).obj(o).data.perim];
           PI = [PI objects(t).obj(o).data.PIsignal];
           %keyboard
       end
   end
   cd(maindir)
end

Shape = Perim./Area;