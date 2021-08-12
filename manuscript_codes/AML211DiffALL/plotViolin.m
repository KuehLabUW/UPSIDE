%this script plot violin plot that project properties of different clusters
clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';
datadirfile = 'CombinedUMAPDirFluoClusterZC.csv';
datacolumn = 218;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);
% for i = 1:height(datamatrix)
%     if datamatrix.cluster(i) == 1
%         datamatrix.cluster(i) = 2;
%     elseif datamatrix.cluster(i) == 2
%         datamatrix.cluster(i) = 5;
%     elseif datamatrix.cluster(i) == 3
%         datamatrix.cluster(i) = 1;
%     elseif datamatrix.cluster(i) == 4
%         datamatrix.cluster(i) = 4;
%     elseif datamatrix.cluster(i) == 5
%         datamatrix.cluster(i) = 3;
%     elseif datamatrix.cluster(i) == 6
%         datamatrix.cluster(i) = 4;
%     end
% end
tlow = 0;
thigh = 91;
glist = [1,2,3,4,5];
%parse through 2 conditions and 11 clusters
for c = 1:2
    count = 0;
    cellnum = [];
    for g = glist
        count =count +1;
        
        matrix = getSubmatrix(datamatrix,1,c,tlow,thigh,g);
        
        %get the feature values as cells
        Area{:,count} = matrix.area;
        Ecc{:,count} = matrix.eccentricity;
        %Pix{:,g+1} = matrix.pixvalue.*10;
        Pix{:,count} = matrix.sharpvalue;
        CD34{:,count} = log10(matrix.APC_corr+1);
        CD38{:,count} = log10(matrix.PE_corr+1);
        ratio{:,count} = log10(matrix.APC_corr+1)-log10(matrix.PE_corr+1);
        cellnum = [cellnum size(matrix,1)];
    end
    %plot violin plots
    figure(c+1);violin(Area);ylabel('Area');%saveas(gcf,'/home/phnguyen/Desktop/area.pdf');close all;
    figure(c+2);violin(Ecc);ylabel('Eccentricity');%saveas(gcf,'/home/phnguyen/Desktop/ecc.pdf');close all;
    %figure(c+3);violin(Pix,'x',glist);ylabel('mean pix intensity x 10')
    figure(c+3);violin(Pix);ylabel('max sharpness');%saveas(gcf,'/home/phnguyen/Desktop/sharp.pdf');close all;
    figure(c+4);violin(CD34);ylabel('log mean CD34');%ylim([-6,5]);%saveas(gcf,'/home/phnguyen/Desktop/CD34.pdf');close all;
    figure(c+5);violin(CD38);ylabel('log mean CD38');%ylim([-6,5]);%saveas(gcf,'/home/phnguyen/Desktop/CD38.pdf');close all;
    figure(c+6);violin(ratio);ylabel('log mean CD34/CD38');ylim([-6,5]);%saveas(gcf,'/home/phnguyen/Desktop/ratio.pdf');close all;
    figure(c+7);bar(cellnum);
    %subplot(5,1,1); violin(Area);ylabel('Area')
    %subplot(5,1,2); violin(Ecc);ylabel('Ecc')
    %subplot(5,1,3); violin(Pix);ylabel('mean pix int x 10')
    %subplot(5,1,4); violin(CD34);ylabel('mean logCD34')
    %subplot(5,1,5); violin(CD38);ylabel('mean logCD38')
    %saveas(gcf,sprintf('/home/phnguyen/Desktop/Cond%d.svg',c))
    keyboard
end