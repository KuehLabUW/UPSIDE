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


df = pd.read_csv('SubDataset1CompleteAreaEdgeFluoCluster.csv')


df_test = df
default_color = False
#%%
if default_color == True:
    colors = sns.color_palette()
    sns.lmplot(x='xumap',y='yumap',data=df_test,hue = 'cluster',fit_reg=False,legend=False,scatter_kws={"s": 5})
    plt.show()
    
else:
    celltype  = 8
    gray =  "#95a5a6"
    red = "#646464"
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
    
    sns.lmplot(x='xumap',y='yumap',data=df_test,fit_reg=False,legend=False,hue = 'collect',palette = colors, scatter_kws={"s": 8})
    plt.show()
    
        


