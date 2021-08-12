%% 
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
csvfilename = 'CombinedMaskDirFluoClusterAreaTpix.csv';
cd(code_dir)


%datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
datamatrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%% plot data based on timepoints
timegrid = [0,6;5,11;10,16;15,21;20,26;25,31;30,36;35,41;40,46;45,51;50,56;55,61;60,66;65,71;70,76;75,81;80,86;85,91];
[row,col] = size(timegrid);

figure(1)
vidfile = VideoWriter('/home/phnguyen/Desktop/testmoviediff.avi');
vidfile.FrameRate = 4;
open(vidfile);


numG0 = [];
numG1 = [];
numG2 = [];
numG3 = [];
numG4 = [];
numG5 = [];
numG6 = [];
numG7 = [];
numG8 = [];
numG9 = [];
numG10 = [];

condition = 1;
trial = 1;
for i = 1:row
    matrix = getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),100);
    %gscatter(matrix.xumap,matrix.yumap,matrix.group,[],[],15)
    %%
    scatter(matrix.xumap,matrix.yumap,40,log10(matrix.APC_corr+1),'filled')
    colormap(jet)
    caxis([0.8,3.])
    colorbar()
    %%
    %legend('off')
    lgd = legend();
    lgd.FontSize = 14;
    xlabel('xumap')
    ylabel('yumap')
    xlim([-5,5.1])
    ylim([-4,4])
    title(sprintf('%d - %d hrs',timegrid(i,1)+1,timegrid(i,2)-1))
    x0=10;
    y0=10;
    width=550*2+100;
    height=400*2+100;
    set(gcf,'position',[x0,y0,width,height])
    set(gca,'Color',[0,0,0])
    set(lgd,'Location','southwest')
    drawnow
    F(i) = getframe(gcf); 
    writeVideo(vidfile,F(i));
    %% calculate cell num
    numG0 = [numG0 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),0),1)];
    numG1 = [numG1 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),1),1)];
    numG2 = [numG2 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),2),1)];
    numG3 = [numG3 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),3),1)];
    numG4 = [numG4 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),4),1)];
    numG5 = [numG5 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),5),1)];
    numG6 = [numG6 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),6),1)];
    numG7 = [numG7 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),7),1)];
    numG8 = [numG8 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),8),1)];
    numG9 = [numG9 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),9),1)];
    numG10 = [numG10 size(getSubmatrix(datamatrix,trial,condition,timegrid(i,1),timegrid(i,2),10),1)];
end
close(vidfile)

%% plot cell num vs time
figure(10)
hold on
timesteps = [5:5:90];
lineW = 5;
sumnum = numG0+numG1+numG2+numG3+numG4+numG5+numG6+numG7+numG8+numG9+numG10;
Area = [numG2'./sumnum',numG4'./sumnum',numG9'./sumnum',(numG0+numG7)'./sumnum',(numG1+numG8)'./sumnum',(numG3+numG5)'./sumnum',(numG6)'./sumnum',(numG10)'./sumnum'];
%plot(timesteps,numG2./sumnum,'color',[70 150 207]./255,'LineWidth',lineW) %A1
%plot(timesteps,numG4./sumnum,'color',[129 131 186]./255,'LineWidth',lineW) %A2
%plot(timesteps,numG9./sumnum,'color',[220 81 149]./255,'LineWidth',lineW) %A3
%plot(timesteps,(numG0+numG7)./sumnum,'color',[42 214 197]./255,'LineWidth',lineW) %S1
%plot(timesteps,(numG1+numG8)./sumnum,'color',[150 137 164]./255,'LineWidth',lineW) %S2
%plot(timesteps,(numG3+numG5)./sumnum,'color',[167 217 104]./255,'LineWidth',lineW) %S3
%plot(timesteps,(numG6)./sumnum,'color',[222 83 63]./255,'LineWidth',lineW) %S4
%plot(timesteps,(numG10)./sumnum,'color',[96 163 83]./255,'LineWidth',lineW) %DB
h = area(timesteps',Area);
xlabel('time points (hrs)')
ylabel('population fraction')
ylim([0,1])
xlim([5,90])
h(1).FaceColor = [70 150 207]./255;
h(2).FaceColor = [129 131 186]./255;
h(3).FaceColor = [220 81 149]./255;
h(4).FaceColor = [42 214 197]./255;
h(5).FaceColor = [150 137 164]./255;
h(7).FaceColor = [167 217 104]./255;
h(8).FaceColor = [96 163 83]./255;
legend('A1','A2','A3','S1','S2','S3','S4','DB')
hold off







