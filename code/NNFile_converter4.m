%this code converts NN predicted image output and put them into folders
%with MM format
%ready for segmentation

%USER-DEFINED INPUTS
in_directory = '/external/pytorch_fnet-master/pytorch_fnet/results/3d/20191114_KA_train/2019_KA_topredict_pos1_5_new'     %enter the directory with the predicted images
out_folder = 'Converted'                %enter name of folder to save converted images into
out_directory = ['/external/Kathleen/2019_KA_topredict_pos1_5_new/' out_folder]  
no_tps_vec = [2,159,324,473,12, 170];     %enter the number of time points in your movie
no_pos = 5      %enter the number of positions you have
total = no_tps*no_pos       %calcualte total number of predicted images
image_name = 'w5LDI 405.tiff'          %enter the name of your predicted images
basename = ['20191107', '20191107_2', '20191107_4', '20191107_5', '20191107_6', '20191107_7'];   %Enter basename for the dataset, adding a channel for the predicted images

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
for k = 1:length(no_tps_vec)

    no_tps = no_tps_vec(k)
timepoints = 1:1:no_tps;
positions = 1:1:no_pos;
dirname = 0:1:total;
mkdir(out_directory)

i = 0;
for p =1
    for t = 1:10
       i = i + 1; %file name count
       %specify the directory of your predicted images, keep the '/0%d' as is!   
       filename = [in_directory '/0%d'];
       filename = sprintf(filename,dirname(i));
       display(dirname(i))
       cd(filename)
       signal = imread('signal.tiff');
       %Enter the name of your predictive images here
       predict = imread(image_name);
            
       %resize images back to original dimension
       signal = imresize(signal, [1080 1080]);
       predict = imresize(predict, [1080 1080]);
            
       %save image with MM name. Enter your new directory or the directory of the rest of your MM images 
       cd(out_directory)
       % enter the MM name of your synthetic images
       predict_name = [basename '_s%d_t%d.TIF'];
       predict_name = sprintf(predict_name,positions(p),timepoints(t));
       
       %%% You can remove this section if you don't want to save the resized BF images
       S = Tiff(predict_name,'w');
       setTag(S,'Photometric',Tiff.Photometric.MinIsBlack);
       setTag(S,'Compression',Tiff.Compression.None);
       setTag(S,'BitsPerSample',32);
       setTag(S,'SamplesPerPixel',1);
       setTag(S,'SampleFormat',Tiff.SampleFormat.IEEEFP);
       setTag(S,'ExtraSamples',Tiff.ExtraSamples.Unspecified);
       setTag(S,'ImageLength',1080);
       setTag(S,'ImageWidth',1080);
       setTag(S,'TileLength',32);
       setTag(S,'TileWidth',32);
       setTag(S,'PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
       write(S,predict)
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
%%
for p =1
    for t = 11:numel(timepoints)
       i = i + 1; %file name count  
       filename = [in_directory '/%d'];
       filename = sprintf(filename,dirname(i));
       display(dirname(i))
       cd(filename)
       signal = imread('signal.tiff');
       predict = imread(image_name);
            
       %resize images back to original dimension
       signal = imresize(signal, [1080 1080]);
       predict = imresize(predict, [1080 1080]);
            
       %save image with MM name
       cd(out_directory)
       predict_name = [basename '_s%d_t%d.TIF'];
       predict_name = sprintf(predict_name,positions(p),timepoints(t));
       
       S = Tiff(predict_name,'w');
       setTag(S,'Photometric',Tiff.Photometric.MinIsBlack);
       setTag(S,'Compression',Tiff.Compression.None);
       setTag(S,'BitsPerSample',32);
       setTag(S,'SamplesPerPixel',1);
       setTag(S,'SampleFormat',Tiff.SampleFormat.IEEEFP);
       setTag(S,'ExtraSamples',Tiff.ExtraSamples.Unspecified);
       setTag(S,'ImageLength',1080);
       setTag(S,'ImageWidth',1080);
       setTag(S,'TileLength',32);
       setTag(S,'TileWidth',32);
       setTag(S,'PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
       write(S,predict)
    end
end
%%
for p =2:numel(positions)
    for t = 1:numel(timepoints)
       i = i + 1; %file name count  
       filename = [in_directory '/%d'];
       filename = sprintf(filename,dirname(i));
       display(dirname(i))
       cd(filename)
       signal = imread('signal.tiff');
       predict = imread(image_name);
            
       %resize images back to original dimension
       signal = imresize(signal, [1080 1080]);
       predict = imresize(predict, [1080 1080]);
            
       %save image with MM name
       cd(out_directory)
       predict_name = [basename '_s%d_t%d.TIF'];
       predict_name = sprintf(predict_name,positions(p),timepoints(t));
       
       S = Tiff(predict_name,'w');
       setTag(S,'Photometric',Tiff.Photometric.MinIsBlack);
       setTag(S,'Compression',Tiff.Compression.None);
       setTag(S,'BitsPerSample',32);
       setTag(S,'SamplesPerPixel',1);
       setTag(S,'SampleFormat',Tiff.SampleFormat.IEEEFP);
       setTag(S,'ExtraSamples',Tiff.ExtraSamples.Unspecified);
       setTag(S,'ImageLength',1080);
       setTag(S,'ImageWidth',1080);
       setTag(S,'TileLength',32);
       setTag(S,'TileWidth',32);
       setTag(S,'PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
       write(S,predict)
    end
end
