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

os.chdir(csvs_dirname)

filename = 'AML211DiffALL_LargeMask_Annotated.csv'

df = pd.read_csv(filename)
print(len(df))
pos = [];
for i in range(len(df.index)):
    if os.path.isfile(df.dirname[i]) == False:
        pos.append(i)
    print(i)
        
df.drop(df.index[pos], inplace=True)     
#save the combined dataframe
df.to_csv(csvs_dirname+'AML211DiffALL_LargeMask_Annotated_trimmed.csv', sep=',')
