%this function returns annulus of an object
function annulus = getannulus(regionprops,c,expansion_scale,mask_threshold,im_Synth,im_fluo)
    
    r = regionprops; %regionprops gives boundary of the cell
    scale = expansion_scale; %specifies how much more enlarged the bounding box will be
    
    %get the dimensions for the image patch of the cell
    TopLeft = [round(r(c).BoundingBox(1)),round(r(c).BoundingBox(2))]; %(X,Y)
    Xlength = r(c).BoundingBox(4);
    Ylength = r(c).BoundingBox(3);
    
    %expand the size of this patch according to scaling if cell isn't on
    %the border
    try
        s_TopLeft = [round(TopLeft(1)-r(c).BoundingBox(1)*scale),round(TopLeft(2)-r(c).BoundingBox(2)*scale)];
        s_Xlength = Xlength + round(2*r(c).BoundingBox(1)*scale);
        s_Ylength = Ylength + round(2*r(c).BoundingBox(2)*scale);
    
        %get the scaled patch
    
        s_subimSynth = im_Synth(s_TopLeft(2):s_TopLeft(2)+s_Ylength,s_TopLeft(1):s_TopLeft(1)+s_Xlength);
        s_subimfluo = im_fluo(s_TopLeft(2):s_TopLeft(2)+s_Ylength,s_TopLeft(1):s_TopLeft(1)+s_Xlength);
    
        %define the shape of the cells according to NN cell signal
        mask = (s_subimSynth > mask_threshold);
    
        %define the size of the expansion of the annulus and dilate
        se = strel('disk',6);   % disk of radius five for background estimation
        mask_big = imdilate(mask,se); %dilate
    
        %get the annulus mask and calculate the fluorescence
        mask_annulus = logical(mask_big .* (~mask));
        annulus = double(median(s_subimfluo(mask_annulus)));
        
    catch
        annulus = -1;
    end
    %keyboard

end