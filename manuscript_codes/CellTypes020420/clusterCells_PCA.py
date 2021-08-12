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
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/'
os.chdir(csvs_dirname)

df_root_mask = pd.read_csv('root_CellTypes020420_VAE_MaskChosen.csv',names=["pos", "t", "cell", "trial"])
df_root_texture = pd.read_csv('root_CellTypes020420_VAE_TextureChosen.csv', names=["pos", "t", "cell", "trial"])

df_style_mask = pd.read_csv('style_PCA_CellTypes_VAE_LargeMaskChosen.csv',names = range(1,101))
array_m = df_style_mask.values
df_style_texture = pd.read_csv('style_PCA_CellTypes_VAE_textureChosen.csv',names = range(1,101))
array_t = df_style_texture.values

df_z_mask = pd.concat([df_root_mask,df_style_mask],1)
df_z_texture = pd.concat([df_root_texture,df_style_texture],1)

####calculate the stdev of each latent dimension from mask and texture v
#std_mask = np.std(array_m,0)
#sorted_ind = np.argsort(std_mask,axis= 0) #returns the indices of sorted values lowest to highest
#array_m = array_m[:,sorted_ind]

#plt.pyplot.plot(range(1,101),std_mask)

#std_texture = np.std(array_t,0)
#sorted_ind = np.argsort(std_texture,axis= 0) #returns the indices of sorted values lowest to highest
#std_mask = std_texture[sorted_ind]
#plt.pyplot.plot(range(1,101),std_texture)

####combine the z dim from both texture and mask
f = 0.1 # specify contribution from mask
array_mt = np.concatenate((array_m*f,array_t*(1-f)),1)#only get the last 60 dimensions for the shape that has the largest variation

####umap reduce dimensions to about 10
reducer = umap.UMAP(n_components=5,random_state=50)
print('performing combined umap 3D...')
umap_result = reducer.fit_transform(array_mt)
reducer2D = umap.UMAP(n_components=2,random_state=50)
print('performing combined umap 2D...')
umap_result2D = reducer2D.fit_transform(array_mt)

#%%
print('calculating louvain...')

#G = kneighbors_graph(umap_result, 50, mode='connectivity', include_self=True) #was 50
G = kneighbors_graph(array_mt, 50, mode='connectivity', include_self=True) #was 50
G1 = nx.from_scipy_sparse_matrix(G)
partition = community.best_partition(G1,resolution = 2)

#%%
#attached the clustering information back to the dataframe
print('adding to dataframe...')
#correct the label dataframe

#df_root_mask1 = df_root_mask.iloc[trial1_randidx,:]
#df_root_mask2 = df_root_mask.iloc[40913:,:]


#df_root_mask = pd.concat([df_root_mask1,df_root_mask2],0)
df_root_mask['xumap'] = umap_result2D[:,0]
df_root_mask['yumap'] = umap_result2D[:,1]
df_root_mask['group'] = list(partition.values())
#%%
df = df_root_mask
df_fluo = pd.read_csv('ChosenCells_Area_Sharp.csv')
merge_df = pd.merge(df_fluo,df,on=['pos', 't','cell','trial'],how = 'inner')
#%%
df = merge_df
df1 = df[df['trial']==1]
#df_blast1 = df1[df1['pos']<17]
#df_stem1 = df1[df1['pos']>16]

df2 = df[df['trial']==2]
#df_blast2 = df2[df2['pos']<50]
#df_stem2 = df2[df2['pos']>49]

df_filtered1 = df1
df_filtered2 = df2

sns.lmplot(x='xumap',y='yumap',data=df_filtered1,hue = 'type',fit_reg=False,legend=True,scatter_kws={"s": 5})
sns.lmplot(x='xumap',y='yumap',data=df_filtered2,hue = 'type',fit_reg=False,legend=True,scatter_kws={"s": 5})
sns.lmplot(x='xumap',y='yumap',data=df,hue = 'type',fit_reg=False,legend=True,scatter_kws={"s": 5})
sns.lmplot(x='xumap',y='yumap',data=df,hue = 'group',fit_reg=False,legend=True,scatter_kws={"s": 5})

#%%
#merge_df.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/CombinedUMAPDirFluoClusterT.csv')


