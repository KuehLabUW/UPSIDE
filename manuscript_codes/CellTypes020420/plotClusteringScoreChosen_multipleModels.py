#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 23 16:14:50 2019

@author: phnguyen
"""


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import umap
import seaborn as sns


mean_total = []
std_total = []

model_namelist = ['VAE','4XAAE','1XAAE','AutoEncoder','PCA','GAN']

for model in model_namelist:
    df1 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/COM_Chosen_{}_1.csv'.format(model))
    df2 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/COM_Chosen_{}_2.csv'.format(model))
    
    mean_data = np.mean([df1.Mean,df2.Mean],0)
    std_data = np.std([df1.Mean,df2.Mean],0)
    
    max_mean = max(mean_data)
    max_std = std_data[np.where(mean_data == max(mean_data))]
    
    mean_total.append(max_mean)
    std_total.append(list(max_std))
    
    

plt.bar([1,2,3,4,5,6],mean_total,yerr = std_total)
plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/celltype_meanscore.svg', format='svg')
plt.show()


