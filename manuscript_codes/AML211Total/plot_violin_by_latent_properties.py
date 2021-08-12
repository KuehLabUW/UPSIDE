#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 27 11:24:12 2020

@author: phnguyen
"""


import pandas as pd
import os
import umap
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns


# this script lets you specify a list of features and a biological feature
# of interest and it will genrate violin plots comparing the means vs those
# with high value for such features

# enter properties name
prop_name = 'PE_corr'; # 'APC_corr','PE_corr','distance'
# enter the list of features
#flist = ['m47','m80','m77','m17','m5','all','m85','m19','m24','m61','m46'];
flist = ['all','t17','t51','t79','t47','t78'];
# enter the feature value threshold
thresh = 4;

# Extract datamatrix
if prop_name == 'distance':
    df = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/cluster_tracked_dist_area_dist_cond.csv');
    df = df[df['pcell'] > 0]
    distance = df.distance *0.1625;
    df.iloc[:,list(df).index('distance')] = np.array(distance)
else:
    df = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/Dataset1CompleteAreaEdgeFluoClusterCenter.csv')
    df = df[df['trial']!=2]
    APC_corr_log = np.log10(df.APC_corr + 1)
    PE_corr_log = np.log10(df.PE_corr + 1)
    df.iloc[:,list(df).index('APC_corr')] = np.array(APC_corr_log)
    df.iloc[:,list(df).index('PE_corr')] = np.array(PE_corr_log)

#go through each feature, extract the cells, and add them to a master df
    
df_violin = pd.DataFrame(columns = ['values','flag'])
for feature in flist:
    # calculate population mean if keyword is triggered
    if feature == 'all':
        values = list(df[prop_name])
    else: 
        df_feature = df[df[feature] > thresh]
        values = list(df_feature[prop_name])
    flag =  [feature]*len(values)
    sub_df = pd.DataFrame(data = {'values':values,'flag':flag},columns = ['values','flag'])
    df_violin = df_violin.append(sub_df)
    
# plot violin
sns.violinplot(x = 'flag',y = 'values',data= df_violin)
plt.savefig('/home/phnguyen/Desktop/violin{}.svg'.format(prop_name))    

