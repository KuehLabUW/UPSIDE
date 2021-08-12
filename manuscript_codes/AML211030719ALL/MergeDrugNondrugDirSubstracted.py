#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 24 13:53:04 2019

@author: phnguyen
"""

import pandas as pd
import os

Nondrug_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719/csvs/'
drug_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719Drug/csvs/'
MegredDrugNondrug_dir = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/'

Nondrug_filename = 'CombinedSubstractedDir.csv'
Drug_filename = 'CombinedSubstractedDirDrug.csv'
MegredDrugNondrug_filename = 'AML211_ALLSubstractedDir.csv'

#get nondrug dataframe
os.chdir(Nondrug_dir)
df1 = pd.read_csv(Nondrug_filename)

#get drug dataframe
os.chdir(drug_dir)
df2 = pd.read_csv(Drug_filename)

#save merged dataframe
os.chdir(MegredDrugNondrug_dir)
total_df = pd.concat([df1, df2])
total_df.to_csv(MegredDrugNondrug_filename, sep=',')