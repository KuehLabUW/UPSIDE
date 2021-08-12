function getdata_fluo(objects,pos,dirname,segfunc_name,BF_name,wSynth_name,w2_name,w3_name)

%Creates structure to store data
MM = []; %this to store subim

%loop through all timepoints
for t = 1:numel(objects)
    
    
    %% opens up brightfield (and Synth) image for subim extraction
    BF_name_update = sprintf(BF_name,pos,t);
    im1_name = strcat(dirname.raw_tif,BF_name_update);
    im_1 = single(imread(im1_name));
    
    wSynth_name_update = sprintf(wSynth_name,pos,t);
    imSynth_name = strcat(dirname.raw_tif,wSynth_name_update);
    im_Synth = single(imread(imSynth_name));
    
    w2_name_update = sprintf(w2_name,pos,t); %LDI 640
    im2_name = strcat(dirname.raw_tif,w2_name_update);
    
    
    w3_name_update = sprintf(w3_name,pos,t); %LDI 555
    im3_name = strcat(dirname.raw_tif,w3_name_update);
    
    %% extract fluorescence data
    if exist(im2_name) %check only w2 but can do this separately if needed
        im_2 = single(imread(im2_name));
        im_3 = single(imread(im3_name));
    
        cd(dirname.script)
        M = get_fluo(objects,segfunc_name,im_Synth,im_2,im_3,pos,t);
        %% Add data to the master matrices
        %keyboard
        MM = [MM M];
    end
    
    
    
    disp('#####')
    fprintf('done with t %d\n',t);
    disp('#####')
    
end

 %% save MM as csv
 cd(dirname.script)
 csvname = sprintf('fluoAML211Trial1pos%d.csv',pos);
 %keyboard
 save_csvfrommatfluo(MM,csvname,dirname) %this function needs exactly 6 fields
                                     %in struct
    

end