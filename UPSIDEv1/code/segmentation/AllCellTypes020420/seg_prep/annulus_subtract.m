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
    load('segtrack.mat');   % load
    
    for t = 1:acq.T    % go through all the time points in an image        
        obj = objects(t).obj;   % objects from this given time point
        b1 = zeros(acq.Y, acq.X);   % initially binary image for segmentation
        for i = 1:length(obj)  % loop through all the images in movie
            b = obj(i).b;
            ind = sub2ind(size(b1), b(:,1), b(:,2));
            b1(ind) = i;    % create a labeled 'NIR'image that can also be used for morphological image processing!
        end
        
        b2 = imfill(b1,'holes');   % interior cell image
        b_small = imdilate(b2,se1);  % segmented image for inner rim
        b_big = imdilate(b2,se2);   % segmented image for outer rim
        b4 = b_big .* (~b_small);    % subtract the interior image from the outside
        
        load(['imgf_' num2str(t,'%04d') '.mat']); % load images
        
        % now, assume that object ordering for original and annulus image is the same
        for i = 1:length(channels);
            c = channels(i);  % the channel number
            name = name_channel{i};  % the name of the channel
            im = double(images(c).im);  % this is the image for background subtraction
            r = regionprops(b2,im,'MeanIntensity','Area');  % object properties of interior
            rb = regionprops(b4,im,'PixelValues');  % object properties of annulus
            
            for j = 1:length(obj)  % loop through all objects at time point
                cor = (r(j).MeanIntensity - median(rb(j).PixelValues)) * r(j).Area;
                raw = r(j).MeanIntensity * r(j).Area;
                obj(j).data.([name 'cor']) = cor;
                obj(j).data.([name 'raw']) = raw;
                %subplot(2,2,i)
                %text(obj(j).data.x, obj(j).data.y, ['c=' num2str(cor,2) ',raw=' num2str(raw,2)],'Color','r')
            end
        end
        objects(t).obj = obj;
    end
    
    save('segtrackints.mat','gatenames','objects');
    clear('objects','gatenames','acq');
    cd '..'
end

        
        
    
    



