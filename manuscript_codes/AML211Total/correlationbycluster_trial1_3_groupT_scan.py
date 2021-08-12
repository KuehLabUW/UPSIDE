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
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/ClusterScan/'
os.chdir(csvs_dirname)


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






corr_box_Master = np.array(None);
for c in np.arange(1,40):
    df = pd.read_csv('datamatrixGroupT{}.csv'.format(c))
    
    # choose the 40 latent z texture and mask with the highest stdev
    
    
    
    featurelist =list(df.iloc[:,18:]);
    namelist = featurelist + ['xumap','yumap','APC_corr','PE_corr','cluster','trial','condition','t','group','area','eccentricity','sharpvalue']
    prop_list = ['APC_corr','PE_corr','area','eccentricity','sharpvalue']
    df_updated = df[namelist]
    
    
    APC_corr_log = np.log10(df_updated.APC_corr + 1)
    PE_corr_log = np.log10(df_updated.PE_corr + 1)
    df_updated.iloc[:,list(df_updated).index('APC_corr')] = np.array(APC_corr_log)
    df_updated.iloc[:,list(df_updated).index('PE_corr')] = np.array(PE_corr_log)
    
    
    
    
    
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
    
    df_clustermember = pd.read_csv('Clustermemberset{}.csv'.format(c),header = None)
    corr_box = 100+np.zeros([np.size(df_clustermember,0)+1,2])
    corr_box[:-1,0] = corr_matrix_prop_mean[:,0] #APC
    corr_box[:-1,1] = corr_matrix_prop_mean[:,1] #PE
    
    if c == 1:
        corr_box_Master = corr_box
    else:
        corr_box_Master = np.concatenate((corr_box_Master,corr_box),0)
    

np.savetxt('corrBox.csv', corr_box_Master, delimiter=',', fmt='%f')
