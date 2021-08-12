# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 16:20:03 2019

@author: samng
"""
import numpy as np
from scipy.spatial import distance_matrix
import pandas as pd
import umap
import seaborn as sns
import matplotlib as plt


######################## Main Script #####################
df_label = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/CombinedSubstractedDirUMAP_ALL.csv')

df1 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/style_PCA_CellTypes_VAE_LargeMask.csv',header=None)
arrayPCA_m = df1.values

df2 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/style_CellTypes_VAE_texture.csv',header=None)
arrayVAE_t = df2.values

df3 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/style_PCA_CellTypes_VAE_texture.csv',header=None)
arrayPCA_t = df3.values

df4 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/style_CellTypes_VAE_LargeMask.csv',header=None)
arrayVAE_m = df4.values

fractionMask = np.arange(0,1.1,0.1)

n_neighbor = 4;

reducer = umap.UMAP(random_state=50)


# now for each combination, loop through each f and add the result into prebuilt df
print('performing COM PCA.....')
f=0.2
arrayCOM_PCA = np.concatenate((arrayPCA_m*f,arrayPCA_t*(1-f)),1)
umap_resultsCOM_PCA = reducer.fit_transform(arrayCOM_PCA)
df_new = pd.DataFrame(umap_resultsCOM_PCA,columns=['x_umap_new','y_umap_new'])
df_PCA = pd.concat([df_label.type,df_new],1)
#df_PCA.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/PCA_umap_best.csv')




print('performing COM VAE.....')
#f=0.7
f =1
arrayCOM_VAE = np.concatenate((arrayVAE_m*f,arrayVAE_t*(1-f)),1)
umap_resultsCOM_VAE = reducer.fit_transform(arrayCOM_VAE)
df_new = pd.DataFrame(umap_resultsCOM_VAE,columns=['x_umap_new','y_umap_new'])
df_VAE = pd.concat([df_label.type,df_new],1)
#df_VAE.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/VAE_umap_best.csv')
df_VAE.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/VAE_umap_mask.csv')

print('performing BOTH.....')
f=0.6
arrayBOTH = np.concatenate((arrayPCA_m*f,arrayVAE_t*(1-f)),1)
umap_resultsBOTH = reducer.fit_transform(arrayBOTH)
df_new = pd.DataFrame(umap_resultsBOTH,columns=['x_umap_new','y_umap_new'])
df_BOTH = pd.concat([df_label.type,df_new],1)
#df_BOTH.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/BOTH_umap_best.csv')










    
