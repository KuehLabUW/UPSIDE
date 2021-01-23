#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 26 16:19:11 2019

@author: phnguyen

This script annotates the summary cell crop csv file with the trial and cell type for each cell crop
"""
import pandas as pd
import argparse


global args
parser = argparse.ArgumentParser(description="subim data concatenation")
parser.add_argument("-d", "--csvs_name", dest="csvs_name", help="name + directory  of the summary csv file")
parser.add_argument("-o", "--csvs_outname", dest="csvs_outname", help=" name + directory of the summary csv file")
args = parser.parse_args()

# name and directory of the summary csv file
csvs_name = args.csvs_name

# name and directory fo the annotated csv file
csvs_outname = args.csvs_outname

df = pd.read_csv(csvs_name)


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
df.to_csv(csvs_outname, index = False)