clear
%This code calculates the classification performance of the convolutional
%classifier to distinguish live dead cells by calculating the ROC for the
%viable population prediction
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
csvfilename = 'LargeMask_LIVEDEAD_predicted_for_validation.csv';

matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%f %s %f %f %f %f %f %f %f %f');

labels = matrix.true_live;
scores = matrix.live;
posclass = ones(numel(labels),1);

[X,Y,T,AUC] = perfcurve(labels,scores,1);
plot(X,Y)
xlabel('False positive rate') 
ylabel('True positive rate')
title('ROC for Classification by Logistic Regression')
disp('AUC')
disp(AUC)