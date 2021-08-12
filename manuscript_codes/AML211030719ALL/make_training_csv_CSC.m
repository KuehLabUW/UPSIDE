clear

%this script generates data classified into four quadrants of CD34 and CD38
%expression 
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
csvfilename = 'CombinedSubstractedDir_CAT_LIVEFLUO.csv';

testsetname = 'AML211_CSC_testset.csv';
trainsetname = 'AML211_CSC_trainset.csv';
cd(code_dir)
matrix = readtable(strcat(root_dir,csvfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');

%define fluorescent threshold
APC_logthreshold = 1.5;
PE_logthreshold = 2;
%extract each quadrant
Matrix_CD34OFF_CD38OFF = matrix((log10(matrix.APC_corr) < APC_logthreshold) & (log10(matrix.PE_corr) < PE_logthreshold),:);
Matrix_CD34ON_CD38OFF = matrix(~(log10(matrix.APC_corr) < APC_logthreshold) & (log10(matrix.PE_corr) < PE_logthreshold),:);
Matrix_CD34OFF_CD38ON = matrix((log10(matrix.APC_corr) < APC_logthreshold) & ~(log10(matrix.PE_corr) < PE_logthreshold),:);
Matrix_CD34ON_CD38ON = matrix(~(log10(matrix.APC_corr) < APC_logthreshold) & ~(log10(matrix.PE_corr) < PE_logthreshold),:);

%assign label to each quadrant
Matrix_CD34OFF_CD38OFF.cat1(:) = 1;
Matrix_CD34OFF_CD38OFF.cat2(:) = 0;
Matrix_CD34OFF_CD38OFF.cat3(:) = 0;
Matrix_CD34OFF_CD38OFF.cat4(:) = 0;

Matrix_CD34ON_CD38OFF.cat1(:) = 0;
Matrix_CD34ON_CD38OFF.cat2(:) = 1;
Matrix_CD34ON_CD38OFF.cat3(:) = 0;
Matrix_CD34ON_CD38OFF.cat4(:) = 0;

Matrix_CD34OFF_CD38ON.cat1(:) = 0;
Matrix_CD34OFF_CD38ON.cat2(:) = 0;
Matrix_CD34OFF_CD38ON.cat3(:) = 1;
Matrix_CD34OFF_CD38ON.cat4(:) = 0;

Matrix_CD34ON_CD38ON.cat1(:) = 0;
Matrix_CD34ON_CD38ON.cat2(:) = 0;
Matrix_CD34ON_CD38ON.cat3(:) = 0;
Matrix_CD34ON_CD38ON.cat4(:) = 1;

%remove cat5
Matrix_CD34OFF_CD38OFF.cat5 = [];
Matrix_CD34ON_CD38OFF.cat5 = [];
Matrix_CD34OFF_CD38ON.cat5 = [];
Matrix_CD34ON_CD38ON.cat5 = [];

%randomly split data equally into test and train sets
ind_OFFOFF = randperm(height(Matrix_CD34OFF_CD38OFF),round(height(Matrix_CD34OFF_CD38OFF)/2));
ind_ONOFF = randperm(height(Matrix_CD34ON_CD38OFF),round(height(Matrix_CD34ON_CD38OFF)/2));
ind_OFFON = randperm(height(Matrix_CD34OFF_CD38ON),round(height(Matrix_CD34OFF_CD38ON)/2));
ind_ONON = randperm(height(Matrix_CD34ON_CD38ON),round(height(Matrix_CD34ON_CD38ON)/2));

testOFFOFF = Matrix_CD34OFF_CD38OFF(ind_OFFOFF,:);
trainOFFOFF = Matrix_CD34OFF_CD38OFF; trainOFFOFF(ind_OFFOFF,:) = [];

testONOFF = Matrix_CD34ON_CD38OFF(ind_ONOFF,:);
trainONOFF = Matrix_CD34ON_CD38OFF; trainONOFF(ind_ONOFF,:) = [];

testOFFON = Matrix_CD34OFF_CD38ON(ind_OFFON,:);
trainOFFON = Matrix_CD34OFF_CD38ON; trainOFFON(ind_OFFON,:) = [];

testONON = Matrix_CD34ON_CD38ON(ind_ONON,:);
trainONON = Matrix_CD34ON_CD38ON; trainONON(ind_ONON,:) = [];

%put data into a testset and a trainset
testset = [testOFFOFF;testONOFF;testOFFON;testONON];
trainset = [trainOFFOFF;trainONOFF;trainOFFON;trainONON];

writetable(testset,strcat(root_dir,testsetname))
writetable(trainset,strcat(root_dir,trainsetname))
