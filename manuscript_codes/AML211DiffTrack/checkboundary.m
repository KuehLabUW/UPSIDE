%this function displays boundaries specified in the tracking parameters on
%a given pictures
function checkboundary(trial,pos,t,imdir,D_now,Dlower_next,Dupper_next)
im_now = imread(sprintf(imdir,trial,pos,t));
im_next = imread(sprintf(imdir,trial,pos,t+1));

im_now = circle(im_now,540,540,D_now);
figure(1)
imshow(im_now)
figure(2)
im_next = circle(im_next,540,540,Dlower_next);
im_next = circle(im_next,540,540,Dupper_next);
imshow(im_next)

figure(3)
imshow(imfuse(im_now,im_next))


end