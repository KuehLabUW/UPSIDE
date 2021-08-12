%% 
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';

datadirfile = 'CombinedUMAPDirFluoClusterTCdist.csv';
datacolumn = 216;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);

%% plot data based on timepoints
timegrid = 20*[0,6;5,11;10,16;15,21;20,26;25,31;30,36;35,41;40,46;45,51;50,56;55,61;60,66;65,71;70,76;75,81;80,86;85,91];
[row,col] = size(timegrid);

figure(1)



numG1 = [];
numG2 = [];
numG3 = [];
numG4 = [];
numG5 = [];
numG6 = [];


trial = 1;
for i = 1:row
    matrix = datamatrix(datamatrix.trial == trial & datamatrix.pos >5 & datamatrix.pos < 11 & datamatrix.t > timegrid(i,1) & datamatrix.t < timegrid(i,2),:);
    
    %% calculate cell num
    numG1 = [numG1 size(matrix(matrix.cluster == 1,:),1)];
    numG2 = [numG2 size(matrix(matrix.cluster == 2,:),1)];
    numG3 = [numG3 size(matrix(matrix.cluster == 3,:),1)];
    numG4 = [numG4 size(matrix(matrix.cluster == 4,:),1)];
    numG5 = [numG5 size(matrix(matrix.cluster == 5,:),1)];
    numG6 = [numG6 size(matrix(matrix.cluster == 6,:),1)];
    
end


%% plot cell num vs time
figure(11)
hold on
timesteps = [5:5:90];
lineW = 5;
sumnum = numG1+numG2+numG3+numG4+numG5+numG6;
Area = [numG1'./sumnum',numG2'./sumnum',numG3'./sumnum',(numG4)'./sumnum',(numG5)'./sumnum',(numG6)'./sumnum'];

h = area(timesteps',Area);
xlabel('time points (hrs)')
ylabel('population fraction')
ylim([0,1])
xlim([5,90])
h(1).FaceColor = [42 214 197]./255;
h(2).FaceColor = [220 81 149]./255;
h(3).FaceColor = [96 163 83]./255;
h(4).FaceColor = [200 214 197]./255;
h(5).FaceColor = [129 131 186]./255;
h(6).FaceColor = [129 0 0]./255;
legend('1','2','3','4','5','6')
hold off









