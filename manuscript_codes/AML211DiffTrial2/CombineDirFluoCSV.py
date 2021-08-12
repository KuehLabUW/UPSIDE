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

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial2/csvs/'
os.chdir(csvs_dirname)

combined_csvname = 'CombinedMaskDirFluo.csv';
#make utils function
def merge_dir_fluo_df(dirCSVname,fluoCSVname):

    dir_df = pd.read_csv(dirCSVname)
    fluo_df = pd.read_csv(fluoCSVname)
    #merge the two together to match IDs
    merge_df = pd.merge(dir_df,fluo_df,on=['pos', 't','cell', 'Xcenter', 'Ycenter'],how = 'inner')
    
    return merge_df

#specify number of positions
pos_num = 147

#define an empty dataframe with all the corresponding columns
total_df = pd.DataFrame(columns=['dirname','pos', 't','cell', 'Xcenter', 'Ycenter','APC_corr','APC','PE_corr','PE'])

#loop through each position csv file in fluo, merge with the dircsv and then append to total_df
for i in range(0,pos_num):
    fluoCSVname = 'fluoAML211Trial2pos{}.csv'.format(i+1)
    dirCSVname  = 'SubImTextureAML211DiffTrial2pos{}.csv'.format(i+1)
    if os.path.isfile(csvs_dirname+fluoCSVname) and os.path.isfile(csvs_dirname+dirCSVname) :
        merge_df = merge_dir_fluo_df(dirCSVname,fluoCSVname)
    
        total_df = pd.concat([total_df, merge_df])

#save the combined dataframe
total_df.to_csv(csvs_dirname+combined_csvname, sep=',')