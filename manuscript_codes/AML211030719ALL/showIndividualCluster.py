#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 20 13:33:58 2020

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

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/'
os.chdir(csvs_dirname)

df = pd.read_csv('cluster_all.csv')

#%% plot individualc population

default_color = False
if default_color == True:
    colors = sns.color_palette()
    sns.lmplot(x='xumap',y='yumap',data=df,fit_reg=False,legend=True,hue = 'type',palette = colors, scatter_kws={"s": 8})
    plt.show()
    sns.lmplot(x='xumap',y='yumap',data=df,fit_reg=False,legend=True,hue = 'type',palette = colors, scatter_kws={"s": 8})
else:
    celltype  = 8
    gray =  "#95a5a6"
    red = "#e74c3c"
    colors = [gray,red]
    
    collect = [];
    #df_sub = df_sub.reset_index()
    for i in range(len(df)):
        if df.cluster[i] == celltype:
            collect.append(2)
        else:
            collect.append(1)
    df['collect'] = collect
            
            
    collect = [];
    #df_subP = df_subP.reset_index()
    for i in range(len(df)):
        if df.cluster[i] == celltype:
            collect.append(2)
        else:
            collect.append(1)
    df['collect'] = collect
    
    sns.lmplot(x='xumap',y='yumap',data=df,fit_reg=False,legend=False,hue = 'collect',palette = colors, scatter_kws={"s": 0.5})
    #sns.lmplot(x='xumap',y='yumap',data=df,fit_reg=False,legend=False,hue = 'collect',palette = colors, scatter_kws={"s": 8})