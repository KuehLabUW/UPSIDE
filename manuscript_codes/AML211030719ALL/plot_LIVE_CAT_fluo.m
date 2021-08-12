%This script plots all the live cell number from UM and nonUM data
clear

%% extract drug and UM matrices
code_dir = '/media/phnguyen/Data2/Imaging/CellMorph/code/AML211030719ALL/';
root_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/';
umapfilename = 'CombinedSubstractedDir_CAT_LIVEFLUO.csv';

cd(code_dir)

matrix = readtable(strcat(root_dir,umapfilename),'Delimiter', ',', 'HeaderLines', 0, 'ReadVariableNames', true, 'Format', '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
matrix_nondrug = matrix(matrix.treated == 0, :);
matrix_drug = matrix(matrix.treated == 1, :);

matrix_nondrug_nonUM = matrix_nondrug(matrix_nondrug.pos <= 16,:);
matrix_nondrug_UM = matrix_nondrug(matrix_nondrug.pos > 16,:);

matrix_drug_nonUM = matrix_drug(matrix_drug.pos <= 16,:);
matrix_drug_UM = matrix_drug(matrix_drug.pos > 16,:);

%% plot fraction of each category as a function of time
time_nondrug = unique(matrix_nondrug.t);
time_drug    = unique(matrix_drug.t);

%nondrug_nonUM
cat1F = [];
cat2F = [];
cat3F = [];
cat4F = [];
for t = 1:numel(time_nondrug)
    submatrix = matrix_nondrug_nonUM(matrix_nondrug_nonUM.t==time_nondrug(t),:);
    subcellTotal = height(submatrix);
    cat1F = [cat1F sum(submatrix.cat1)/subcellTotal];
    cat2F = [cat2F sum(submatrix.cat2)/subcellTotal];
    cat3F = [cat3F sum(submatrix.cat3)/subcellTotal];
    cat4F = [cat4F sum(submatrix.cat4)/subcellTotal];
    %keyboard
end
figure(1)
s = 5;
cat1F = smooth(cat1F,s);
cat2F = smooth(cat2F,s);
cat3F = smooth(cat3F,s);
cat4F = smooth(cat4F,s);
plot(1:numel(time_nondrug),cat1F,'r')
hold on
plot(1:numel(time_nondrug),cat2F,'b')
plot(1:numel(time_nondrug),cat3F,'g')
plot(1:numel(time_nondrug),cat4F,'m')
xlabel('time (hours)')
ylabel('Populatiop fraction')
ylim([0,0.6])
xlim([0,90])
%drug_nonUM
cat1F = [];
cat2F = [];
cat3F = [];
cat4F = [];
for t = 1:numel(time_drug)
    submatrix = matrix_drug_nonUM(matrix_drug_nonUM.t==time_drug(t),:);
    subcellTotal = height(submatrix);
    cat1F = [cat1F sum(submatrix.cat1)/subcellTotal];
    cat2F = [cat2F sum(submatrix.cat2)/subcellTotal];
    cat3F = [cat3F sum(submatrix.cat3)/subcellTotal];
    cat4F = [cat4F sum(submatrix.cat4)/subcellTotal];
    %keyboard
end
figure(2)
s = 5;
cat1F = smooth(cat1F,s);
cat2F = smooth(cat2F,s);
cat3F = smooth(cat3F,s);
cat4F = smooth(cat4F,s);
plot(1:numel(time_drug),cat1F,'r')
hold on
plot(1:numel(time_drug),cat2F,'b')
plot(1:numel(time_drug),cat3F,'g')
plot(1:numel(time_drug),cat4F,'m')
xlabel('time (hours)')
ylabel('Population fraction')
ylim([0,0.6])
xlim([0,50])
%nondrug_UM
cat1F = [];
cat2F = [];
cat3F = [];
cat4F = [];
for t = 1:numel(time_nondrug)
    submatrix = matrix_nondrug_UM(matrix_nondrug_UM.t==time_nondrug(t),:);
    subcellTotal = height(submatrix);
    cat1F = [cat1F sum(submatrix.cat1)/subcellTotal];
    cat2F = [cat2F sum(submatrix.cat2)/subcellTotal];
    cat3F = [cat3F sum(submatrix.cat3)/subcellTotal];
    cat4F = [cat4F sum(submatrix.cat4)/subcellTotal];
    %keyboard
end
figure(3)
s = 5;
cat1F = smooth(cat1F,s);
cat2F = smooth(cat2F,s);
cat3F = smooth(cat3F,s);
cat4F = smooth(cat4F,s);
plot(1:numel(time_nondrug),cat1F,'r')
hold on
plot(1:numel(time_nondrug),cat2F,'b')
plot(1:numel(time_nondrug),cat3F,'g')
plot(1:numel(time_nondrug),cat4F,'m')
xlabel('time (hours)')
ylabel('Populatiop fraction')
ylim([0,0.6])
xlim([0,90])
%drug_UM
cat1F = [];
cat2F = [];
cat3F = [];
cat4F = [];
for t = 1:numel(time_drug)
    submatrix = matrix_drug_UM(matrix_drug_UM.t==time_drug(t),:);
    subcellTotal = height(submatrix);
    cat1F = [cat1F sum(submatrix.cat1)/subcellTotal];
    cat2F = [cat2F sum(submatrix.cat2)/subcellTotal];
    cat3F = [cat3F sum(submatrix.cat3)/subcellTotal];
    cat4F = [cat4F sum(submatrix.cat4)/subcellTotal];
    %keyboard
end
figure(4)
s = 5;
cat1F = smooth(cat1F,s);
cat2F = smooth(cat2F,s);
cat3F = smooth(cat3F,s);
cat4F = smooth(cat4F,s);
plot(1:numel(time_drug),cat1F,'r')
hold on
plot(1:numel(time_drug),cat2F,'b')
plot(1:numel(time_drug),cat3F,'g')
plot(1:numel(time_drug),cat4F,'m')
xlabel('time (hours)')
ylabel('Populatiop fraction')
ylim([0,0.6])
xlim([0,50])

%% plot fluorescence and category
figure(5);histogram(log10(matrix.APC_corr));xlabel('log(APC)')
figure(6);histogram(log10(matrix.PE_corr));xlabel('log(PE)')
%APC_logthreshold = 1.8;
%PE_logthreshold = 2;
APC_logthreshold = 1.5;
PE_logthreshold = 2;
%get composition of cat1
matrix_cat1 = matrix(matrix.cat1==1,:);
Cat1_APC_OFF_PE_OFF = sum((log10(matrix_cat1.APC_corr) < APC_logthreshold) & (log10(matrix_cat1.PE_corr) < PE_logthreshold));
Cat1_APC_ON_PE_OFF = sum(~(log10(matrix_cat1.APC_corr) < APC_logthreshold) & (log10(matrix_cat1.PE_corr) < PE_logthreshold));
Cat1_APC_OFF_PE_ON = sum((log10(matrix_cat1.APC_corr) < APC_logthreshold) & ~(log10(matrix_cat1.PE_corr) < PE_logthreshold));
Cat1_APC_ON_PE_ON = sum(~(log10(matrix_cat1.APC_corr) < APC_logthreshold) & ~(log10(matrix_cat1.PE_corr) < PE_logthreshold));
Cat1 = [Cat1_APC_OFF_PE_OFF,Cat1_APC_ON_PE_OFF,Cat1_APC_OFF_PE_ON,Cat1_APC_ON_PE_ON];
Cat1 = Cat1./height(matrix_cat1);
%get composition of cat2
matrix_cat2 = matrix(matrix.cat2==1,:);
Cat2_APC_OFF_PE_OFF = sum((log10(matrix_cat2.APC_corr) < APC_logthreshold) & (log10(matrix_cat2.PE_corr) < PE_logthreshold));
Cat2_APC_ON_PE_OFF = sum(~(log10(matrix_cat2.APC_corr) < APC_logthreshold) & (log10(matrix_cat2.PE_corr) < PE_logthreshold));
Cat2_APC_OFF_PE_ON = sum((log10(matrix_cat2.APC_corr) < APC_logthreshold) & ~(log10(matrix_cat2.PE_corr) < PE_logthreshold));
Cat2_APC_ON_PE_ON = sum(~(log10(matrix_cat2.APC_corr) < APC_logthreshold) & ~(log10(matrix_cat2.PE_corr) < PE_logthreshold));
Cat2 = [Cat2_APC_OFF_PE_OFF,Cat2_APC_ON_PE_OFF,Cat2_APC_OFF_PE_ON,Cat2_APC_ON_PE_ON];
Cat2 = Cat2./height(matrix_cat2);
%get composition of cat3
matrix_cat3 = matrix(matrix.cat3==1,:);
Cat3_APC_OFF_PE_OFF = sum((log10(matrix_cat3.APC_corr) < APC_logthreshold) & (log10(matrix_cat3.PE_corr) < PE_logthreshold));
Cat3_APC_ON_PE_OFF = sum(~(log10(matrix_cat3.APC_corr) < APC_logthreshold) & (log10(matrix_cat3.PE_corr) < PE_logthreshold));
Cat3_APC_OFF_PE_ON = sum((log10(matrix_cat3.APC_corr) < APC_logthreshold) & ~(log10(matrix_cat3.PE_corr) < PE_logthreshold));
Cat3_APC_ON_PE_ON = sum(~(log10(matrix_cat3.APC_corr) < APC_logthreshold) & ~(log10(matrix_cat3.PE_corr) < PE_logthreshold));
Cat3 = [Cat3_APC_OFF_PE_OFF,Cat3_APC_ON_PE_OFF,Cat3_APC_OFF_PE_ON,Cat3_APC_ON_PE_ON];
Cat3 = Cat3./height(matrix_cat3);
%get composition of cat4
matrix_cat4 = matrix(matrix.cat4==1,:);
Cat4_APC_OFF_PE_OFF = sum((log10(matrix_cat4.APC_corr) < APC_logthreshold) & (log10(matrix_cat4.PE_corr) < PE_logthreshold));
Cat4_APC_ON_PE_OFF = sum(~(log10(matrix_cat4.APC_corr) < APC_logthreshold) & (log10(matrix_cat4.PE_corr) < PE_logthreshold));
Cat4_APC_OFF_PE_ON = sum((log10(matrix_cat4.APC_corr) < APC_logthreshold) & ~(log10(matrix_cat4.PE_corr) < PE_logthreshold));
Cat4_APC_ON_PE_ON = sum(~(log10(matrix_cat4.APC_corr) < APC_logthreshold) & ~(log10(matrix_cat4.PE_corr) < PE_logthreshold));
Cat4 = [Cat4_APC_OFF_PE_OFF,Cat4_APC_ON_PE_OFF,Cat4_APC_OFF_PE_ON,Cat4_APC_ON_PE_ON];
Cat4 = Cat4./height(matrix_cat4);
%plot stacked barplot

y = [Cat1;Cat2;Cat3;Cat4];
figure(7)
bar(y,'stacked');

%% plot fraction of each fluorescent as a function of time
time_nondrug = unique(matrix_nondrug.t);
time_drug    = unique(matrix_drug.t);
APC_logthreshold = 1.5;
PE_logthreshold = 2;

%nondrug_nonUM
OFFOFF = [];
ONOFF = [];
OFFON = [];
ONON = [];
for t = 1:numel(time_nondrug)
    submatrix = matrix_nondrug_nonUM(matrix_nondrug_nonUM.t==time_nondrug(t),:);
    subcellTotal = height(submatrix);
    OFFOFF = [OFFOFF sum((log10(submatrix.APC_corr) < APC_logthreshold) & (log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    ONOFF = [ONOFF sum(~(log10(submatrix.APC_corr) < APC_logthreshold) & (log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    OFFON = [OFFON sum((log10(submatrix.APC_corr) < APC_logthreshold) & ~(log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    ONON = [ONON sum(~(log10(submatrix.APC_corr) < APC_logthreshold) & ~(log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    %keyboard
end
figure(8)
s = 5;
OFFOFF = smooth(OFFOFF,s);
ONOFF = smooth(ONOFF,s);
OFFON = smooth(OFFON,s);
ONON = smooth(ONON,s);
plot(1:numel(time_nondrug),OFFOFF,'r')
hold on
plot(1:numel(time_nondrug),ONOFF,'b')
plot(1:numel(time_nondrug),OFFON,'g')
plot(1:numel(time_nondrug),ONON,'m')
xlabel('time (hours)')
ylabel('Populatiop fraction')
%ylim([0,0.6])
xlim([0,90])

%drug_nonUM
OFFOFF = [];
ONOFF = [];
OFFON = [];
ONON = [];
for t = 1:numel(time_drug)
    submatrix = matrix_drug_nonUM(matrix_drug_nonUM.t==time_drug(t),:);
    subcellTotal = height(submatrix);
    OFFOFF = [OFFOFF sum((log10(submatrix.APC_corr) < APC_logthreshold) & (log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    ONOFF = [ONOFF sum(~(log10(submatrix.APC_corr) < APC_logthreshold) & (log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    OFFON = [OFFON sum((log10(submatrix.APC_corr) < APC_logthreshold) & ~(log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    ONON = [ONON sum(~(log10(submatrix.APC_corr) < APC_logthreshold) & ~(log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    %keyboard
end
figure(9)
s = 5;
OFFOFF = smooth(OFFOFF,s);
ONOFF = smooth(ONOFF,s);
OFFON = smooth(OFFON,s);
ONON = smooth(ONON,s);
plot(1:numel(time_drug),OFFOFF,'r')
hold on
plot(1:numel(time_drug),ONOFF,'b')
plot(1:numel(time_drug),OFFON,'g')
plot(1:numel(time_drug),ONON,'m')
xlabel('time (hours)')
ylabel('Population fraction')
%ylim([0,0.6])
xlim([0,50])

%nondrug_UM
OFFOFF = [];
ONOFF = [];
OFFON = [];
ONON = [];
for t = 1:numel(time_nondrug)
    submatrix = matrix_nondrug_UM(matrix_nondrug_nonUM.t==time_nondrug(t),:);
    subcellTotal = height(submatrix);
    OFFOFF = [OFFOFF sum((log10(submatrix.APC_corr) < APC_logthreshold) & (log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    ONOFF = [ONOFF sum(~(log10(submatrix.APC_corr) < APC_logthreshold) & (log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    OFFON = [OFFON sum((log10(submatrix.APC_corr) < APC_logthreshold) & ~(log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    ONON = [ONON sum(~(log10(submatrix.APC_corr) < APC_logthreshold) & ~(log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    %keyboard
end
figure(10)
s = 5;
OFFOFF = smooth(OFFOFF,s);
ONOFF = smooth(ONOFF,s);
OFFON = smooth(OFFON,s);
ONON = smooth(ONON,s);
plot(1:numel(time_nondrug),OFFOFF,'r')
hold on
plot(1:numel(time_nondrug),ONOFF,'b')
plot(1:numel(time_nondrug),OFFON,'g')
plot(1:numel(time_nondrug),ONON,'m')
xlabel('time (hours)')
ylabel('Populatiop fraction')
%ylim([0,0.6])
xlim([0,90])

%drug_UM
OFFOFF = [];
ONOFF = [];
OFFON = [];
ONON = [];
for t = 1:numel(time_drug)
    submatrix = matrix_drug_UM(matrix_drug_nonUM.t==time_drug(t),:);
    subcellTotal = height(submatrix);
    OFFOFF = [OFFOFF sum((log10(submatrix.APC_corr) < APC_logthreshold) & (log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    ONOFF = [ONOFF sum(~(log10(submatrix.APC_corr) < APC_logthreshold) & (log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    OFFON = [OFFON sum((log10(submatrix.APC_corr) < APC_logthreshold) & ~(log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    ONON = [ONON sum(~(log10(submatrix.APC_corr) < APC_logthreshold) & ~(log10(submatrix.PE_corr) < PE_logthreshold))/subcellTotal];
    %keyboard
end
figure(11)
s = 5;
OFFOFF = smooth(OFFOFF,s);
ONOFF = smooth(ONOFF,s);
OFFON = smooth(OFFON,s);
ONON = smooth(ONON,s);
plot(1:numel(time_drug),OFFOFF,'r')
hold on
plot(1:numel(time_drug),ONOFF,'b')
plot(1:numel(time_drug),OFFON,'g')
plot(1:numel(time_drug),ONON,'m')
xlabel('time (hours)')
ylabel('Population fraction')
%ylim([0,0.6])
xlim([0,50])



