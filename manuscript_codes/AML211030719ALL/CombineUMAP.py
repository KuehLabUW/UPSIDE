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
combined_csvname_drug = 'CombinedNormalizedDirFluoUMAPdrug.csv';
combined_csvname_nondrug = 'CombinedNormalizedDirFluoUMAPnondrug.csv';

dirCSVname  = 'AML211_ALLNormalizedDirFluotruncated.csv'
UMAPCSVname = 'AML211_umap.csv'
#make utils function
def merge_dir_fluo_df(df_1,df_2):

    #merge the two together to match IDs
    merge_df = pd.merge(df_1,df_2,on=['pos', 't','cell'],how = 'inner')
    
    return merge_df



total_dirdf = pd.read_csv(dirCSVname)
total_UMAPdf = pd.read_csv(UMAPCSVname)

df_dir_nondrug = total_dirdf.iloc[:104989,2:]
df_dir_drug    = total_dirdf.iloc[104990:,2:]

df_umap_nondrug = total_UMAPdf.iloc[:104989,1:]
df_umap_drug    = total_UMAPdf.iloc[104990:,1:]

combinded_df_nondrug = merge_dir_fluo_df(df_dir_nondrug,df_umap_nondrug)
combinded_df_drug = merge_dir_fluo_df(df_dir_drug,df_umap_drug)

combinded_df_nondrug.to_csv(combined_csvname_nondrug, sep=',')
combinded_df_drug.to_csv(combined_csvname_drug, sep=',')