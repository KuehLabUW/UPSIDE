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
import matplotlib as plt
import numpy as np
import community
import networkx as nx
from sklearn.cluster import DBSCAN
#import random
#Get raw latent z data
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/'
os.chdir(csvs_dirname)

df_root_mask = pd.read_csv('root_AML211_VAE_Mask.csv',names=["pos", "t", "cell", "trial","dataset"])
df_root_texture = pd.read_csv('root_AML211_VAE_Texture.csv', names=["pos", "t", "cell", "trial","dataset"])

df_style_mask = pd.read_csv('style_AML211_VAE_Mask.csv',names = range(1,101))
array_m = df_style_mask.values
df_style_texture = pd.read_csv('style_AML211_VAE_Texture.csv',names = range(1,101))
array_t = df_style_texture.values

df_z_mask = pd.concat([df_root_mask,df_style_mask],1)
df_z_texture = pd.concat([df_root_texture,df_style_texture],1)


####combine the z dim from both texture and mask
f = 0.7 # specify contribution from mask
array_mt = np.concatenate((array_m*f,array_t*(1-f)),1)#only get the last 60 dimensions for the shape that has the largest variation


reducer2D = umap.UMAP(n_components=2,random_state=50,n_neighbors=500,min_dist= 0)
#reducer2D = umap.UMAP(n_components=2,random_state=5)
print('performing combined umap 2D...')
umap_result2D = reducer2D.fit_transform(array_mt)

#%%
print('calculating louvain...')

#G = kneighbors_graph(array_mt, 200, mode='connectivity', include_self=True) #was 50
#G1 = nx.from_scipy_sparse_matrix(G)
#partition = community.best_partition(G1,resolution = 0.9)

#%%
#attached the clustering information back to the dataframe
print('adding to dataframe...')
#correct the label dataframe


df_root_mask['xumap'] = umap_result2D[:,0]
df_root_mask['yumap'] = umap_result2D[:,1]
#df_root_mask['group'] = list(partition.values())
#sns.lmplot(x='xumap',y='yumap',data=df_root_mask,hue = 'group',fit_reg=False,legend=True,scatter_kws={"s": 0.5})
sns.lmplot(x='xumap',y='yumap',data=df_root_mask,fit_reg=False,legend=True,scatter_kws={"s": 0.5})
#%%
# =============================================================================
df = df_root_mask
# df1 = df[df['trial']==1]
# df_blast1 = df1[df1['pos']<6]
# df_stem1 = df1[df1['pos']>5]
# 
# 
# df = df#df_stem3
# df_filtered1 = df[(df['t']>1700) & (df['t']<1800)]
# df_filtered2 = df[(df['t']>0) & (df['t']<20)]
# df_group = df[df['group'] == 1]
# #sns.lmplot(x='xumap',y='yumap',data=df,hue = 't',fit_reg=False,legend=False,scatter_kws={"s": 0.5})
# sns.lmplot(x='xumap',y='yumap',data=df_filtered1,hue = 'group',fit_reg=False,legend=True,scatter_kws={"s": 5})
# sns.lmplot(x='xumap',y='yumap',data=df_filtered2,hue = 'group',fit_reg=False,legend=True,scatter_kws={"s": 5})
# sns.lmplot(x='xumap',y='yumap',data=df,hue = 'group',fit_reg=False,legend=False,scatter_kws={"s": 0.5})
# =============================================================================

#%% load the mask dimension onto df
# =============================================================================
     
for j in range(array_m.shape[1]):
     exec("df['m{}'] = array_m[:,j]".format(j))
for j in range(array_t.shape[1]):
     exec("df['t{}'] = array_t[:,j]".format(j))
 
#%%
#df_fluo = pd.read_csv('LIVE_total.csv')
#merge_df = pd.merge(df_fluo,df,on=['pos', 't','cell','trial','dataset'],how = 'inner')
#merge_df.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/CombinedUMAPDirGroup.csv')
# =============================================================================


