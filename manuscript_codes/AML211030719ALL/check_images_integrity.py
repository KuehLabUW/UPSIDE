#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 23 14:06:51 2019

@author: phnguyen
"""
import pandas as pd
import os
from skimage import io

MegredDrugNondrug_filename = 'AML211_ALLLargeMaskSubstractedWatershedDir_p3.csv'
dirfile = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/'
os.chdir(dirfile)
df = pd.read_csv(MegredDrugNondrug_filename)
bad_im_idx = []
for i in range(0,len(df)):
    #print(i)
    imname = df.dirname[i]
    try:
        im = io.imread(imname)
    except:
        bad_im_idx.append(i)
        print('bad im #:')
        print(i)
df_new = df.drop(bad_im_idx,axis=0)
df_new = df_new.iloc[:,1:]
df_new.to_csv('AML211_ALLLargeMaskSubstractedWatershedDir_p3.csv', sep=',')
        

