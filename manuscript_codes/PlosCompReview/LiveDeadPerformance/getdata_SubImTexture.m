function getdata_SubImTexture(objects,pos,dirname,BF_name,wSynth_name,wCellTrace_name)

%Creates structure to store data
MM = []; %this to store subim

%loop through all timepoints
for t = 1:numel(objects)
    
    
    
    %% make subdir for each time point if haven't already
    subdirname = strcat(dirname.subim_tif,sprintf('pos%d/t%d/',pos,t));
    if exist(subdirname)
        disp('dir already exist!')
        cd(subdirname)
    else
        mkdir(subdirname)
        cd(subdirname)
    end
    
    %% opens up brightfield (and Synth) image for subim extraction
    BF_name_update = sprintf(BF_name,pos,t);
    im1_name = strcat(dirname.raw_tif,BF_name_update);
    im_1 = single(imread(im1_name));
    
    wSynth_name_update = sprintf(wSynth_name,pos,t);
    imSynth_name = strcat(dirname.raw_tif,wSynth_name_update);
    im_Synth = single(imread(imSynth_name));
    
    wCellTrace_name_update = sprintf(wCellTrace_name,pos,t);
    imCellTrace_name = strcat(dirname.raw_tif,wCellTrace_name_update);
    im_CellTrace = single(imread(imCellTrace_name));
    
    %% extract subim from BF picture
    subim_name = 'AML211DiffTrial1_pos%d_t%d_c%d.TIF';
    subim_Texture_name = 'AML211DiffTrial1_pos%d_t%d_c%d_texture.TIF';
    subim_Mask_name = 'AML211DiffTrial1_pos%d_t%d_c%d_mask.jpg';
    
    cd(dirname.script)
    
    M = getsubim_Texture(objects,im_1,im_Synth,im_CellTrace,pos,t,subim_name,subim_Texture_name,subim_Mask_name,subdirname);
    
    %% Add data to the master matrices
    
    if numel(fieldnames(M)) > 0 %only add instances with nonzero number of objects
        MM = [MM M];
    end
    
    disp('#####')
    fprintf('done with t %d\n',t);
    disp('#####')
    
end

 %% save MM as csv
 cd(dirname.script)
 csvname = sprintf('SubImTextureAML211DiffTrial1pos%d.csv',pos);
 %keyboard
 if numel(fieldnames(M)) > 0 %only add instances with nonzero number of objects
    save_csvfrommat(MM,csvname,dirname) %this function needs exactly 6 fields
 else
     disp('Empty Position!')
 end

end
