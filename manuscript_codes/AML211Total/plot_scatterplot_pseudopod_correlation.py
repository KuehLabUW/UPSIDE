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
from random import gauss



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
prop_list = ['APC_corr','PE_corr','area','eccentricity','sharpvalue']
df_updated = df[namelist]


APC_corr_log = np.log10(df_updated.APC_corr + 1)
PE_corr_log = np.log10(df_updated.PE_corr + 1)
df_updated.iloc[:,list(df_updated).index('APC_corr')] = np.array(APC_corr_log)
df_updated.iloc[:,list(df_updated).index('PE_corr')] = np.array(PE_corr_log)


def list_diff(list1, list2): 
	return (list(set(list1) - set(list2))) 

def calculate_Mann_WhitneyU(data1,data2):
    
    n1 = len(data1)
    n2 = len(data2)
    # first make a dataframe using data and then get the rank
    df_rank = pd.DataFrame(data = {'data':list(data1)+list(data2)})
    df_rank['rank'] = df_rank['data'].rank()
    
    # get the sum of the rank for data1 and data2
    R1 = np.sum([df_rank.iloc[i,1] for i in range(len(df_rank)) if df_rank.iloc[i,0] in list(data1)] )
    R2 = np.sum([df_rank.iloc[i,1] for i in range(len(df_rank)) if df_rank.iloc[i,0] in list(data2)] )
    
    # calculate U values for the two data
    U1 = n1*n2 + (n1*(n1+1))/2 - R1
    U2 = n1*n2 + (n2*(n2+1))/2 - R2
    
    return min(U1,U2)
    

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
    prop_list = ['APC_corr','PE_corr','area','eccentricity','sharpvalue']
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
std_matrix = np.zeros([2,len(np.unique(df_updated[group_choice])),len(featurelist+prop_list)])    
mean_matrix = np.zeros([2,len(np.unique(df_updated[group_choice])),len(featurelist+prop_list)])
corr_matrix = np.zeros([2,len(featurelist+prop_list),len(featurelist+prop_list)])    

corr_matrix[0,:,:],mean_matrix[0,:,:],std_matrix[0,:,:] = get_corrmatrix(df_updated,1)
corr_matrix[1,:,:],mean_matrix[1,:,:],std_matrix[1,:,:] = get_corrmatrix(df_updated,3)

 
#corr_matrix_std = np.std(corr_matrix,axis = 2)

corr_matrix_prop = corr_matrix[:,:len(featurelist),-len(prop_list):]
corr_matrix_prop_mean = np.mean(corr_matrix_prop,axis=0)
corr_matrix_prop_std = np.std(corr_matrix_prop,axis=0)
#%%
###################################################### PLOT BARPLOTS ###############################################
# plot barplots
feature = 'APC_corr'
m = corr_matrix_prop_mean[:,prop_list.index(feature)]
s = corr_matrix_prop_std[:,prop_list.index(feature)]

m_sorted = np.sort(m)
sorted_idx = np.argsort(m)
s_sorted = np.array([s[i] for i in sorted_idx])
f_sorted = [featurelist[i] for i in sorted_idx]


feature = 'PE_corr'
m = corr_matrix_prop_mean[:,prop_list.index(feature)]
s = corr_matrix_prop_std[:,prop_list.index(feature)]

m_sorted2 = np.sort(m)
sorted_idx2 = np.argsort(m)
s_sorted2 = np.array([s[i] for i in sorted_idx2])
f_sorted2 = [featurelist[i] for i in sorted_idx2]


#%% plot selected features for cell pseudopod features

N_APC = [i for i in range(len(f_sorted)) if f_sorted[i] in ['m47','m77','m11','m38','m45','m30','m23','m27','m18','m31','m58','m55']]
N_PE = [i for i in range(len(f_sorted2)) if f_sorted2[i] in ['m47','m77','m11','m38','m45','m30','m23','m27','m18','m31','m58','m55']]


Xrand = [];
for i in m_sorted[N_APC]:
    Xrand.append(gauss(1,0.02))
for i in m_sorted2[N_PE]:
    Xrand.append(gauss(1.3,0.02))

m_sorted_both = np.concatenate((m_sorted[N_APC],m_sorted2[N_PE]),axis= 0)
plt.scatter(Xrand,m_sorted_both,s= 50)
plt.xlim([0.8,1.5])
plt.ylim([-1,1])
plt.savefig("/home/phnguyen/Desktop/scattercorr3.svg")

#%% plot all features correlation
N_APC_all = [i for i in range(len(f_sorted)) if f_sorted[i] in list_diff(list(m_df_chosen),['m47','m77','m11','m38','m45','m30','m23','m27','m18','m31','m58','m55'])]
N_PE_all = [i for i in range(len(f_sorted2)) if f_sorted2[i] in list_diff(list(m_df_chosen),['m47','m77','m11','m38','m45','m30','m23','m27','m18','m31','m58','m55'])]


Xrand = [];
for i in m_sorted[N_APC_all]:
    Xrand.append(gauss(1,0.02))
for i in m_sorted2[N_PE_all]:
    Xrand.append(gauss(1.3,0.02))

m_sorted_both_all = np.concatenate((m_sorted[N_APC_all],m_sorted2[N_PE_all]),axis= 0)
plt.scatter(Xrand,m_sorted_both_all,s= 50)
plt.xlim([0.8,1.5])
plt.ylim([-1,1])
plt.savefig("/home/phnguyen/Desktop/scattercorrALL.svg")

#%% calculate the negative u witney test between all population and cell protrusion features

# compare APC
sample_pseudo = m_sorted[N_APC]
sample_rest = m_sorted[N_APC_all]
U = calculate_Mann_WhitneyU(sample_pseudo, sample_rest)
print(len(sample_pseudo))
print(len(sample_rest))
print(' p < 0.005')

# compare APC
sample_pseudo = m_sorted2[N_PE]
sample_rest = m_sorted2[N_PE_all]
U = calculate_Mann_WhitneyU(sample_pseudo, sample_rest)
print(len(sample_pseudo))
print(len(sample_rest))
print('n.s')



