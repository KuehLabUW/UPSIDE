#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 26 16:19:11 2019

@author: phnguyen
"""
import pandas as pd
df = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/CombinedMaskDirFluoClusterArea.csv')
condition = []
for i in range(len(df)): #condition 1 is differentiation, condition 2 is maintenance
    if df.trial[i] == 1 and df.pos[i] < 17:
        condition.append(1.0)
    if df.trial[i] == 1 and df.pos[i] > 16:
        condition.append(2.0)
    if df.trial[i] == 2 and df.pos[i] < 50:
        condition.append(1.0)
    if df.trial[i] == 2 and df.pos[i] > 49:
        condition.append(2.0)
    if df.trial[i] == 3 and df.pos[i] < 50:
        condition.append(1.0)
    if df.trial[i] == 3 and df.pos[i] > 49:
        condition.append(2.0)
    print(i)

df['condition'] = condition
df.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/CombinedMaskDirFluoClusterArea.csv')