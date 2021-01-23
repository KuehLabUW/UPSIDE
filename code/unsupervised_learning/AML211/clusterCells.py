#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 20 15:02:23 2019

@author: phnguyen
"""
# This script cluster cells based on its latent dimensions from shape and texture analysis
import pandas as pd
import os
from sklearn.neighbors import kneighbors_graph
import umap
import numpy as np
import community
import networkx as nx
import sys
import argparse

global args
parser = argparse.ArgumentParser(description="cluster cell with umap")
parser.add_argument("-d", "--csvs_dirname", dest="csvs_dirname", help="enter directory to the csv files")
parser.add_argument("-m", "--root_mask_name", dest="root_mask_name", help="csv file name carrying identifying information for the mask crops")
parser.add_argument("-t", "--root_texture_name", dest="root_texture_name", help="csv file name carrying identifying information for the texure crops")
parser.add_argument("-a", "--style_mask_name", dest="style_mask_name", help ="csv file name carrying latent information for the mask crops")
parser.add_argument("-x", "--style_texture_name", dest="style_texture_name", help ="csv file name carrying latent information for the texture crops")
parser.add_argument("-o", "--output_csvname", dest="output_csvname", help ="csv output file name")

args = parser.parse_args()


csvs_dirname = args.csvs_dirname 
root_mask_name = args.root_mask_name 
root_texture_name = args.root_texture_name 
style_mask_name = args.style_mask_name 
style_texture_name = args.style_texture_name 
output_csvname = args.output_csvname

#Get raw latent z data
os.chdir(csvs_dirname)

df_root_mask = pd.read_csv(root_mask_name,names=["pos", "t", "cell", "trial"])
df_root_texture = pd.read_csv(root_texture_name, names=["pos", "t", "cell", "trial"])

df_style_mask = pd.read_csv(style_mask_name,names = range(1,101))
array_m = df_style_mask.values
df_style_texture = pd.read_csv(style_texture_name,names = range(1,101))
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

G = kneighbors_graph(array_mt, 200, mode='connectivity', include_self=True) #was 50
G1 = nx.from_scipy_sparse_matrix(G)
partition = community.best_partition(G1,resolution = 0.9)

#%%
#attached the clustering information back to the dataframe
print('adding to dataframe...')
#correct the label dataframe


df_root_mask['xumap'] = umap_result2D[:,0]
df_root_mask['yumap'] = umap_result2D[:,1]
df_root_mask['group'] = list(partition.values())

#%%
# =============================================================================
df = df_root_mask

#%% load the mask and texture dimensions onto df
# =============================================================================
     
for j in range(array_m.shape[1]):
     exec("df['m{}'] = array_m[:,j]".format(j))
for j in range(array_t.shape[1]):
     exec("df['t{}'] = array_t[:,j]".format(j))
 
#%% save data
df.to_csv(output_csvname, index = False)


