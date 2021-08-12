%this function extracts subim
function M = getsubim_Texture(objects,im_1,im_Synth,im_CellTrace,pos,t,subim_name,subim_Texture_name,subim_Mask_name,subdirname)
    
    %substract image to its background
    h1 = fspecial('gaussian',[5 5], 5); % 2D guassian filter was 30
    %im_1 = imfilter(im_1,h1);
    
    im_Synth = imfilter(im_Synth,h1);
    im_SynthBW = imbinarize(im_Synth);
    
    im_1 = imresize(im_1,[1080,1080]);
    background = double(median(im_1(im_SynthBW)));
    
    im_1 = im_1 ./ background;
    
    %first watershed the celltrace to divide touching cells
    gauss_size = [60 60]; %size of gaussian 
    gauss_std = 10;
    h1 = fspecial('gaussian',gauss_size, gauss_std); % 2D guassian filter
    newim = imfilter(im_CellTrace,h1);
    L =watershed(-newim,8);
    im_CellTrace(L == 0) = 0;
    %create a structure to store name and ID info for each cells
    M = struct;
    
    %loop through each cell in the timepoint
    for c = 1:numel(objects(t).obj)
        
        d = 120;
        X = round(objects(t).obj(c).x);
        Y = round(objects(t).obj(c).y);
        top_left = [X - d/2, Y - d/2];
        top_right = [X + d/2 , Y - d/2];
        bottom_left = [X - d/2 , Y + d/2];
        bottom_right = [X + d/2 , Y + d/2];
        %keyboard
        try %only save cells that are not at edges
            %%%%%%%%%%%%%%%first get BF images
            sub_im = im_1(top_left(2):bottom_left(2)-1,top_left(1):top_right(1)-1);
            sub_im_og = imresize(sub_im,[64 64]);
          
              
            %%%%%%%%%%%%%%now get mask image and transform the BF the same
            %%%%%%%%%%%%%%way as the mask
            
            
            sub_im_CellTrace = im_CellTrace(top_left(2):bottom_left(2)-1,top_left(1):top_right(1)-1);
            subim_corr = (sub_im_CellTrace>1);
            %keyboard
            R = regionprops(subim_corr,'Area','Centroid','Orientation');
            %eliminate outlying objects base on distance to center
            D = [];
            if numel(R) > 1
               %disp('removing outlier')
               for r = 1:numel(R)
                center = [d/2,d/2];
                Dis_to_center = sqrt(sum((R(r).Centroid - center) .^ 2));
                D = [D Dis_to_center];
               end
               [value,idx] = min(D);
               L = bwlabel(subim_corr);
               idx_total = 1:1:numel(R);
               remove_idx = idx_total(idx_total~=idx);
               for r = 1:numel(remove_idx)
                   subim_corr(L == remove_idx(r)) = 0;
               end              
            end
            
            
            %recenter
            [rows,columns] = size(subim_corr);
            if numel(R) > 1
                rowsToShift = round(rows/2- R(idx).Centroid(2));
                columnsToShift = round(columns/2 - R(idx).Centroid(1));
                subim_corr = circshift(subim_corr, [rowsToShift columnsToShift]);
                sub_im = circshift(sub_im, [rowsToShift columnsToShift]); %shift BF
            else
                rowsToShift = round(rows/2- R.Centroid(2));
                columnsToShift = round(columns/2 - R.Centroid(1));
                subim_corr = circshift(subim_corr, [rowsToShift columnsToShift]);
                sub_im = circshift(sub_im, [rowsToShift columnsToShift]); %shift BF
            end
            
            %keyboard
            %reorientate to 90 degree
            og_dim = 120;
            big_dim = round(og_dim*sqrt(2)+5);

            if numel(R) > 1
                angleToRotate = 90 * R(idx).Orientation/abs(R(idx).Orientation) - R(idx).Orientation;
                subim_corr = imrotate(subim_corr,angleToRotate);
                sub_im = imrotate(sub_im,angleToRotate); %rotate BF
                try
                    %pad it out to an arbitrary size
                    [small_dimR,small_dimC] = size(subim_corr);
                    subim_corr = [subim_corr,false(small_dimR,big_dim-small_dimC)]; %add one column
                    subim_corr = [subim_corr;false(big_dim-small_dimR,big_dim)]; %add one row
                    
                    sub_im = [sub_im,zeros(small_dimR,big_dim-small_dimC)]; %add one column BF
                    sub_im = [sub_im;zeros(big_dim-small_dimR,big_dim)]; %add one row BF
                catch
                    disp('sths not right. R > 1')
                    keyboard
                end
                
                
            else
                angleToRotate = 90 * R.Orientation/abs(R.Orientation) - R.Orientation;
                subim_corr = imrotate(subim_corr,angleToRotate);
                sub_im = imrotate(sub_im,angleToRotate); %rotate BF
                try
                    %pad it out to an arbitrary size
                    [small_dimR,small_dimC] = size(subim_corr);
                    subim_corr = [subim_corr,false(small_dimR,big_dim-small_dimC)]; %add one column
                    subim_corr = [subim_corr;false(big_dim-small_dimR,big_dim)]; %add one row
                    
                    sub_im = [sub_im,zeros(small_dimR,big_dim-small_dimC)]; %add one column BF
                    sub_im = [sub_im;zeros(big_dim-small_dimR,big_dim)]; %add one row BF
                catch
                    disp('sth is not right. R = 1')
                    keyboard
                end
            end
            
            %remove outlier one more time base on area
            R = regionprops(subim_corr,'Area','Centroid','Orientation');
            A = [];
            if numel(R) > 1
                
               %disp('removing outlier')
               %keyboard
               for r = 1:numel(R)
                
                A = [A R(r).Area];
               end
               [value,idx] = max(A);
               L = bwlabel(subim_corr);
               idx_total = 1:1:numel(R);
               remove_idx = idx_total(idx_total~=idx);
               for r = 1:numel(remove_idx)
                   subim_corr(L == remove_idx(r)) = 0;
               end              
            end
            
            %recenter again!
            try
                if numel(R) > 1
                    [rows,columns] = size(subim_corr);
                    rowsToShift = round(rows/2- R(idx).Centroid(2));
                    columnsToShift = round(columns/2 - R(idx).Centroid(1));
                    subim_corr = circshift(subim_corr, [rowsToShift columnsToShift]);
                    sub_im = circshift(sub_im, [rowsToShift columnsToShift]); %shift BF
                else
                    [rows,columns] = size(subim_corr);
                    rowsToShift = round(rows/2- R.Centroid(2));
                    columnsToShift = round(columns/2 - R.Centroid(1));
                    subim_corr = circshift(subim_corr, [rowsToShift columnsToShift]);
                    sub_im = circshift(sub_im, [rowsToShift columnsToShift]); %shift BF
                end
            catch
                disp('sth is not right. Recenter')
                keyboard
            end
            
            %resize back to 64x64
            try
                subim_corr = imresize(subim_corr,[64 64]);
                sub_im = imresize(sub_im,[64 64]);
            catch
                disp('sth is not right. Resize back')
                keyboard
            end
            cd('/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrial1/')
            %reorientate horizontally; file getSkewnessCenteredBW2D.m is in
            %the above directory
            Shorizontal = getSkewnessCenteredBW2D(subim_corr,1);
            if Shorizontal < 0 
               subim_corr = flip(subim_corr,1);
               sub_im = flip(sub_im,1); %flip BF
            end
           
            %reorientate vertically
            Svertical = getSkewnessCenteredBW2D(subim_corr,2);
            if Svertical < 0 
               subim_corr = flip(subim_corr,2);
               sub_im = flip(sub_im,2);
            end
            
            
            
            %combine BF and mask images together
            %keyboard
            
            
            sub_im2 = sub_im(sub_im>0.6); % only consider image with relevant pixels                      
            sub_im = (sub_im - mean(sub_im2(:)))./std(sub_im2(:)); %set mean to 0 and unit variance
            
            sub_im = linmap(sub_im,-5,5,0,1);
           
            
            sub_im = sub_im .* (subim_corr);
            sub_im(sub_im == 0) = 0.5;
            %keyboard
            
            %save subim in subdir bf
            cd(subdirname)
            subim_name_updated = sprintf(subim_name,pos,t,c);
            
            S = Tiff(subim_name_updated,'w');
            setTag(S,'Photometric',Tiff.Photometric.MinIsBlack);
            setTag(S,'Compression',Tiff.Compression.None);
            setTag(S,'BitsPerSample',32);
            setTag(S,'SamplesPerPixel',1);
            setTag(S,'SampleFormat',Tiff.SampleFormat.IEEEFP);
            setTag(S,'ExtraSamples',Tiff.ExtraSamples.Unspecified);
            setTag(S,'ImageLength',64);
            setTag(S,'ImageWidth',64);
            setTag(S,'TileLength',32);
            setTag(S,'TileWidth',32);
            setTag(S,'PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
            write(S,sub_im_og)
            
            subim_Texture_name_updated = sprintf(subim_Texture_name,pos,t,c);
            
            V = Tiff(subim_Texture_name_updated,'w');
            setTag(V,'Photometric',Tiff.Photometric.MinIsBlack);
            setTag(V,'Compression',Tiff.Compression.None);
            setTag(V,'BitsPerSample',32);
            setTag(V,'SamplesPerPixel',1);
            setTag(V,'SampleFormat',Tiff.SampleFormat.IEEEFP);
            setTag(V,'ExtraSamples',Tiff.ExtraSamples.Unspecified);
            setTag(V,'ImageLength',64);
            setTag(V,'ImageWidth',64);
            setTag(V,'TileLength',32);
            setTag(V,'TileWidth',32);
            setTag(V,'PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
            write(V,sub_im)
            
            subim_Mask_name_updated = sprintf(subim_Mask_name,pos,t,c);
            
            imwrite(subim_corr,subim_Mask_name_updated,'jpg')
            
            
            %Add cell info to struture
            M(c).dir = strcat(subdirname,subim_name_updated);
            M(c).pos = pos;
            M(c).t   = t;
            M(c).cell = c;
            M(c).Xcenter  = round(objects(t).obj(c).x,2);
            M(c).Ycenter  = round(objects(t).obj(c).y,2);
            
        catch
            %disp('cells at edges! Skip!')
            %keyboard
        end
        %keyboard
        
    end
    
    %save struct data
    %mats_name = 'subim_set_pos%d_t%d.mat';
    %mats_name = sprintf(mats_name,pos,t);

    %save(strcat(mats_dirname,mats_name),'M');
    
    
end
