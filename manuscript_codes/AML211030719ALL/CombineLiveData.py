#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 23 16:21:25 2019
this script concatenates fluorescent data and subim data from separate csv files
and return a merged csv file for all positions
@author: phnguyen
"""
#remember to delete the leftmost column for compatitibility with AML211Dataset.py
import pandas as pd
import os

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/'
os.chdir(csvs_dirname)

combined_csvname = 'Combined_Live_NormalizedDirFluo.csv';
LiveCSVname = 'AML211_ALLLiveDirInfo.csv'
IniCSVname  = 'AML211_ALLNormalizedDirFluotruncated.csv'

Live_df = pd.read_csv(LiveCSVname)
Ini_df = pd.read_csv(IniCSVname)

total_df = pd.DataFrame(columns=['Unnamed: 0','Unnamed: 0.1','dirname','pos', 't','cell', 'Xcenter', 'Ycenter','APC_corr','APC','PE_corr','PE'])

#loop through each row and match dirname
for row in range(Live_df.shape[0]):
    print(row)
    total_df = pd.concat([total_df, Ini_df[Ini_df.dirname == Live_df.dirname[row]]])

  

#save the combined dataframe
total_df.to_csv(csvs_dirname+combined_csvname, sep=',')