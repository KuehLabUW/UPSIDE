#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 26 16:19:11 2019

@author: phnguyen
"""
import pandas as pd
df = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/CombinedTextureDir.csv')

type = [];
trial = [];
for i in range(len(df)): #condition 1-4 is M,K,P,kG1a respectively
    if df.pos[i] < 31:
        type.append(1.0) #M1
        trial.append(1.0) #M1
    elif df.pos[i] < 61:
        type.append(3.0) #P1
        trial.append(1.0) #P1
    elif df.pos[i] < 91:
        type.append(2.0) #K1
        trial.append(1.0) #K1
    elif df.pos[i] < 121:
        type.append(4.0) #kG1a2
        trial.append(2.0) #kG1a2
    elif df.pos[i] < 151:
        type.append(1.0) #M2
        trial.append(2.0) #M2
    elif df.pos[i] < 181:
        type.append(2.0) #K2
        trial.append(2.0) #K2
    elif df.pos[i] < 211:
        type.append(3.0) #P2
        trial.append(2.0) #P2
    elif df.pos[i] < 241:
        type.append(4.0) #kG1a1
        trial.append(1.0) #kG1a1
    
    print(i)

df['trial'] = trial
df['type'] = type
df.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/CombinedDirType.csv')