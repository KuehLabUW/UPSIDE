#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 27 11:24:12 2020

@author: phnguyen
"""


import pandas as pd
import os
from scipy.spatial import distance_matrix
from scipy.stats import spearmanr,pearsonr
from sklearn.neighbors import kneighbors_graph
import umap
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import community
import networkx as nx
from sklearn.cluster import DBSCAN
import seaborn as sns


##%
numchosen = 40;
group_choice = 'cluster';
##%
# load data
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/'
os.chdir(csvs_dirname)

df = pd.read_csv('Dataset1CompleteAreaEdgeFluoCluster.csv')

# choose the 40 latent z texture and mask with the highest stdev

m_df = df.iloc[:,12:12+100]
t_df = df.iloc[:,112:112+100]

sorted_m_idx = np.argsort(np.std(m_df,axis = 0))
chosen_m_idx = sorted_m_idx[-numchosen:]
m_df_chosen = m_df.iloc[:,np.array(chosen_m_idx)]

sorted_t_idx = np.argsort(np.std(t_df,axis = 0))
chosen_t_idx = sorted_t_idx[-numchosen:]
t_df_chosen = t_df.iloc[:,np.array(chosen_t_idx)]


featurelist =list(m_df_chosen)+list(t_df_chosen);
namelist = featurelist + ['xumap','yumap','APC_corr','PE_corr','cluster','trial','condition','t','group','area','eccentricity','sharpvalue']
prop_list = ['APC_corr','PE_corr','area','eccentricity']
df_updated = df[namelist]


APC_corr_log = np.log10(df_updated.APC_corr + 1)
PE_corr_log = np.log10(df_updated.PE_corr + 1)
df_updated.iloc[:,list(df_updated).index('APC_corr')] = np.array(APC_corr_log)
df_updated.iloc[:,list(df_updated).index('PE_corr')] = np.array(PE_corr_log)




def get_corrmatrix(df_updated,trial):
    ### create a matrix with columns represent each z dim and the rows represent each cluster/group
    mean_matrix = np.zeros([len(np.unique(df_updated[group_choice])),len(np.unique(featurelist))])
    std_matrix = np.zeros([len(np.unique(df_updated[group_choice])),len(np.unique(featurelist))])
    
    # calculate the mean of the latent for each clusters
    [row,col] = np.shape(mean_matrix)

    for g in range(0,row):
        count = 0
        for f in featurelist:

            criteria =  (df_updated[group_choice] == g+1) & (df_updated.trial == trial)
            subdf = df_updated[criteria]
            mean_matrix[g,count] = np.mean(subdf[f])
            std_matrix[g,count] = np.std(subdf[f])
            count = count +1

    ### create a matrix with columns represent each properties and the rows represent each cluster/group
    prop_list = ['APC_corr','PE_corr','area','eccentricity']
    mean_matrix_p = np.zeros([len(np.unique(df_updated[group_choice])),len(prop_list)])
    std_matrix_p = np.zeros([len(np.unique(df_updated[group_choice])),len(prop_list)])
    # calculate the mean of the latent for each clusters
    [row,col] = np.shape(mean_matrix_p)
    
    for g in range(0,row):
        count = 0
        for p in prop_list:
            
            criteria =  (df_updated[group_choice] == g+1) & (df_updated.trial == trial)
            subdf = df_updated[criteria]
            mean_matrix_p[g,count] = np.mean(subdf[p])
            std_matrix_p[g,count] = np.std(subdf[p])
            count = count +1
            
    ### stitch the two matrices together and calculate spearman correlation of the matrix
    matrix = np.concatenate((mean_matrix,mean_matrix_p),axis = 1)
    matrix_std = np.concatenate((std_matrix,std_matrix_p),axis = 1)
    rho, pval = spearmanr(matrix)
    
    return rho,matrix,matrix_std

# calculate correff for 3 trials and cacluate means and std
std_matrix = np.zeros([3,len(np.unique(df_updated[group_choice])),len(featurelist+prop_list)])    
mean_matrix = np.zeros([3,len(np.unique(df_updated[group_choice])),len(featurelist+prop_list)])
corr_matrix = np.zeros([3,len(featurelist+prop_list),len(featurelist+prop_list)])    
for i in range(3):
    corr_matrix[i,:,:],mean_matrix[i,:,:],std_matrix[i,:,:] = get_corrmatrix(df_updated,i+1)

 
#corr_matrix_std = np.std(corr_matrix,axis = 2)

corr_matrix_prop = corr_matrix[:,:len(featurelist),-len(prop_list):]
corr_matrix_prop_mean = np.mean(corr_matrix_prop,axis=0)
corr_matrix_prop_std = np.std(corr_matrix_prop,axis=0)
#%%
###################################################### PLOT BARPLOTS ###############################################
# plot barplots
feature = 'PE_corr'
m = corr_matrix_prop_mean[:,prop_list.index(feature)]
s = corr_matrix_prop_std[:,prop_list.index(feature)]

m_sorted = np.sort(m)
sorted_idx = np.argsort(m)
s_sorted = [s[i] for i in sorted_idx]
f_sorted = [featurelist[i] for i in sorted_idx]


x_pos = np.arange(0,len(featurelist))

plt.rcdefaults()
fig, ax = plt.subplots()
ax.bar(x_pos, m_sorted, yerr=s_sorted, align='center', alpha=0.5, ecolor='black',capsize=10)

plt.ylabel(feature + 'elation')

ax.yaxis.grid(True)
plt.show()
print(f_sorted)


#%% plot property vs latent variable
prop = feature
latent = 'm46'
trial = 1

mean_matrix_slice = mean_matrix[trial,:,:]
std_matrix_slice = std_matrix[trial,:,:]

gcolor = {'tab:blue', 'tab:orange', 'tab:green', 'tab:red', 'tab:purple', 'tab:brown', 'tab:pink', 'tab:gray'}
df_mean = pd.DataFrame(mean_matrix_slice,columns = featurelist+prop_list)
df_std = pd.DataFrame(std_matrix_slice,columns = featurelist+prop_list)
df_mean['cluster'] = [1,2,3,4,5,6,7,8]
df_std['cluster'] = [1,2,3,4,5,6,7,8]


plt.errorbar(df_mean[latent],df_mean[prop],xerr=df_std[latent],yerr=df_std[prop], linestyle="None",fmt = 'o')
plt.show()
g= sns.lmplot(latent,prop,data= df_mean,hue = 'cluster',fit_reg=False,scatter_kws={"s": 200} )
#g.map(plt.errorbar,x = df_mean[latent],y = df_mean[prop],xerr=df_std[latent],yerr=df_std[prop],linestyle="None",fmt='o')
#.map(sns.lmplot,x= latent,y=prop,data= df_mean)
plt.show()

print('correlation score: ')
print(m_sorted[f_sorted.index(latent)])

################################ PLOT VIOLIN ##################################################
#%% plot violin plot of overall properties in the entire population
prop = 'PE_corr'
# find and order the cluster names according to mean
prop_mean = [];
for i in np.unique(df_updated.cluster):
    subdf = df_updated[df_updated.cluster == i]
    prop_mean.append(np.mean(subdf[prop]))

ordered_idx = np.argsort(prop_mean) + 1

#plot violin

sns.violinplot(x='cluster', y=prop, data=df_updated, order=ordered_idx)
plt.show()


prop = 'APC_corr'
# find and order the cluster names according to mean
prop_mean = [];
for i in np.unique(df_updated.cluster):
    subdf = df_updated[df_updated.cluster == i]
    prop_mean.append(np.mean(subdf[prop]))

ordered_idx = np.argsort(prop_mean) + 1

#plot violin

sns.violinplot(x='cluster', y=prop, data=df_updated, order=ordered_idx)
plt.show()

prop = 'area'
# find and order the cluster names according to mean
prop_mean = [];
for i in np.unique(df_updated.cluster):
    subdf = df_updated[df_updated.cluster == i]
    prop_mean.append(np.mean(subdf[prop]))

ordered_idx = np.argsort(prop_mean) + 1

#plot violin

sns.violinplot(x='cluster', y=prop, data=df_updated, order=ordered_idx)
plt.show()

prop = 'eccentricity'
# find and order the cluster names according to mean
prop_mean = [];
for i in np.unique(df_updated.cluster):
    subdf = df_updated[df_updated.cluster == i]
    prop_mean.append(np.mean(subdf[prop]))

ordered_idx = np.argsort(prop_mean) + 1

#plot violin

sns.violinplot(x='cluster', y=prop, data=df_updated, order=ordered_idx)
plt.show()

prop = 'sharpvalue'
# find and order the cluster names according to mean
prop_mean = [];
for i in np.unique(df_updated.cluster):
    subdf = df_updated[df_updated.cluster == i]
    prop_mean.append(np.mean(subdf[prop]))

ordered_idx = np.argsort(prop_mean) + 1

#plot violin

sns.violinplot(x='cluster', y=prop, data=df_updated, order=ordered_idx)
plt.show()

############################################ PLOT CORRELATION WITHIN CLUSTER ############################
#%%
prop = 'PE_corr'
latent = 'm19'
for i in np.unique(df_updated.cluster):
    subdf = df_updated[df_updated.cluster == i]
    sns.lmplot(x= latent,y=prop,data = subdf,fit_reg=True)
    plt.ylabel(prop+' '+'cluster{}'.format(i))
    plt.show()

############################################ PLOT CORRELATION BETWEEN PROPERTIES ############################
#%%
df_updated_clean = df_updated[(df_updated.APC_corr != 0) & (df_updated.PE_corr != 0)]
for i in ['area','eccentricity']:
    for j in ['PE_corr','APC_corr']:
        if i != j:
            #sns.lmplot(x = i,y = j,data = df_updated_clean,scatter_kws={"s": 0.5})
            #rho,p = pearsonr(df_updated[i],df_updated[j])
            sns.lmplot(x = i,y = j,data = df_mean,scatter_kws={"s": 100})
            rho,p = pearsonr(df_mean[i],df_mean[j])
            plt.xlabel(i)
            plt.ylabel(j)
            plt.show()
            
            print('pearson corr: ')
            print(rho)

    
       


