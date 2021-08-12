%this code converts NN predicted image output and put them into folders
%with MM format
%ready for segmentation
clear all
%USER-DEFINED INPUTS
in_directory = '/media/phnguyen/Data2/Imaging/UPSIDEv1/pytorch_fnet-master/pytorch_fnet/results/3d/CellTypeCellTraceTrain112319v2/testCellTypes020420'     %enter the directory with the predicted images
out_folder = 'Converted'                %enter name of folder to save converted images into
out_directory = ['/media/phnguyen/Data2/Imaging/UPSIDEv1/pytorch_fnet-master/pytorch_fnet/results/3d/CellTypeCellTraceTrain112319v2/' out_folder]  
no_tps = 11   %enter the number of time points in your movie
no_pos = 240    %enter the number of positions you have
total = no_tps*no_pos       %calcualte total number of predicted images
image_name = 'prediction_CellTypeCellTraceTrain112319v2.tiff'          %enter the name of your predicted images
basename = 'EXP2_w2Camera CellTrace';   %Enter basename for the dataset, adding a channel for the predicted images

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mkdir(out_directory)

i = -1;
for p =1
    for t = 1:10
       i = i + 1; %file name count
       %specify the directory of your predicted images, keep the '/0%d' as is!   
       filename = [in_directory '/0%d'];
       filename = sprintf(filename,i);
       display(i)
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
       predict_name = sprintf(predict_name,p,t);
       
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
    for t = 11:no_tps
       i = i + 1; %file name count  
       filename = [in_directory '/%d'];
       filename = sprintf(filename,i);
       display(i)
       cd(filename)
       signal = imread('signal.tiff');
       predict = imread(image_name);
            
       %resize images back to original dimension
       signal = imresize(signal, [1080 1080]);
       predict = imresize(predict, [1080 1080]);
            
       %save image with MM name
       cd(out_directory)
       predict_name = [basename '_s%d_t%d.TIF'];
       predict_name = sprintf(predict_name,p,t);
       
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
for p =2:no_pos
    for t = 1:no_tps
       i = i + 1; %file name count  
       filename = [in_directory '/%d'];
       filename = sprintf(filename,i);
       display(i)
       cd(filename)
       signal = imread('signal.tiff');
       predict = imread(image_name);
            
       %resize images back to original dimension
       signal = imresize(signal, [1080 1080]);
       predict = imresize(predict, [1080 1080]);
            
       %save image with MM name
       cd(out_directory)
       predict_name = [basename '_s%d_t%d.TIF'];
       predict_name = sprintf(predict_name,p,t);
       
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
