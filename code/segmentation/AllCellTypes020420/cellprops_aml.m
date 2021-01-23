function data = cellprops_aml(images, obj)
% FUNCTION DATA = CELLPROPS(IMAGES, OBJ) takes an input an ictrack image
% matrix IMAGE, an segmented objected OBJ, and returns a DATA structure
% containing relevant experiment-specific information about the properties
% of the cell object.
%
% This CELLPROPS function is relevant for measuring nuclear/cytoplasmic
% ratios of Erk-BFP (channel 2), RelA-GFP (channel 3), NFAT-Ruby
% (channel 4), and H2B-IFP (chnanel).  
% The nuclear segmentation OBJ is eroded to generate the nuclear mask, and
% dilated and nuclear-subtracted to obtain the cytoplasmic mask.
% Modified 061718, HYK
% disp(['hello']);


% load images 
syncell = double(images(2).im);   % 
syndead = double(images(3).im);   % 
APC     = double(images(4).im);   % CD34-APC
[X,Y] = size(syncell);    % maximum size of the bcl11b segmented image

% parameters and filters
bbscaling = 2.5;    % enlargement factor for bounding box
shrink = 1;         % number of pixels to shrink for nuclear segmentation
expand = 7;         % number of pixels to enlarge to get cytoplasmic boundary
cellsize = 40;       % here is the cell size for tophat background subtraction


%% bounding box for initial nuclear segmentation                                                         
x1 = min(obj.b(:,2));                                                                                        
x2 = max(obj.b(:,2));                                                                                        
y1 = min(obj.b(:,1));                                                                                        
y2 = max(obj.b(:,1));                                                                                       
xm = (x1+x2)/2;   % mean x position                                                                          
ym = (y1+y2)/2;   % mean y position                                                                        
xmin = max(round(xm-(xm-x1)*bbscaling),1);                                                                   
ymin = max(round(ym-(ym-y1)*bbscaling),1);                                                                   
xmax = min(round(xm+(x2-xm)*bbscaling),X);                                                                   
ymax = min(round(ym+(y2-ym)*bbscaling),Y);                                                                   
               


%% take region of the original image                                                               
syncell2 = syncell(ymin:ymax, xmin:xmax);                                                                            
syndead2 = syndead(ymin:ymax, xmin:xmax);
APC2     = APC(ymin:ymax, xmin:xmax);

seg = zeros([Y,X]);
seg(sub2ind([Y X], obj.b(:,1), obj.b(:,2))) = 1; 
seg2 = imfill(seg(ymin:ymax, xmin:xmax),'holes');   % filled, segmented image for nuclear segmentation

se = strel('disk',cellsize);

nbw = imerode(seg2,strel('disk',shrink));   % nuclear mask
cbw = imdilate(seg2,strel('disk',expand));    % cytoplasmic + nuclear mask
                                                        
% now, we need to save all the data - use the median to avoid outliers due                                   
% outliers due to aberrant values at the boundary.                                                           
data.syncell_int = double(median(syncell2(find(cbw))));
data.syndead_int = double(median(syndead2(find(cbw))));
data.APC_int = double(median(APC2(find(cbw))));
data.nbw = nbw;                                                                                              
data.cbw = cbw;                                                                                              
data.syncell = syncell2;
data.syndead = syndead2;
data.APC = APC2;
                                                                                     
% 
% figure(100); subplot(2,3,1); imshow(yfp3,[]);  title(['bcl11b-yfp level = ' num2str(data.Bcl11b_YFP)]);
% subplot(2,3,2); imshow(pe3,[]); title(['CD62L levels = ' num2str(data.CD62L_PE)]);
% subplot(2,3,3); imshow(apc3,[]); title(['CD44 levels  = ' num2str(data.CD44_APC)]);
% subplot(2,3,5); imshow(nbw);
% subplot(2,3,6); imshow(cbw);
% close(100);  




