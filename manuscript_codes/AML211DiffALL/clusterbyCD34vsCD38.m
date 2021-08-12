% this script clusters the state clusters by their CD34 and CD38 leve

CD34_trial1 = [1.58483019,1.19960792,1.3597726,1.07210608,1.49214854,1.42235307,1.44321692,0.9906466];
CD38_trial1 = [1.5594828,2.53691802,1.33936076,2.16390559,2.0845982,2.16860629,1.9006905,2.15431862];
CD34_trial2 = [1.43781519,1.32428298,1.24622273,1.18384847,1.54824133,1.47370941,1.4714196,1.13461194];
CD38_trial2 = [0.87220366,1.4919897,0.79626581,1.11435258,1.18311502,1.33007503,1.09278789,1.14212464];


CD34_mean = (CD34_trial1 + CD34_trial2)./2;
CD38_mean = (CD38_trial1 + CD38_trial2)./2;

CD34_std = std([CD34_trial1',CD34_trial2'],0,2)./sqrt(2);
CD38_std = std([CD38_trial1',CD38_trial2'],0,2)./sqrt(2);


z = linkage([CD34_trial1',CD38_trial1']);
T = cluster(z,'maxclust',3);
dendrogram(z)

%center = [[1.4,1.5];[2,1.5];[2.4,1]];
%[idx,C] = kmeans([CD34_trial1',CD38_trial1'],3,'Start',center);

scatter(CD38_mean,CD34_mean)
hold on
errorbar(CD38_mean,CD34_mean,CD34_std,CD34_std,CD38_std,CD38_std,'o')
[idx,C] = kmeans([CD34_mean',CD38_mean'],3,'Start',[[1.2,1.4];[1.6,1.45];[1.8,1.1]]);