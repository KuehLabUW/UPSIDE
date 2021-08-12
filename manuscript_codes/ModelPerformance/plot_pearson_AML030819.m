%this plots pearsons corre from the following two files
%labelfreeperformanceCellTrace030819.m
%labelfreeperformanceDAPI030819.m

Mean_corr = [0.9041,0.8511]; %celltrace and DAPI
Std_corr = [0.0308,0.0246];
upper_est = [0.999,0.999];

c = 1:2;

bar(c,Mean_corr);
hold on
errorbar(c,Mean_corr,Std_corr);
scatter(c,upper_est,'*')

xlim([0,3])
ylim([0,1.5])




