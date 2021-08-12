%This function collects raw and adjusted pixel intensity for an image and
%saves that to a mat file; currently supports 2 fluorescence channels
function Mfluo = get_fluo(objects,segfunc_name,im_Synth,im_2,im_3,pos,t)

    %create a structure to store fluorescence int and ID info for each cells
    Mfluo = struct;
    
    %segment the synthetic image to get mean intensity and boundary info
    seg_im = feval(segfunc_name,im_Synth);
    W2r = regionprops(seg_im,im_2,'Centroid','BoundingBox','MeanIntensity');
    W3r = regionprops(seg_im,im_3,'Centroid','BoundingBox','MeanIntensity');
    
    
    %loop through each cell
    for c = 1:numel(W2r)
        
        %get intensity values for first fluo channel 
        w2_annulus = getannulus(W2r,c,0,0.6,im_Synth,im_2); %(regionprops,c,expansion_scale,mask_threshold,im_Synth,im_fluo)
        w2_APC_corr = W2r(c).MeanIntensity - w2_annulus;
        w2_APC      = W2r(c).MeanIntensity;
        if w2_APC_corr < 0
            w2_APC_corr = 0;
        end
        %get intensity values for second fluo channel 
        w3_annulus = getannulus(W3r,c,0,0.6,im_Synth,im_3);
        w3_PE_corr = W3r(c).MeanIntensity - w3_annulus;
        w3_PE      = W3r(c).MeanIntensity;
        if w3_PE_corr < 0
            w3_PE_corr = 0;
        end
        
        if w2_annulus == -1 %skip if cells are at the edge
            
            continue
        
        else
            %find index of the obj object that have the same x y centroid
            for index = 1:numel(objects(t).obj)
                if W2r(c).Centroid(1) == objects(t).obj(index).x && W2r(c).Centroid(2) == objects(t).obj(index).y
                    %add the data into struct
                    Mfluo(index).pos = pos;
                    Mfluo(index).t = t;
                    Mfluo(index).cell = index;
                    Mfluo(index).Xcenter  = round(objects(t).obj(index).x,2);
                    Mfluo(index).Ycenter  = round(objects(t).obj(index).y,2);
        
                    Mfluo(index).w2_APC_corr = w2_APC_corr;
                    Mfluo(index).w2_APC = w2_APC;
        
                    Mfluo(index).w3_PE_corr = w3_PE_corr;
                    Mfluo(index).w3_PE = w3_PE;
                    break
                end    
            end
            
        end
    end
    
    %save struct data
    %mats_name = 'fluo_set_pos%d_t%d.mat';
    %mats_name = sprintf(mats_name,pos,t);

    %save(strcat(mats_dirname,mats_name),'Mfluo');

end
