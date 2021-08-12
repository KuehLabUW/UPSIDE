%This script calculates segmentation performance on fluorescent
%dataset
clear all
T = readtable('Celllist.csv');
R = readtable('segResult2.csv');

accurate = height(R(R.Correct==1,:));
errorOther = height(R(R.Correct==0,:));
errorLargeObject = height(R(R.Correct==0.5,:));
pie([accurate,errorOther+errorLargeObject])
%% show example
Status = 0.5;
subR = R(R.Correct == Status,:);
id = randi(height(subR));
c = subR.Index(id);

trial = T.Triallist(c);
pos = T.Poslist(c);
t = T.Tlist(c);
cell = T.Celllist(c);


cd(sprintf('DifferentiationTrial%d - processed',trial))
cd(sprintf('DifferentiationTrial%d - processed',trial))
cd(sprintf('pos %d',pos))
load('segment.mat')

if t < 10
    load(sprintf('imgf_000%d.mat',t));
else
    load(sprintf('imgf_00%d.mat',t));
end
X = objects(t).obj(cell).data.x;
Y = objects(t).obj(cell).data.y;

im = images(4).im;
imraw = images(1).im;
%im(im <1) = 0;
im(im > 1.5) = 2;
cd('E:/')
imSeg = cellseg120518ML(images(4).im);

figure(1)
imshow(im);
hold on
rectangle('Position',[X-25 Y-25 50 50],'EdgeColor','r','LineWidth',1);
hold off

figure(2)
imshow(imSeg);
hold on
rectangle('Position',[X-25 Y-25 50 50],'EdgeColor','r','LineWidth',1);
hold off

imtool(imraw,[623,15321]);
