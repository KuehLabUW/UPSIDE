#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan  2 13:04:17 2020

@author: phnguyen
"""
import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
from graphviz import Digraph
import pandas as pd
import os

def plotNetwork(Matrix):
    # the matrix is set up as position i j is direction from element i to j.
    # weight of the line is the magnitude of the transition
    # size of the node is how much residence the node has
    # all is done in graphviz
    f = Digraph('cell_state_transition3')
    
    for nidx in range(len(Matrix)):
        
        circ_size = int(Matrix[nidx,nidx]*10)
        
        text_label = False
        f.attr('node',shape = 'circle',fixedsize = 'false',width = '{}'.format(circ_size),height = '{}'.format(circ_size))
        #f.attr('node',shape = 'circle')
        
        if text_label == True:
            if nidx + 1 == 1:
                f.node('A1',fontsize = '{}'.format(int(Matrix[nidx,nidx]/10)))
            elif nidx + 1 == 2:
                f.node('A2',fontsize = '{}'.format(int(Matrix[nidx,nidx]/10)))
            elif nidx + 1 == 3:
                f.node('A3',fontsize = '{}'.format(int(Matrix[nidx,nidx]/10)))
            elif nidx + 1 == 4:
                f.node('S1',fontsize = '{}'.format(int(Matrix[nidx,nidx]/10)))
            elif nidx + 1 == 5:
                f.node('S2',fontsize = '{}'.format(int(Matrix[nidx,nidx]/10)))
            elif nidx + 1 == 6:
                f.node('S3',fontsize = '{}'.format(int(Matrix[nidx,nidx]/10)))
            elif nidx + 1 == 7:
                f.node('S4',fontsize = '{}'.format(int(Matrix[nidx,nidx]/10)))
            elif nidx + 1 == 8:
                f.node('DB',fontsize = '{}'.format(int(Matrix[nidx,nidx]/10)))
        else:
            f.node('{}'.format(nidx),fontsize = '{}'.format(int(Matrix[nidx,nidx]*100)))
    
    threshold = 0.09
    for i in range(len(Matrix)):
        for j in range(len(Matrix)):
            if i != j and Matrix[i,j] > threshold:
                
                thickness = int(Matrix[i,j]*40)
                
                f.edge('{}'.format(i),'{}'.format(j),penwidth = '{}'.format(2+thickness))
                  
    f.view()
        
    
#%% now load the the transition matrix
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/csvs/'
os.chdir(csvs_dirname)
df = pd.read_csv('cluster3_tracked.csv')
df = df.reset_index()

#%%
subdf_crit = (df['pos']>3) & (df['pos']<7) & (df['t']>0*20) & (df['t']<90*20+1) #1-3 ?? 4-6
subdf = df[subdf_crit]
subdf = subdf.reset_index()

#get group information
subdf['cluster'] = subdf['cluster'] - 1 
cluster = subdf['cluster'].values

#make an empty matrix
AM = np.zeros((len(np.unique(cluster)),len(np.unique(cluster))))
#fill out the adjacent matrix
for c in range(0,len(cluster)):
    g_now = subdf.cluster[c]
    pos_now = subdf.pos[c]
    t_now =subdf.t[c]
    
    pcell = subdf.pcell[c]
    if pcell != 0 :
        df_partner = subdf[(subdf['pos'] == pos_now) & (subdf['cell'] == pcell) & (subdf['t'] == t_now+1)]
        if len(df_partner['cluster']) == 1:
            g_partner = df_partner.cluster
            AM[g_now,g_partner] = AM[g_now,g_partner] + 1
    
    #print(c)
# Normalize by total transitions in each state
NormF = np.sum(AM,axis = 1)
AMN2 = AM/NormF[:,None]
np.savetxt('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/csvs/PropAhRiTrial2.csv',AMN2,delimiter=",")
# plot the the figure
# plotNetwork(AMN2)
#%%
#calculate distance traveled
DIST =[];
for c in range(0,len(df)):
    x_now = df.Xcenter[c]
    y_now = df.Ycenter[c]
    t_now =df.t[c]
    pos_now = df.pos[c]
    
    pcell = df.pcell[c]
    if pcell != 0 :
        df_partner = df[(df['pos'] == pos_now) & (df['cell'] == pcell) & (df['t'] == t_now+1)]
        if len(df_partner['cluster']) == 1:
            x_partner = float(df_partner.Xcenter.values)
            y_partner = float(df_partner.Ycenter.values)
            dist = np.linalg.norm(np.array((x_now,y_now))-np.array((x_partner,y_partner)))
            DIST.append(dist)
            
        else:
            DIST.append(0)
        
    else:
        DIST.append(0)
df['distance'] = DIST
df.to_csv('cluster3_tracked_dist.csv')

