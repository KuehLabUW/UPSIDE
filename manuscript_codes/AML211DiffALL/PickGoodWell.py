#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 19 17:45:51 2019

@author: phnguyen
"""

import pandas as pd
import os

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/'
os.chdir(csvs_dirname)
csvname = 'LIVE_subgate.csv';
outcsvname = 'LIVE_subgate_good.csv';

good_trial2_wells = [4,5,8,9,10,11,15,16,17,22,24]
good_trial3_wells = [20,27,28,29,34,35,38,40,41,42,48,49,63,67,73,74,75,91,101,102,104,109,111,112,137,140]

df = pd.read_csv(csvname)

df_trial1 = df[df['trial']==1]

df_trial2 = df[df['trial']==2]
df_trial2_blast_good = df_trial2[df_trial2['pos'].isin(good_trial2_wells)]
df_trial2_stem_good  = df_trial2[df_trial2['pos']>49]

df_trial3 = df[df['trial']==3]
df_trial3_good = df_trial3[df_trial3['pos'].isin(good_trial3_wells)]

outdf = pd.concat([df_trial1,df_trial2_blast_good,df_trial2_stem_good,df_trial3_good],0)

outdf.to_csv(csvs_dirname+outcsvname)



