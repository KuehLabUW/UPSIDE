% script to test annulus background subtraction method 
% proces image 111
channels = [2 3 4];  % these are the channels to process 
%% structuring element parameters
cd('/data/phnguyen/Imaging/RawData/111617 - processed');
P = 278;  % total number of stage positions;


for x = 1:P    % loop over all the stage positions
    cd(['pos ' num2str(x)]);
    %% load the requisite files
    load('acq.mat');
    load('segtrackints.mat')
    
    for t = 1:acq.T    % go through all the time points in an image        
        load(['imgf_' num2str(t,'%04d') '.mat']); % load images
        obj = objects(t).obj;
        
        c = 2;  % the channel number
        im = double(images(c).im);  % this is the image for background subtraction
        im1 = double(images(1).im);
        im = double(im);
        cd('/data/phnguyen/Imaging/code/111617_EV_cMyc')
        seg = cellseg122017(im);
        cd('/data/phnguyen/Imaging/RawData/111617 - processed');
        cd(['pos ' num2str(x)]);
        r = regionprops(seg,im,'Area', 'Perimeter', 'MeanIntensity','BoundingBox','PixelValues');  % object properties of interior
        n =2 ;% the number of standard deviation about the mean for thresholding
        se = strel('disk',2);
        punctaarea = [];

        h1 = fspecial('gaussian',[7 7], 3);
        unsharp_alpha = 0.8;
        h2 = fspecial('laplacian', unsharp_alpha);
        low_in = 100/600; % lowest intensity input value for cell regonition 
        low_out = 0; % adjusted low intensity output
        high_in = 300/600; % higest intensity input value to guarantee cell
        high_out = 1; % adjusted high intensi)ty output
        punctanumber = [];
        for j = 1:length(r)  % loop through all objects at time point
            obj(j).data.GeneralArea = r(j).Area;
            obj(j).data.GeneralPerimeter = r(j).Perimeter;
            obj(j).data.GeneralMeanIntensity = r(j).MeanIntensity;
            obj(j).data.logMeanIntensity = log(r(j).MeanIntensity);%%%
            %%%%%%% Code for identifying dead cells
            m_obj = mean(r(j).PixelValues);
            s_obj = std(r(j).PixelValues);
            threshold = m_obj + n*s_obj;
            
            imin = r(j).BoundingBox(2);
            jmin = r(j).BoundingBox(1);
            imax = imin+r(j).BoundingBox(4);
            jmax = jmin+r(j).BoundingBox(3);
            
            subim = im(imin:imax, jmin:jmax);
            %imtool(subim);
            subim2 = (subim > threshold);
            subim3 = imopen(subim2, se);
            punctaarea(j) = sum(subim3(:));
            C = regionprops(subim3,'Area','Centroid','BoundingBox','Perimeter');
            %Record Cutoff Filter data
            obj(j).data.Cutoffpunctaarea = punctaarea(j);
            obj(j).data.CutoffPunctaNumber = numel(C);
            
            %Look for 'granules' within the recognize 'dead' cell. True
            %dead cell should have > 1 granules
            
            i1 = imfilter(subim,h1);   % gaussian blurr image
            i3 = imfilter(i1,h2);      % edge detection
            i4 = imopen(i3.*(-1),se);  % get rid out noise
            %i5 = i4 > 5;               % threshold to get rid of more noise
            %i5 = i4 > 0;               % threshold to get rid of more noise
	    i5 = i4 > mean(i4(:));
            i6 = imfill(i5,'holes');   % fill holes in image
            
            %imtool(i6)
            
            
            p = regionprops(i6,'Area','Centroid','BoundingBox','Perimeter');       
            punctanumber(j) = numel(p);% count how many granules there are
            
            %Eliminate outlying (fake) puncta
            % first get size of the dead cell
            ImageSize = size(i6);
            I = ImageSize(1);
            J = ImageSize(2);
            % define a 'outlying zone'
            k = 5/100;
            dI = I*k;
            dJ = J*k;
            % check to see if each granule centroid falls in outlying zone
            % if so remove that granule
            area = [];
            perimeter = [];
            for i = 1:numel(p)
                loc = p(i).Centroid; %loc(2) is i (row); loc(1) is j (column)
                if     (0<=loc(2) && loc(2)<= dI) && (0<=loc(1) && loc(1)<=J)
                    punctanumber(j) = punctanumber(j) - 1;
                    disp('Get I')
                elseif (0<=loc(2) && loc(2)<=I) && ((J-dJ)<=loc(1) && loc(1)<=J)
                    punctanumber(j) = punctanumber(j) - 1;
                    disp('Get II')
                elseif ((I-dI)<=loc(2) &&loc(2)<=I) && (0<=loc(1) && loc(1)<=J)
                    punctanumber(j) = punctanumber(j) - 1;
                    disp('Get III')
                elseif (0<=loc(2) && loc(2)<=I) && (0<=loc(1) && loc(1)<=dJ)
                    punctanumber(j) = punctanumber(j) - 1;
                    disp('Get IV')
                else
                    area = [area p(i).Area];
                    perimeter = [perimeter p(i).Perimeter];
                 end
            
            end
            %report Lapacian data
            obj(j).data.LapacianPunctaNumber = punctanumber(j);
            if punctanumber(j) ~= 0
            	ma = mean(area);
		mp = mean(perimeter);
	    else
		ma = 0;
		mp = 0;
            end

            obj(j).data.LapacianMeanPunctaArea = ma(1);
            obj(j).data.LapacianMeanPunctaPerimeter = mp(1);
        end
        objects(t).obj = obj;
        
    end
     
   
    save('segtrackintsdead2.mat','gatenames','objects');
    clear('objects','gatenames','acq');
    cd '..'
end

        
        
    
    



