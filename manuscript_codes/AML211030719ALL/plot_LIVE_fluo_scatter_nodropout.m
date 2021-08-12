%This script plots all the live cell number from UM and nonUM data
clear

%% extract drug and UM matrices
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
umapfilename = 'CombinedSubstractedDirUMAP_mixgaus_largeLIVEFLUO60z_nodropout2_nostyle.csv';

cd(code_dir)

matrix = readtable(strcat(root_dir,umapfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
matrix_nondrug = matrix(matrix.treated == 0, :);
matrix_drug = matrix(matrix.treated == 1, :);

matrix_nondrug_nonUM = matrix_nondrug(matrix_nondrug.pos <= 16,:);
matrix_nondrug_UM = matrix_nondrug(matrix_nondrug.pos > 16,:);

matrix_drug_nonUM = matrix_drug(matrix_drug.pos <= 16,:);
matrix_drug_UM = matrix_drug(matrix_drug.pos > 16,:);

%% set up fluorescence threshold
figure(1);histogram(log10(matrix.APC_corr));xlabel('log(APC)')
figure(2);histogram(log10(matrix.PE_corr));xlabel('log(PE)')
%APC_logthreshold = 1.8;
%PE_logthreshold = 2;
APC_logthreshold = 1.5;
PE_logthreshold = 2;

%% set up CD34CD38 categories
%define an extra column called category
cat = zeros(height(matrix),1);
for i = 1:height(matrix)
    if (log10(matrix.APC_corr(i)) < APC_logthreshold) && (log10(matrix.PE_corr(i)) < PE_logthreshold)
        cat(i) = 1;
    elseif ~(log10(matrix.APC_corr(i)) < APC_logthreshold) && (log10(matrix.PE_corr(i)) < PE_logthreshold)
        cat(i) = 2;
    elseif (log10(matrix.APC_corr(i)) < APC_logthreshold) && ~(log10(matrix.PE_corr(i)) < PE_logthreshold)
        cat(i) = 3;
    elseif ~(log10(matrix.APC_corr(i)) < APC_logthreshold) && ~(log10(matrix.PE_corr(i)) < PE_logthreshold)
        cat(i) = 4;    
    end
end
cat = table(cat);
matrix = [matrix cat];
%% plot scatter plot for fluorescence
matrixOFFOFF = matrix(matrix.cat==1,:);
matrixONOFF = matrix(matrix.cat==2,:);
matrixOFFON = matrix(matrix.cat==3,:);
matrixONON = matrix(matrix.cat==4,:);
subplot(2,2,1)
scatter(matrixOFFOFF.x_umap,matrixOFFOFF.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
hold on
scatter(matrixONOFF.x_umap,matrixONOFF.y_umap,0.75,'filled','r');
scatter(matrixOFFON.x_umap,matrixOFFON.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
scatter(matrixONON.x_umap,matrixONON.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
title('CD34ON_CD38OFF')
hold off
subplot(2,2,2)
scatter(matrixOFFOFF.x_umap,matrixOFFOFF.y_umap,0.75,'filled','r');
hold on
scatter(matrixONOFF.x_umap,matrixONOFF.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
scatter(matrixOFFON.x_umap,matrixOFFON.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
scatter(matrixONON.x_umap,matrixONON.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
title('CD34OFF_CD38OFF')
hold off
subplot(2,2,3)
scatter(matrixOFFOFF.x_umap,matrixOFFOFF.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
hold on
scatter(matrixONOFF.x_umap,matrixONOFF.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
scatter(matrixOFFON.x_umap,matrixOFFON.y_umap,0.75,'filled','r');
scatter(matrixONON.x_umap,matrixONON.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
title('CD34OFF_CD38ON')
hold off
subplot(2,2,4)
scatter(matrixOFFOFF.x_umap,matrixOFFOFF.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
hold on
scatter(matrixONOFF.x_umap,matrixONOFF.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
scatter(matrixOFFON.x_umap,matrixOFFON.y_umap,0.75,'filled','MarkerFaceColor',180./[200 200 200]);
title('CD34ON_CD38ON')
scatter(matrixONON.x_umap,matrixONON.y_umap,0.75,'filled','r');
hold off
%% plot scatter plot for sensitive vs resistant population
%figure(4)
%sensitive = matrix_nondrug_nonUM(matrix_nondrug_nonUM.t >= 1721,:);
%resistant = matrix_nondrug_UM(matrix_nondrug_UM.t >= 1721,:);

%scatter(sensitive.x_umap,sensitive.y_umap,5,'filled','b')
%hold on
%scatter(resistant.x_umap,resistant.y_umap,5,'filled','r')
%% plot time-dependencies