#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  4 11:16:42 2019
his script concatenates complete dir and fluo data with umap data from separate csv files
and return a merged csv file for all positions
@author: phnguyen
"""
import pandas as pd
import os

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/csvs/'
os.chdir(csvs_dirname)
dir_csvname = 'cluster3.csv';
pos_csvname = 'Centers.csv';
combined_csvname = 'cluster3_center.csv';
#UMAPCSVname = 'AML211_umap_GANdis_largeLIVE.csv'
#make utils function
def merge_dir_fluo_df(df_1,df_2):

    #merge the two together to match IDs
    merge_df = pd.merge(df_1,df_2,on=['dirname'],how = 'inner')
    
    return merge_df



dirdf = pd.read_csv(dir_csvname)
posdf = pd.read_csv(pos_csvname)


combinded_df = merge_dir_fluo_df(dirdf,posdf)


combinded_df.to_csv(combined_csvname, sep=',')
