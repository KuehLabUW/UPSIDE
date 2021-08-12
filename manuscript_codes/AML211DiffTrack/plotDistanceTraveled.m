clear
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211DiffTrack/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/';

datadirfile = 'CombinedUMAPDirFluoClusterTCdist.csv';
datacolumn = 217;
Text = ['%s'];
for i = 1:datacolumn
    Text = [Text ' %f'];
end


datamatrix_all = readtable(strcat(root_dir,datadirfile),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', Text);


%% select condition values
trial = 1;
figurenum = 5;


%% plot distance traveled

rows = (datamatrix_all.pos > 0 & datamatrix_all.pos < 6 &datamatrix_all.pcell ~= 0);
matrix = datamatrix_all(rows,:);


figure(figurenum+1)
scatter(matrix.xumap,matrix.yumap,8,matrix.distance,'filled')
title('Distance traveled')
%axis('off')

%% plot violin plot 
for c = 1:2
    count = 0;
    cellnum = [];
    for g = 1:6
        count =count +1;
        
        if c == 1
            rows = (datamatrix_all.pos > 0 & datamatrix_all.pos < 6 & datamatrix_all.pcell ~= 0 & datamatrix_all.cluster == g);
            matrix = datamatrix_all(rows,:);
        elseif c == 2
            rows = (datamatrix_all.pos > 5 & datamatrix_all.pos < 11 &datamatrix_all.pcell ~= 0 &  datamatrix_all.cluster == g);
            matrix = datamatrix_all(rows,:);
        end
            
            
       
        %get the feature values as cells
        Area{:,count} = matrix.area;
        Ecc{:,count} = matrix.eccentricity;
        Pix{:,count} = matrix.sharpvalue;
        Dist{:,count} = matrix.distance;
        
    end
    %plot violin plots
    figure(c+1);violin(Area);ylabel('Area');%saveas(gcf,'/home/phnguyen/Desktop/area.pdf');close all;
    figure(c+2);violin(Ecc);ylabel('Eccentricity');%saveas(gcf,'/home/phnguyen/Desktop/ecc.pdf');close all;
    figure(c+3);violin(Pix);ylabel('max sharpness');%saveas(gcf,'/home/phnguyen/Desktop/sharp.pdf');close all;
    figure(c+4);violin(Dist);ylabel('distance traveled');%ylim([-6,5]);saveas(gcf,'/home/phnguyen/Desktop/CD34.pdf');close all;
    
    keyboard
end