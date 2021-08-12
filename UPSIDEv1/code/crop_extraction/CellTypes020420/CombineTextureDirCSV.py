#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 23 16:21:25 2019
this script concatenates subim data from separate csv files
and return a merged csv file for all positions
@author: phnguyen
"""
import argparse
import pandas as pd
import os


global args
parser = argparse.ArgumentParser(description="subim data concatenation")
parser.add_argument("-d", "--csvs_dirname", dest="csvs_dirname", help="directory of the extracted crop csvs file")
parser.add_argument("-p", "--pos_num", dest="pos_num", type=int, help="number of positions")
parser.add_argument("-c", "--combined_csvname", dest="combined_csvname", help="name of the combined csvs")
args = parser.parse_args()



csvs_dirname = args.csvs_dirname
pos_num = args.pos_num
combined_csvname = args.combined_csvname



os.chdir(csvs_dirname)
#define an empty dataframe with all the corresponding columns
total_df = pd.DataFrame(columns=['dirname','pos', 't','cell', 'Xcenter','Ycenter'])

#loop through each position csv file in fluo, merge with the dircsv and then append to total_df
for i in range(0,pos_num):
    
    dirCSVname  = 'SubImTextureCellTypesShapes020420pos{}.csv'.format(i+1)
    if os.path.isfile(csvs_dirname+dirCSVname):
        dir_df = pd.read_csv(dirCSVname)
    
        total_df = pd.concat([total_df, dir_df])

#save the combined dataframe
total_df.to_csv(combined_csvname, sep=',',index = False)