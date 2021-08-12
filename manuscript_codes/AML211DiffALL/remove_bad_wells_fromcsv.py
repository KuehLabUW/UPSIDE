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

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/'
bad_wells_1 = [8,15,20,22,31]
bad_wells_2 = [12,14,18,19,20,21,25,26,31,32,35,37,39,54,56,62,63,75,87,88,94,102,105,106,111,114,115,118,131,136,143]
bad_wells_3 = [3,4,5,10,11,25,36,50,51,55,64,69,71,78,96,97,100,105,110,115,116,131,144,147]

os.chdir(csvs_dirname)

filename = 'LIVE.csv'

df = pd.read_csv(filename)

toss = [0]*len(df.index)

for i in range(len(df.index)):
    if df.trial[i] == 1 and  df.pos[i] in bad_wells_1:
        toss[i] = 1
    if df.trial[i] == 2 and  df.pos[i] in bad_wells_2:
        toss[i] = 1
    if df.trial[i] == 3 and  df.pos[i] in bad_wells_3:
        toss[i] = 1
    print(i)
        
df['toss'] = toss
        
criteria = df['toss'] == 0

df_trimmed = df[criteria]
#save the combined dataframe
df[criteria].to_csv(csvs_dirname+'LIVE_trimmed.csv', sep=',')
