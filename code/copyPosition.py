#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 12 10:50:37 2020

@author: phnguyen
"""

import pandas as pd
import os
from sklearn.neighbors import kneighbors_graph
import umap
import numpy as np
import community
import networkx as nx
import sys


def merge_dir_fluo_df(df_1,df_2):

    #merge the two together to match IDs
    merge_df = pd.merge(df_1,df_2,on=['dirname'],how = 'inner')
    
    return merge_df


root_dir1 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/';
datadirfile1 = 'cluster_tracked_dist_area_dist_cond.csv';





rawfile = pd.read_csv(root_dir1 + datadirfile1);
for line in range(len(rawfile)):
    d = rawfile.iloc[line,0];
    idx = [i for i in range(len(d)) if d.startswith('/', i)][-1]
    d = '/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/SubImTextures/'+ d[idx+1:];
    rawfile.iloc[line,0] = d;
    print(line)
    

celllistfile = pd.read_csv('/media/phnguyen/Data2/Imaging/UPSIDEv1/data/AML211/csvs/cell_list.csv')

#%% extract the dirname and Xcenter/Ycenter
short_rawfile = rawfile.iloc[:,[0,211,210]]

#%% combine the files
pos_file = merge_dir_fluo_df(short_rawfile,celllistfile)