% script to test annulus background subtraction method 
% proces image 111
channels = [2 3 4];  % these are the channels to process 
%% structuring element parameters
se1 = strel('disk',3);   % disk of radius two for excluding outer fluorescence rim.
se2 = strel('disk',6);   % disk of radius five for background estimation
cd('/data/phnguyen/Imaging/RawData/111617 - processed');
P = 278;  % total number of stage positions;
name_channel = {'CFP' 'YFP' 'RFP'}; % channel names

for p = 1:P    % loop over all the stage positions   
    cd(['pos ' num2str(p)]);
    %% load the requisite files
    load('acq.mat');
    load('segtrackints.mat');   % load
    
    for t = 1:acq.T    % go through all the time points in an image        
        obj = objects(t).obj;   % objects from this given time point
        b1 = zeros(acq.Y, acq.X);   % initially binary image for segmentation
        for i = 1:length(obj)  % loop through all the images in movie
            b = obj(i).b;
            ind = sub2ind(size(b1), b(:,1), b(:,2));
            b1(ind) = i;    % binary labeled image that can be used for regionprops
        end
        
        b2 = imfill(b1,'holes');   % interior cell image       
        load(['imgf_' num2str(t,'%04d') '.mat']); % load images
        
        % now, assume that object ordering for original and annulus image is the same
        
        c = channels(2);  % the channel number
        im = double(images(c).im);  % this is the image for background subtraction
        b2 = bwlabel(b2);
        r = regionprops(b2,im,'Area', 'Perimeter', 'MeanIntensity','BoundingBox','PixelValues');  % object properties of interior
        n =2 ;% the number of standard deviation about the mean for thresholding
        se = strel('disk',2);
        for j = 1:length(obj)  % loop through all objects at time point
            %cor = (r(j).MeanIntensity - median(rb(j).PixelValues)) * r(j).Area;
            %raw = r(j).MeanIntensity * r(j).Area;
            %obj(j).data.([name 'cor']) = cor;
            %obj(j).data.([name 'raw']) = raw;
            %%%%%%% Code for identifying dead cells
            m_obj = mean(r(j).PixelValues);
            s_obj = std(r(j).PixelValues);
            threshold = m_obj + n*s_obj;
            
            imin = r(j).BoundingBox(2);
            jmin = r(j).BoundingBox(1);
            imax = imin+r(j).BoundingBox(4);
            jmax = jmin+r(j).BoundingBox(3);
            
            subim = im(imin:imax, jmin:jmax);
            subim2 = (subim > threshold);
            
            subim3 = imopen(subim2, se);
            obj(j).data.punctaarea = sum(subim3(:));
        end
        objects(t).obj = obj;
    end
      
   
    save('segtrackintsdead.mat','gatenames','objects');
    clear('objects','gatenames','acq');
    cd '..'
end

        
        
    
    



