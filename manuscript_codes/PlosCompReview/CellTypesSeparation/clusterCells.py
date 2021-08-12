#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 20 15:02:23 2019

@author: phnguyen
"""
# This script cluster cells based on its latent dimensions from shape and texture analysis
import pandas as pd
import os
import umap
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from sklearn.cluster import KMeans
from sklearn.metrics import accuracy_score
#Get raw latent z data
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/CellTypesSeparation/'
os.chdir(csvs_dirname)


df_root_mask = pd.read_csv('root_CellTypes020420_VAE_MaskChosen.csv',names=['trial','pos', 't', 'cell'])    
df_root_texture = pd.read_csv('root_CellTypes020420_VAE_TextureChosen.csv', names=['trial','pos', 't', 'cell'])
df_style_mask = pd.read_csv('style_CellTypes020420_VAE_MaskChosen.csv',names = range(1,101))
df_style_texture = pd.read_csv('style_CellTypes020420_VAE_TextureChosen.csv',names = range(1,101))


array_m = df_style_mask.values
array_t = df_style_texture.values
df_z_mask = pd.concat([df_root_mask,df_style_mask],1)
df_z_texture = pd.concat([df_root_texture,df_style_texture],1)

####combine the z dim from both texture and mask
f = 0.7 # specify contribution from mask
array_mt = np.concatenate((array_m*f,array_t*(1-f)),1)#only get the last 60 dimensions for the shape that has the largest variation

####umap reduce dimensions to about 10

reducer2D = umap.UMAP(n_components=2)
print('performing combined umap 2D...')
umap_result2D = reducer2D.fit_transform(array_mt)

#%%
print('calculating kmeans...')
data = np.vstack((umap_result2D[:,0],umap_result2D[:,1]))
data = np.transpose(data)

kmeans = KMeans(n_clusters=2,algorithm ='elkan').fit(data)
#%%
#first convert all pos t cell values to int
for j in ['pos','t','cell']:
    L = list(df_root_mask[j])
    L = [int(x) for x in L]
    df_root_mask[j] = L

#attached the clustering information back to the dataframe
print('adding to dataframe...')

df_root_mask['xumap'] = umap_result2D[:,0]
df_root_mask['yumap'] = umap_result2D[:,1]
df_root_mask['group'] = list(kmeans.labels_)
#%%
df = df_root_mask

df_raw = pd.read_csv('CombinedDirTypeChosen2.csv')

df['type'] = df_raw.type
#%% adjust type
type_adj = [];
for i in range(len(df)):
    if df.type[i] == 1 or df.type[i] == 2:
        type_adj.append(0)
    else:
        type_adj.append(1)
df['type_adj'] = type_adj
#%%+
gray =  "#1F77B4"
red = "#D32728"
colors = [gray,red]
sns.lmplot(data=df,x='xumap',y='yumap',hue='group',scatter=True,fit_reg=False,palette = colors,scatter_kws={"s": 10})
plt.savefig(csvs_dirname+'true.jpg')
sns.lmplot(data=df,x='xumap',y='yumap',hue='type_adj',scatter=True,fit_reg=False,palette = colors,scatter_kws={"s": 10})
plt.savefig(csvs_dirname+'predic.jpg')
ACC = accuracy_score(df.type_adj, df.group)



