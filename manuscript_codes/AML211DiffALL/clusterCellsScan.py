#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 20 15:02:23 2019

@author: phnguyen
"""
# This script cluster cells based on its latent dimensions from shape and texture analysis
import pandas as pd
import os
from scipy.spatial import distance_matrix
from sklearn.neighbors import kneighbors_graph
import umap
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import community
import networkx as nx
from sklearn.cluster import DBSCAN

#import random
#Get raw latent z data
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/'
os.chdir(csvs_dirname)


df_old = pd.read_csv('Dataset1CompleteAreaEdgeFluoCluster.csv')


# choose 1000 cells from each cluster
numcell = 2000;
df_list = [];
for i in range(len(np.unique(df_old.cluster))):
    subdf = df_old[df_old.cluster == i+1]
    chosen_df = subdf.sample(n=numcell)
    df_list.append(chosen_df)
    
df = pd.concat(df_list)


#%%
array_m = df.iloc[:,12:12+100].values

array_t = df.iloc[:,112:112+100].values



####combine the z dim from both texture and mask
f = 0.7 # specify contribution from mask
array_mt = np.concatenate((array_m*f,array_t*(1-f)),1)#only get the last 60 dimensions for the shape that has the largest variation

neighbor_list = np.arange(10,510,10)
dist_list = np.arange(0)
for n in neighbor_list:
    for d in [0]:
        #%%
        df_test = df
        reducer2D = umap.UMAP(n_components=2,random_state=50,n_neighbors=n,min_dist= d)
        print('performing combined umap 2D...')
        umap_result2D = reducer2D.fit_transform(array_mt)


        print('adding to dataframe...')

        df_test['XUMAP'] = umap_result2D[:,0]
        df_test['YUMAP'] = umap_result2D[:,1]

        sns.lmplot(x='XUMAP',y='YUMAP',data=df_test,hue = 'cluster',fit_reg=False,legend=True,scatter_kws={"s": 5})
        plt.show()
        print('n_neighbors: {}'.format(n))
        print('min_dist: {}'.format(d))

#%% plot individualc population
df_test = df
df_test = df_test.reset_index()
reducer2D = umap.UMAP(n_components=2,random_state=50,n_neighbors=40,min_dist= 0)
print('performing combined umap 2D...')
umap_result2D = reducer2D.fit_transform(array_mt)


print('adding to dataframe...')

df_test['XUMAP'] = umap_result2D[:,0]
df_test['YUMAP'] = umap_result2D[:,1]

  
default_color = False
#%%
if default_color == True:
    colors = sns.color_palette()
    sns.lmplot(x='XUMAP',y='YUMAP',data=df_test,hue = 'cluster',fit_reg=False,legend=True,scatter_kws={"s": 5})
    plt.show()
    
else:
    celltype  = 8
    gray =  "#95a5a6"
    red = "#e74c3c"
    colors = [gray,red]
    
    collect = [];
    #df_sub = df_sub.reset_index()
    for i in range(len(df_test)):
        if df_test.cluster[i] == celltype:
            collect.append(2)
        else:
            collect.append(1)
    df_test['collect'] = collect
            
            
    collect = [];
    #df_subP = df_subP.reset_index()
    for i in range(len(df_test)):
        if df_test.cluster[i] == celltype:
            collect.append(2)
        else:
            collect.append(1)
    df_test['collect'] = collect
    
    sns.lmplot(x='XUMAP',y='YUMAP',data=df_test,fit_reg=False,legend=False,hue = 'collect',palette = colors, scatter_kws={"s": 8})
    plt.show()
    
        


