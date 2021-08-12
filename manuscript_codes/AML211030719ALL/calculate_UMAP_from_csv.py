#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 30 16:15:32 2019

@author: phnguyen
"""

import numpy as np
from sklearn import (manifold, datasets, decomposition, ensemble,
             discriminant_analysis, random_projection)
import pandas as pd
import umap
import seaborn as sns
import matplotlib as plt

datapath1 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/small_style_CombinedSubstractedDirUMAP_mixgaus_largeLIVEFLUO60z_nodropout2.csv'
datapath2 = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/large_style_CombinedSubstractedDirUMAP_mixgaus_largeLIVEFLUO60z_nodropout2.csv'
labelpath = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211030719ALL/csvs/CombinedSubstractedDirUMAP_mixgaus_largeLIVEFLUO60z_nodropout2_nostyle.csv'

df1 = pd.read_csv(datapath1,header=None)
df2 = pd.read_csv(datapath2,header=None)
df_label = pd.read_csv(labelpath)

array1 = df1.values
array2 = df2.values

reducer = umap.UMAP(random_state=50)
print('performing umap1....')
umap_results1 = reducer.fit_transform(array1)
print('performing umap2....')
umap_results2 = reducer.fit_transform(array2)
print('done')

array_new = np.concatenate((umap_results1,umap_results2),1)
umap_results3 = reducer.fit_transform(array_new)

array_new = np.concatenate((umap_results1,umap_results2,umap_results3),1)

df_new = pd.DataFrame(array_new,columns=['xumap_small','yumap_small','xumap_large','yumap_large','xumap_both','yumap_both'])
df = pd.concat([df_label, df_new], axis=1)



######################
df_nondrug = df[df['treated']==0]
#df_nondrug.to_csv('AML211_umap_nonDrug_onehot.csv')

df_drug =  df[df['treated']==1]
#df_drug.to_csv('AML211_umap_Drug_onehot.csv')

criteria = df_nondrug['pos']<16
df_filtered = df_nondrug[criteria]

sns.set() # set plotting style
sns.lmplot(x='xumap_large',y='yumap_large',data=df_filtered,fit_reg=False,legend=False,hue='t',scatter_kws={"s": 1})
plt.title('umap_large Result')
plt.xlabel('dimension 1')
plt.ylabel('dimension 2')

