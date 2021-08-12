#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 16 19:03:09 2020

@author: phnguyen
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import umap
import seaborn as sns

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
tsize = 20;
curatedlist = [];

for i in range(3496):
    exec('dfraw = df{}'.format(i+1))
    if (len(dfraw) < tsize) :
        
        sizeleft = tsize - len(dfraw);
        if sizeleft < int(tsize/2)+1:
            df_rep = dfraw.iloc[:sizeleft,:]
            df_curated = pd.concat([dfraw,df_rep],axis = 0)
        
            curatedlist.append(df_curated)
        
    elif len(dfraw) > tsize:
        df_chunks = splitDataFrameIntoSmaller(dfraw,tsize) 
        ##
        for j in range(len(df_chunks)-1):
            
            curatedlist.append(df_chunks[j])
        ##
        df_last = df_chunks[-1]
        sizeleft = tsize - len(df_last);
        if sizeleft < int(tsize/2)+1:
            df_rep = df_last.iloc[:sizeleft,:]
            df_curated = pd.concat([df_last,df_rep],axis = 0)
            df_curated = df_curated.reset_index()
            curatedlist.append(df_curated)
    
    else:
        curatedlist.append(dfraw)
#%%
clusterarray = np.zeros([len(curatedlist),tsize])
umaparray = np.zeros([len(curatedlist),tsize*2])
meantimelist =  np.zeros([len(curatedlist),1])
poslist = np.zeros([len(curatedlist),1])
count = 0
for tr in curatedlist:
    clusterarray[count,:] = tr.cluster;
    umaparray[count,:tsize] = tr.xumap;
    umaparray[count,tsize:] = tr.yumap;
    meantimelist[count,:] = np.mean(tr.t);
    poslist[count,:] = np.mean(tr.pos);
    
    count = count +1
#%%
reducer = umap.UMAP(random_state=50)
umap_resultsCluster = reducer.fit_transform(clusterarray)
df_track_cluster = pd.DataFrame(umap_resultsCluster,columns=['x_umapC','y_umapC'])

umap_resultsUMAP = reducer.fit_transform(umaparray)
df_umap_cluster = pd.DataFrame(umap_resultsUMAP,columns=['x_umapU','y_umapU'])

df_total = pd.concat([pd.DataFrame(meantimelist,columns = ['time']),pd.DataFrame(poslist,columns = ['pos']),df_track_cluster,df_umap_cluster],axis = 1)


#%%
df_total_F = df_total[(df_total['pos'] > 0) & (df_total['pos'] < 6)]
sns.lmplot(x='x_umapC',y='y_umapC',data=df_total_F,fit_reg=False,legend=False,hue = 'time', scatter_kws={"s": 8})
plt.xlim([0,10])
plt.ylim([0,11])
plt.show()
sns.lmplot(x='x_umapC',y='y_umapC',data=df_total_F,fit_reg=False,legend=False,hue = 'time', scatter_kws={"s": 8})
plt.xlim([35,50])
plt.ylim([60,90])
plt.show()
sns.lmplot(x='x_umapU',y='y_umapU',data=df_total_F,fit_reg=False,legend=False,hue = 'time', scatter_kws={"s": 8})





    
    
    
        
