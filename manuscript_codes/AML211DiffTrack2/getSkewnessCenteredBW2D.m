%this function take in a Centered BW image and return a skewness value
%along the indicated axis
function S = getSkewnessCenteredBW2D(Image,dim)
    Image = double(Image);
    %get the mid line for the image
    [dimY dimX] = size(Image);
    midX = dimX/2;
    midY = dimY/2;
    %%%%
    if dim == 1
        SdataY = [];
        for d = 1:dimY
            datanum = sum(Image(d,:));
            scaled_datanum = d.*ones(datanum,1);
            SdataY = [SdataY;scaled_datanum];  
        end
        S = skewness(SdataY);
    elseif dim == 2
       SdataX = [];
        for d = 1:dimX
            datanum = sum(Image(:,d));
            scaled_datanum = d.*ones(datanum,1);
            SdataX = [SdataX;scaled_datanum];  
        end
        S = skewness(SdataX);
    end

end