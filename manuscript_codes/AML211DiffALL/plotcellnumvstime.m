%% 
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

datadirfile = 'Dataset1CompleteAreaEdgeFluoCluster.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


%% plot data based on timepoints
timegrid = [0,6;5,11;10,16;15,21;20,26;25,31;30,36;35,41;40,46;45,51;50,56;55,61;60,66;65,71;70,76;75,81;80,86;85,91];
[row,col] = size(timegrid);





numG1 = [];
numG2 = [];
numG3 = [];
numG4 = [];
numG5 = [];
numG6 = [];
numG7 = [];
numG8 = [];

condition = 2;
trial = 2;

figure(condition)
for i = 1:row
    matrix = datamatrix(datamatrix.trial == trial & datamatrix.condition == condition & datamatrix.t > timegrid(i,1) & datamatrix.t < timegrid(i,2),:);
    
    %% calculate cell num
    numG1 = [numG1 size(matrix(matrix.cluster == 1,:),1)];
    numG2 = [numG2 size(matrix(matrix.cluster == 2,:),1)];
    numG3 = [numG3 size(matrix(matrix.cluster == 3,:),1)];
    numG4 = [numG4 size(matrix(matrix.cluster == 4,:),1)];
    numG5 = [numG5 size(matrix(matrix.cluster == 5,:),1)];
    numG6 = [numG6 size(matrix(matrix.cluster == 6,:),1)];
    numG7 = [numG7 size(matrix(matrix.cluster == 7,:),1)];
    numG8 = [numG8 size(matrix(matrix.cluster == 8,:),1)];
    
end


%% plot cell num vs time
hold on
timesteps = [5:5:90];
lineW = 5;
sumnum = numG1+numG2+numG3+numG4+numG5+numG6+numG7+numG8;
Area = [numG1'./sumnum',numG3'./sumnum',numG5'./sumnum',(numG6)'./sumnum',(numG7)'./sumnum',(numG8)'./sumnum',(numG4)'./sumnum',(numG2)'./sumnum'];

h = area(timesteps',Area);
xlabel('time points (hrs)')
ylabel('population fraction')
ylim([0,1])
xlim([5,90])
h(1).FaceColor = [42 214 197]./255;
h(2).FaceColor = [20 81 149]./255;
h(3).FaceColor = [96 163 83]./255;
h(4).FaceColor = [200 214 197]./255;
h(5).FaceColor = [129 131 186]./255;
h(6).FaceColor = [129 0 0]./255;
h(7).FaceColor = [255 40 255]./255;
h(8).FaceColor = [255 165 0]./255;






legend('G1','G3','G5','G6','G7','G8','G4','G2')
hold off

%% plot percent fraction increase
trialset = [1,2,3];
condition = 1;
cluster_size = 8;
timespan = 20;
enrichment = zeros(numel(trialset),cluster_size);

late = zeros(numel(trialset),cluster_size);

for condition =1:2
    for i =1:numel(trialset)
        for j = 1:cluster_size
            early_c = height(datamatrix(datamatrix.trial == trialset(i) & datamatrix.condition == condition & datamatrix.t > 0 & datamatrix.t < timespan & datamatrix.cluster == j,:));
            early_t = height(datamatrix(datamatrix.trial == trialset(i) & datamatrix.condition == condition & datamatrix.t > 0 & datamatrix.t < timespan,:));
            
            late_c = height(datamatrix(datamatrix.trial == trialset(i) & datamatrix.condition == condition & datamatrix.t > 90 - timespan & datamatrix.t < 90 & datamatrix.cluster == j,:));
            late_t = height(datamatrix(datamatrix.trial == trialset(i) & datamatrix.condition == condition & datamatrix.t > 90 - timespan & datamatrix.t < 90,:));
            
            enrichment(i,j) = late_c/late_t - early_c/early_t;
            late(i,j) = late_c/late_t;
        end
    end
    
    enrichment = enrichment(:,[1,3,5,6,7,8,4,2]);
    late = late(:,[1,3,5,6,7,8,4,2]);
    eval(sprintf('enrich%d = enrichment;',condition));
    eval(sprintf('lat%d = late;',condition));
    e_m = mean(enrichment,1);
    e_s = std(enrichment,[],1);
    
    
    bar(1:cluster_size,e_m)
    hold on
    ylim([-0.22,0.28])
    %er = errorbar(1:cluster_size,e_m,e_s./sqrt(2),e_s./sqrt(2));
    er = errorbar(1:cluster_size,e_m,e_s,e_s);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
end

%calculate paired t-test for each cluster pair
P = [];
for c =1:8
    [h,p] = ttest(enrich1(:,c),enrich2(:,c));
    P=[P p];
end

P = [];
for c =1:8
    [h,p] = ttest(enrich1(:,c),enrich2(:,c));
    P=[P p];
end

Plate = [];
for c =1:8
    [h,p] = ttest(lat1(:,c),lat2(:,c));
    Plate=[Plate p];
end

%% Calculate the Chi Square test for distribution of clusters between +/-AhRi
%% at specific time point
trialset = [1,2,3];
condition = 1;
timepoint = 'end';
Pvalues = [];
for i =1:3
   submatrix = datamatrix(datamatrix.trial==i,:);
   submatrix = submatrix(submatrix.t == max(submatrix.t),:);
   Pvalues = [];
   
   
   for g = [1,3,5,6,7,8,4,2]
       clustermod = [];
       for j =1:height(submatrix)
           if submatrix.cluster(j)==g
               clustermod =[clustermod;1];
           else
               clustermod =[clustermod;0];
           end
       end
       submatrixG = submatrix;
       submatrixG.clustermod = clustermod;
       cat = submatrixG.condition;
       group = submatrixG.clustermod;
       [tbl,chi2,p,labels] = crosstab(group,cat);
       Pvalues = [Pvalues p];
       
   end
   
   submatrixC1 = submatrix(submatrix.condition==1,:);
   submatrixC2 = submatrix(submatrix.condition==2,:);
   
   Cond1 =[];
   Cond2 =[];
   Cond1N =[];
   Cond2N =[];
   for g =[1,3,5,6,7,8,4,2]
       disp('############################')
       disp(g)
       disp(height(submatrixC1(submatrixC1.cluster==g,:)))
       disp(height(submatrixC2(submatrixC2.cluster==g,:)))
       
       Cond1N = [Cond1N height(submatrixC1(submatrixC1.cluster==g,:))];
       Cond2N = [Cond2N height(submatrixC1(submatrixC2.cluster==g,:))];
       
       Cond1 = [Cond1 height(submatrixC1(submatrixC1.cluster==g,:))./height(submatrixC1)];
       Cond2 = [Cond2 height(submatrixC2(submatrixC2.cluster==g,:))./height(submatrixC2)];
   end
   disp('###########################')
   disp('###########################')
   disp(sum(Cond1N))
   disp(sum(Cond2N))
   disp('###########################')
   disp('###########################')
   %figure(i)
   %bar([Cond1;Cond2],'stack');
   paired = [];
   pairedN = [];
   for k = 1:8
       paired = [paired;[Cond1(k) Cond2(k)]];
       pairedN = [pairedN;[Cond1N(k) Cond2N(k)]];
   end
   figure()
   bar(paired)
   figure()
   bar(pairedN)
   keyboard
end





