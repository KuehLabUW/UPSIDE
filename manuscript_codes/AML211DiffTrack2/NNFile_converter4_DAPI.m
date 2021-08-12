clear
%this code converts NN predicted image output and put them into folders
%with MM format
%ready for segmentation

%enter the number of time points in your movie
%first_timepoint:1:last_timepoint)
timepointsA = 1:1:1041;

%enter the number of positions you have
%1:1:number_of_positions
positionsA = 1:1:6;

%enter the number of BF images that were predicted
%1:1:number_of_predictive_images
dirname = 0:1:1041*6-1;

i = 0;

%%
for p =1
    for t = 1:10
       i = i + 1; %file name count
       %specify the directory of your predicted images, keep the '/0%d' as is!   
       filename = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/results/3d/AllCellTypesDAPItrain/testDiffTrack2/0%d';
       filename = sprintf(filename,dirname(i));
       display(dirname(i))
       cd(filename)
       signal = imread('signal.tiff');
       %Enter the name of your predictive images here
       predict = imread('prediction_AllCellTypesDAPItrain.tiff');
            
       %resize images back to original dimension
       signal = imresize(signal, [1080 1080]);
       predict = imresize(predict, [1080 1080]);
            
       %save image with MM name. Enter your new directory or the directory of the rest of your MM images 
       cd '/media/phnguyen/Data2/TempDAPI/'
       % enter the MM name of your synthetic images
       predict_name = 'EXPTrial2_w2Camera DAPI_s%d_t%d.TIF';
       predict_name = sprintf(predict_name,positionsA(p),timepointsA(t));
       
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
    for t = 11:numel(timepointsA)
       i = i + 1; %file name count  
       filename = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/results/3d/AllCellTypesDAPItrain/testDiffTrack2/%d';
       filename = sprintf(filename,dirname(i));
       display(dirname(i))
       cd(filename)
       signal = imread('signal.tiff');
       predict = imread('prediction_AllCellTypesDAPItrain.tiff');
            
       %resize images back to original dimension
       signal = imresize(signal, [1080 1080]);
       predict = imresize(predict, [1080 1080]);
            
       %save image with MM name
       cd '/media/phnguyen/Data2/TempDAPI/'
       predict_name = 'EXPTrial2_w2Camera DAPI_s%d_t%d.TIF';
       predict_name = sprintf(predict_name,positionsA(p),timepointsA(t));
       
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
for p =2:numel(positionsA)
    for t = 1:numel(timepointsA)
       i = i + 1; %file name count  
       filename = '/media/phnguyen/Data2/pytorch_fnet-master/pytorch_fnet/results/3d/AllCellTypesDAPItrain/testDiffTrack2/%d';
       filename = sprintf(filename,dirname(i));
       display(dirname(i))
       cd(filename)
       signal = imread('signal.tiff');
       predict = imread('prediction_AllCellTypesDAPItrain.tiff');
            
       %resize images back to original dimension
       signal = imresize(signal, [1080 1080]);
       predict = imresize(predict, [1080 1080]);
            
       %save image with MM name
       cd '/media/phnguyen/Data2/TempDAPI/'
       predict_name = 'EXPTrial2_w2Camera DAPI_s%d_t%d.TIF';
       predict_name = sprintf(predict_name,positionsA(p),timepointsA(t));
       
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
