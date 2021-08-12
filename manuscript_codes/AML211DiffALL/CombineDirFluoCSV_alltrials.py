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

numtrial = 3
csvs_dirname_trial1 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial1/csvs/'
csvs_dirname_trial2 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial2/csvs/'
csvs_dirname_trial3 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrial3/csvs/'


csvs_dirname_all = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/';

combined_name = 'CombinedMaskDirFluo.csv'

#define an empty dataframe with all the corresponding columns
total_df = pd.DataFrame(columns=['dirname','pos', 't','cell', 'Xcenter', 'Ycenter','APC_corr','APC','PE_corr','PE','Trial'])

for i in range(numtrial):
    exec('os.chdir(csvs_dirname_trial{})'.format(i+1))
    df = pd.read_csv(combined_name)
    trial_name = [i+1]*len(df.index)
    df['Trial'] = trial_name
    total_df = pd.concat([total_df, df],sort = False)
    
#save the combined dataframe
total_df.to_csv(csvs_dirname_all+combined_name, sep=',')
