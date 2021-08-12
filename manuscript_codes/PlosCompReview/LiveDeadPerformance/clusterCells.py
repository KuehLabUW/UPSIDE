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
import random
#Get raw latent z data
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/'
os.chdir(csvs_dirname)

for i in [100,93,75,0]:
    
    
    
    if i == 0:
        df_root_mask = pd.read_csv('root_AML211_VAE_Mask100Rnd.csv',names=['pos', 't', 'cell'])    
        df_root_texture = pd.read_csv('root_AML211_VAE_Texture100Rnd.csv', names=['pos', 't', 'cell'])
        df_style_mask = pd.read_csv('style_AML211_VAE_Mask100Rnd.csv',names = range(1,101))
        df_style_texture = pd.read_csv('style_AML211_VAE_Texture100Rnd.csv',names = range(1,101))
    else:
        exec("df_root_mask = pd.read_csv('root_AML211_VAE_Mask{}.csv',names=['pos', 't', 'cell'])".format(i))
        exec("df_root_texture = pd.read_csv('root_AML211_VAE_Texture{}.csv', names=['pos', 't', 'cell'])".format(i))

        exec("df_style_mask = pd.read_csv('style_AML211_VAE_Mask{}.csv',names = range(1,101))".format(i))
        array_m = df_style_mask.values
        exec("df_style_texture = pd.read_csv('style_AML211_VAE_Texture{}.csv',names = range(1,101))".format(i))
        array_t = df_style_texture.values
        
    df_z_mask = pd.concat([df_root_mask,df_style_mask],1)
    df_z_texture = pd.concat([df_root_texture,df_style_texture],1)

    ####combine the z dim from both texture and mask
    f = 0.7 # specify contribution from mask
    array_mt = np.concatenate((array_m*f,array_t*(1-f)),1)#only get the last 60 dimensions for the shape that has the largest variation

    ####umap reduce dimensions to about 10

    reducer2D = umap.UMAP(n_components=2,random_state=50)
    print('performing combined umap 2D...')
    umap_result2D = reducer2D.fit_transform(array_mt)

    #%%
    print('calculating louvain...')

    G = kneighbors_graph(array_mt, 200, mode='connectivity', include_self=True) #was 50
    G1 = nx.from_scipy_sparse_matrix(G)
    partition = community.best_partition(G1,resolution = 0.9,random_state = 50)

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
    df_root_mask['group'] = list(partition.values())
    #%%
    df = df_root_mask
    #%%
    outfile = 'LiveDead{}.csv'.format(i)
    if i == 0:
        outfile = 'LiveDead100.csv'
        
    df_fluo = pd.read_csv(outfile)
    merge_df = pd.merge(df_fluo,df,on=['pos', 't','cell'],how = 'inner')
    
    if i == 0:
        print('flag')
        #merge_df.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/CombinedUMAPDirCluster100Rnd.csv')
    else:
        print('flag')
        #exec("merge_df.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/CombinedUMAPDirCluster{}.csv')".format(i))


