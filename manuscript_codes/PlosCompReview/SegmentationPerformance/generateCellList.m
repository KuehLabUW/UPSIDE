%this script generate a csv with all the posible cell ID
clear all
Trials = [1,2,3];
Triallist = [];
Poslist = [];
Tlist = [];
Celllist = [];

for i = Trials
    cd(sprintf('DifferentiationTrial%d - processed',i))
    cd(sprintf('DifferentiationTrial%d - processed',i))
    Pos = 1:numel(dir(pwd))-2;
    
    for j = Pos
        disp(j)
        cd(sprintf('pos %d',j))
        T = 1:numel(dir(pwd))-4;
        load('segment.mat')
        for k = T
            if numel(objects(k).obj) > 0
                Cell = 1:numel(objects(k).obj);
                for l = Cell
                    Triallist = [Triallist i];
                    Poslist = [Poslist j];
                    Tlist = [Tlist k];
                    Celllist = [Celllist l];
                end
            
            end
        end
        cd('..')    
    end
    cd('..')
    cd('..')
end
%keyboard
TA = table(Triallist',Poslist',Tlist',Celllist');
writetable(TA,'Celllist.csv')