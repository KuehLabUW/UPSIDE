#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  6 14:59:30 2020

@author: phnguyen
"""
import pandas as pd
import os
import numpy as np

DiffAllName = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/LIVE_subgate_good.csv'
DiffTrack1Name = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/LIVE_subgate.csv'
DiffTrack2Name = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack2/csvs/LIVE_position_subgate.csv'

csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211Total/csvs/'
os.chdir(csvs_dirname)

DiffAlldf = pd.read_csv(DiffAllName,index_col=False)
DiffAlldf = DiffAlldf.drop(columns=['Unnamed: 0','Unnamed: 1','toss','live','dead'])
DiffAlldf['dataset'] = np.ones([len(DiffAlldf),1])


DiffTrack1df = pd.read_csv(DiffTrack1Name,index_col=False)
DiffTrack1df = DiffTrack1df.drop(columns=['Unnamed: 0','live','dead'])
DiffTrack1df['dataset'] = 2*np.ones([len(DiffTrack1df),1])

DiffTrack2df = pd.read_csv(DiffTrack2Name,index_col=False)
DiffTrack2df = DiffTrack2df.drop(columns=['Xcenter','Ycenter'])
DiffTrack2df['dataset'] = 3*np.ones([len(DiffTrack2df),1])

df_total = pd.concat([DiffAlldf,DiffTrack1df,DiffTrack2df],axis =0)
df_total.to_csv(csvs_dirname +'LIVE_total.csv',index=False)