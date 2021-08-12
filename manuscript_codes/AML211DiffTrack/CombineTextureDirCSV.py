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

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/'
os.chdir(csvs_dirname)

combined_csvname = 'CombinedTextureDir.csv';

#specify number of positions
pos_num = 178

#define an empty dataframe with all the corresponding columns
total_df = pd.DataFrame(columns=['dirname','pos', 't','cell', 'Xcenter','Ycenter'])

#loop through each position csv file in fluo, merge with the dircsv and then append to total_df
for i in range(0,pos_num):
    
    dirCSVname  = 'SubImTextureAML211DiffTrackpos{}.csv'.format(i+1)
    if os.path.isfile(csvs_dirname+dirCSVname):
        dir_df = pd.read_csv(dirCSVname)
    
        total_df = pd.concat([total_df, dir_df])

#save the combined dataframe
total_df.to_csv(combined_csvname, sep=',')