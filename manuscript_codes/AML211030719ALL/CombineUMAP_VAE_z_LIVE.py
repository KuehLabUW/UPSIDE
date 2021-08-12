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

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/'
os.chdir(csvs_dirname)
combined_csvname = 'CombinedDirUMAP_VAE_LargeMask_Watershed_Subgate.csv';
#combined_csvname = 'CombinedSubstractedDirUMAP_GANdis.csv';


dirCSVname  = 'test_LIVE_LargeMaskWatershed_fluo.csv'
UMAPCSVname = 'AML211_umap_VAE_LargeMask_subgateWatershed.csv'
#UMAPCSVname = 'AML211_umap_GANdis_largeLIVE.csv'
#make utils function
def merge_dir_fluo_df(df_1,df_2):

    #merge the two together to match IDs
    merge_df = pd.merge(df_1,df_2,on=['treated','pos', 't','cell'],how = 'inner')
    
    return merge_df



total_dirdf = pd.read_csv(dirCSVname)
total_UMAPdf = pd.read_csv(UMAPCSVname)


combinded_df = merge_dir_fluo_df(total_dirdf,total_UMAPdf)


combinded_df.to_csv(combined_csvname, sep=',')
