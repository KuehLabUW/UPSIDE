#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 23 16:21:25 2019
this script concatenates fluorescent data and subim data from separate csv files
and return a merged csv file for all positions
@author: phnguyen
"""

import pandas as pd
import os


csvs_dirname_1 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/Dataset1CompleteAreaEdgeFluoCluster.csv'
csvs_dirname_2 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/CombinedUMAPDirFluoClusterZC.csv'

df_Dataset1 = pd.read_csv(csvs_dirname_1)
df_Center = pd.read_csv(csvs_dirname_2)


XCenter = [];
YCenter = [];


sub_df_Dataset1 = df_Dataset1[['dirname']]
sub_df_Center = df_Center[['dirname','Xcenter','Ycenter']]

sub_merge = pd.merge(sub_df_Dataset1,sub_df_Center,on = ['dirname'],how='inner')
new_merge = pd.merge(df_Dataset1,sub_merge,on = ['dirname'],how='inner')
new_merge.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/Dataset1CompleteAreaEdgeFluoClusterCenter.csv', sep=',',index = False)
#for i in range(len(df_Dataset1)):
#    for j in range(len(df_Center)):
#        if df_Dataset1.dirname[i] == df_Center.dirname[j]:
#        XCenter.append(df_Center.XCenter[j])
#    
#    
#df['Trial'] = trial_name

    
#save the combined dataframe
#total_df.to_csv(csvs_dirname_all+combined_name, sep=',')
