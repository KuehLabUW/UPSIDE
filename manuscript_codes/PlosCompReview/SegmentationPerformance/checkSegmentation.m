%this script randomly select a cell and show its segmentation
%to determine the accuracy of such presentation
T = readtable('Celllist.csv');
%Index =[];
%Correct = [];
count = 0;
for repeat = 1:numel(T)
    
    FlagB = 0;
    
    while FlagB == 0
        c = randi(height(T));
        if ~ismember(c,Index)
            Index = [Index;c];
            FlagB = 1;
        end
    end
    % choose a set of condition to pick a cell from
    trial = T.Triallist(c);
    cd(sprintf('DifferentiationTrial%d - processed',trial))
    cd(sprintf('DifferentiationTrial%d - processed',trial))
    pos = T.Poslist(c);
    cd(sprintf('pos %d',pos))
    t = T.Tlist(c);
    if t < 10
        load(sprintf('imgf_000%d.mat',t));
    else
        load(sprintf('imgf_00%d.mat',t));
    end
    load('segment.mat')
    if numel(objects(t).obj) > 0
        cell = T.Celllist(c);
    end
    cd('E:/')
   
    
    
    % show the cell
    cd('E:/')
    cd(sprintf('DifferentiationTrial%d - processed',trial))
    cd(sprintf('DifferentiationTrial%d - processed',trial))
    cd(sprintf('pos %d',pos))
    if t < 10
        load(sprintf('imgf_000%d.mat',t));
    else
        load(sprintf('imgf_00%d.mat',t));
    end
    load('segment.mat')
    X = objects(t).obj(cell).data.x;
    Y = objects(t).obj(cell).data.y;
    cd('E:/')
    im = images(4).im;
    im(im <1) = 0;
    im(im > 1.5) = 2;
    imSeg = cellseg120518ML(images(4).im);
    imF = imfuse(im,imSeg);
    imshow(imF);
    hold on
    rectangle('Position',[X-25 Y-25 50 50],'EdgeColor','r','LineWidth',2);
    hold off
    valid = 0;
    while valid == 0
        correct = input('Correct Segmentation?: ');
        if isempty(correct)
            disp('invalid answer')
        elseif (~ismember(correct,[0,0.5,1]))
            % 0: false segmentation - other
            % 0.5: false segmentation - part of larger object
            % 1: correct segmentation
            disp('invalid answer')
        else
            valid = 1;
        end
    end
    Correct = [Correct;correct];
    
    if rem(numel(Index),100) == 0.
        TA = table(Index,Correct);
        writetable(TA,'segResult2.csv')
        disp('Saved!')
        disp(numel(Index))
        close all
    end
count = count + 1;    
end 