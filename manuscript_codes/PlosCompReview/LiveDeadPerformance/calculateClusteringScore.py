#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 14 10:33:29 2021

@author: phnguyen
"""

#this script calculates the similarity in clustering performance for each data 
#set by calculating for each of the reference cell, how many of the other cells
# are in the same group and then comparing that set across different dataset

import pandas as pd
import os
import numpy as np
import matplotlib.pyplot as plt

#load the different datasets
name100 = 'CombinedUMAPDirCluster100.csv'
name100_rep = 'CombinedUMAPDirCluster100trial2.csv'
name93 = 'CombinedUMAPDirCluster93.csv'
name75 = 'CombinedUMAPDirCluster75.csv'

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/'
os.chdir(csvs_dirname)

df_100 = pd.read_csv(csvs_dirname+name100)
df_100_rep = pd.read_csv(csvs_dirname+name100_rep)
df_93 = pd.read_csv(csvs_dirname+name93)
df_75 = pd.read_csv(csvs_dirname+name75)

#only choose the reference live cells for analysis
df_75 = df_75[df_75['DEAD']==0];
df_75_dir  = df_75.iloc[:,1];
df_100 = pd.merge(df_100,df_75_dir,on=['dirname'],how = 'inner')
df_100_rep = pd.merge(df_100_rep,df_75_dir,on=['dirname'],how = 'inner')
df_93 = pd.merge(df_93,df_75_dir,on=['dirname'],how = 'inner')
#Calculate similarity grouping score S
S100_rep = [];
S93 =[];
S75 =[];

#loop through each cell in the reference dataset
for  i in range(len(df_100)):
    #find what group this cell is in
    g_ref = df_100.iloc[i,-1] #group
    dir_ref = df_100.iloc[i,1] #dirname
    #find out which cells are in this same group
    set_ref = df_100[df_100['group']==g_ref]
    #loop through the other datasets
    for j in ['100_rep','93','75']:
        exec('df_find = df_'+j);
        #look for the same cell in this dataset
        dir_find = df_find[df_find['dirname']==dir_ref]
        g_find = int(dir_find['group'])
        #find out which cells are in the same group with this cell
        set_find = df_find[df_find['group']==g_find]
        #find out how many of those cells are the same as in the reference set
        set_cross = pd.merge(set_ref,set_find,on=['dirname'],how='inner')
        #add the fraction of matching cells to databasee
        exec('S'+j+'.append(float(len(set_cross))/len(set_find))')
        