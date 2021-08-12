#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 16 19:03:09 2020

@author: phnguyen
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from dtw import dtw, accelerated_dtw
from sklearn.neighbors import kneighbors_graph
import community
import networkx as nx
# input - df: a Dataframe, chunkSize: the chunk size
# output - a list of DataFrame
# purpose - splits the DataFrame into smaller of max size chunkSize (last is smaller)
def splitDataFrameIntoSmaller(df, chunkSize = 10000): 
    listOfDf = list()
    numberChunks = len(df) // chunkSize + 1
    for i in range(numberChunks):
        listOfDf.append(df[i*chunkSize:(i+1)*chunkSize])
    return listOfDf

df = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/Tracks.csv')

Length = [];
for i in range(3496):
    exec('df{} = df[df.track == {}]'.format(i+1,i+1))
    exec('Length.append(len(df{}))'.format(i+1))
#%%
plt.hist(Length,bins = 40)
#%%
print('making curated list..')
tsize = 20;
curatedlist = [];

for i in range(3496):
    exec('dfraw = df{}'.format(i+1))
    if (len(dfraw) < tsize) :
        curatedlist.append(dfraw)
        
    elif len(dfraw) > tsize:
        df_chunks = splitDataFrameIntoSmaller(dfraw,tsize) 
        ##
        for j in range(len(df_chunks)-1):
            
            curatedlist.append(df_chunks[j])
        ##
        df_last = df_chunks[-1]
        sizeleft = tsize - len(df_last);
        if sizeleft < int(tsize/2)+1:
    
            curatedlist.append(df_last)
    
    else:
        curatedlist.append(dfraw)
        
#%% calculated distance scores based on DTW algorithm
print('calculating dtw..')
distMatrix = np.zeros([len(curatedlist),len(curatedlist)])
for i in range(len(curatedlist)):
    for j in range(len(curatedlist)):
        df_1 = curatedlist[i];
        df_2 = curatedlist[j];
        aX = df_1.xumap.values;
        bX = df_1.yumap.values;
        aY = df_2.xumap.values;
        bY = df_2.yumap.values;
        X = np.concatenate((aX.reshape(-1,1),bX.reshape(-1,1)),axis = 1)
        Y = np.concatenate((aY.reshape(-1,1),bY.reshape(-1,1)),axis = 1)
        d, _, _, _ = accelerated_dtw(X,Y,dist= 'euclidean')
        distMatrix[i,j] = d;
#%% cluster using louvain
print('caculating louvain')
G=nx.from_numpy_matrix(distMatrix)
nx.draw(G)
partition = community.best_partition(G)







    
    
    
        
