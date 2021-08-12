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


df1_PCA = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/COMPCA_Chosen_1.csv')
df1_VAE = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/COMVAE_Chosen_1.csv')

df2_PCA = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/COMPCA_Chosen_2.csv')
df2_VAE = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/COMVAE_Chosen_2.csv')


#%% plot mean score
plt.xlim([0,1])
plt.ylim([0,0.8])
#plt.errorbar(df1_PCA.fractionMask,np.mean([df1_PCA.total,df2_PCA.total],0),np.std([df1_PCA.total,df2_PCA.total],0),label = 'PCA')
#plt.errorbar(df1_VAE.fractionMask,np.mean([df1_VAE.total,df2_VAE.total],0),np.std([df1_VAE.total,df2_VAE.total],0),label = 'VAE')
plt.plot(df1_PCA.fractionMask,np.mean([df1_PCA.total,df2_PCA.total],0))
y_error_s = np.mean([df1_PCA.total,df2_PCA.total],0)-np.std([df1_PCA.total,df2_PCA.total],0)
y_error_a = np.mean([df1_PCA.total,df2_PCA.total],0)+np.std([df1_PCA.total,df2_PCA.total],0)
plt.fill_between(df1_PCA.fractionMask,y_error_s,y_error_a)

plt.plot(df1_VAE.fractionMask,np.mean([df1_VAE.total,df2_VAE.total],0))
y_error_s = np.mean([df1_VAE.total,df2_VAE.total],0)-np.std([df1_VAE.total,df2_VAE.total],0)
y_error_a = np.mean([df1_VAE.total,df2_VAE.total],0)+np.std([df1_VAE.total,df2_VAE.total],0)
plt.fill_between(df1_PCA.fractionMask,y_error_s,y_error_a)
plt.xlabel('fraction contribution from mask')
plt.ylabel('mean nearest neighbor score')
plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/celltype_meanscore.svg', format='svg')
plt.show()
#%% plot individual species score for the best fraction
#PCA = [np.mean([df1_PCA.AML_Stem[18],df2_PCA.AML_Stem[18]],0),np.mean([df1_PCA.Kasumi_1[18],df2_PCA.Kasumi_1[18]],0),np.mean([df1_PCA.P2C2[18],df2_PCA.P2C2[18]],0),np.mean([df1_PCA.Macrophage[18],df2_PCA.Macrophage[18]],0)]
#PCAerr = [np.std([df1_PCA.AML_Stem[18],df2_PCA.AML_Stem[18]],0),np.std([df1_PCA.Kasumi_1[18],df2_PCA.Kasumi_1[18]],0),np.std([df1_PCA.P2C2[18],df2_PCA.P2C2[18]],0),np.std([df1_PCA.Macrophage[18],df2_PCA.Macrophage[18]],0)]
#
#VAE = [np.mean([df1_VAE.AML_Stem[82],df2_VAE.AML_Stem[82]],0),np.mean([df1_VAE.Kasumi_1[82],df2_VAE.Kasumi_1[82]],0),np.mean([df1_VAE.P2C2[82],df2_VAE.P2C2[82]],0),np.mean([df1_VAE.Macrophage[82],df2_VAE.Macrophage[82]],0)]
#VAEerr = [np.std([df1_VAE.AML_Stem[82],df2_VAE.AML_Stem[82]],0),np.std([df1_VAE.Kasumi_1[82],df2_VAE.Kasumi_1[82]],0),np.std([df1_VAE.P2C2[82],df2_VAE.P2C2[82]],0),np.std([df1_VAE.Macrophage[82],df2_VAE.Macrophage[82]],0)]


#
#plt.ylim([0,0.8])

VAE = [np.mean([df1_VAE.AML_Stem[0],df2_VAE.AML_Stem[0]],0),np.mean([df1_VAE.Kasumi_1[0],df2_VAE.Kasumi_1[0]],0),np.mean([df1_VAE.P2C2[0],df2_VAE.P2C2[0]],0),np.mean([df1_VAE.Macrophage[0],df2_VAE.Macrophage[0]],0)]
VAEerr = [np.std([df1_VAE.AML_Stem[0],df2_VAE.AML_Stem[0]],0),np.std([df1_VAE.Kasumi_1[0],df2_VAE.Kasumi_1[0]],0),np.std([df1_VAE.P2C2[0],df2_VAE.P2C2[0]],0),np.std([df1_VAE.Macrophage[0],df2_VAE.Macrophage[0]],0)]
VAE1 = [np.mean([df1_VAE.AML_Stem[70],df2_VAE.AML_Stem[70]],0),np.mean([df1_VAE.Kasumi_1[70],df2_VAE.Kasumi_1[70]],0),np.mean([df1_VAE.P2C2[70],df2_VAE.P2C2[70]],0),np.mean([df1_VAE.Macrophage[70],df2_VAE.Macrophage[70]],0)]
VAEerr1 = [np.std([df1_VAE.AML_Stem[70],df2_VAE.AML_Stem[70]],0),np.std([df1_VAE.Kasumi_1[70],df2_VAE.Kasumi_1[70]],0),np.std([df1_VAE.P2C2[70],df2_VAE.P2C2[70]],0),np.std([df1_VAE.Macrophage[70],df2_VAE.Macrophage[70]],0)]
VAE2 = [np.mean([df1_VAE.AML_Stem[98],df2_VAE.AML_Stem[98]],0),np.mean([df1_VAE.Kasumi_1[98],df2_VAE.Kasumi_1[98]],0),np.mean([df1_VAE.P2C2[98],df2_VAE.P2C2[98]],0),np.mean([df1_VAE.Macrophage[98],df2_VAE.Macrophage[98]],0)]
VAEerr2 = [np.std([df1_VAE.AML_Stem[98],df2_VAE.AML_Stem[98]],0),np.std([df1_VAE.Kasumi_1[98],df2_VAE.Kasumi_1[98]],0),np.std([df1_VAE.P2C2[98],df2_VAE.P2C2[98]],0),np.std([df1_VAE.Macrophage[98],df2_VAE.Macrophage[98]],0)]




fig, ax = plt.subplots()
ind = np.array([0,1.5,3,4.5])
width = 0.35
ax.bar(ind-width,VAE,width,yerr = VAEerr,label = '*')
ax.bar(ind,VAE1,width,yerr = VAEerr1,label = '**')
ax.bar(ind+width,VAE2,width,yerr = VAEerr2,label = '***')


plt.xticks(ind,['Stem','Kasumi_1','P2C2','Macrophage'])
plt.ylabel('nearest neighbor score')
plt.legend()
plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/celltype_bestscores0.svg', format='svg')

plt.show()

#%% plot 2D UMAP of best score
df_label = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/CombinedDirTypeChosen2.csv')

df1 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/style_PCA_CellTypes_VAE_LargeMaskChosen.csv',header=None)
arrayPCA_m = df1.values

df2 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/style_CellTypes020420_VAE_TextureChosen.csv',header=None)
arrayVAE_t = df2.values

df3 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/style_PCA_CellTypes_VAE_textureChosen.csv',header=None)
arrayPCA_t = df3.values

df4 = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/style_CellTypes020420_VAE_MaskChosen.csv',header=None)
arrayVAE_m = df4.values

reducer = umap.UMAP(random_state=50)


trial = 1;


print('performing COM PCA.....')
f = 0.2
arrayCOM_PCA = np.concatenate((arrayPCA_m*f,arrayPCA_t*(1-f)),1)
umap_resultsCOM_PCA = reducer.fit_transform(arrayCOM_PCA)
df_new = pd.DataFrame(umap_resultsCOM_PCA,columns=['x_umap','y_umap'])
df_subP = pd.concat([df_label,df_new],1)
#df_subP.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/PCA_umap.csv')
#if trial == 1:
#    df_subP = df_subP[df_subP.trial == 1]
#elif trial == 2:
#    df_subP = df_subP[df_subP.trial == 2]


print('performing COM VAE.....')
#f=0.82
#f=0
f=0.7
arrayCOM_VAE = np.concatenate((arrayVAE_m*f,arrayVAE_t*(1-f)),1)
umap_resultsCOM_VAE = reducer.fit_transform(arrayCOM_VAE)
df_new = pd.DataFrame(umap_resultsCOM_VAE,columns=['x_umap','y_umap'])
df_sub = pd.concat([df_label,df_new],1)
#df_sub.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/VAE_umap.csv')

#if trial == 1:
#    df_sub = df_sub[df_sub.trial == 1]
#elif trial == 2:
#    df_sub = df_sub[df_sub.trial == 2]
    
#%% plot individualc population
key = {1:'RAW246.7',2:'Kasumi-1',3:'P2C2',4:'AML211_CD34+CD38-'}  
default_color = False
if default_color == True:
    colors = sns.color_palette()
    sns.lmplot(x='x_umap',y='y_umap',data=df_subP,fit_reg=False,legend=True,hue = 'type',palette = colors, scatter_kws={"s": 8})
    plt.show()
    sns.lmplot(x='x_umap',y='y_umap',data=df_sub,fit_reg=False,legend=True,hue = 'type',palette = colors, scatter_kws={"s": 8})
else:
    celltype  = 4
    gray =  "#95a5a6"
    red = "#e74c3c"
    colors = [gray,red]
    
    collect = [];
    #df_sub = df_sub.reset_index()
    for i in range(len(df_sub)):
        if df_sub.type[i] == celltype:
            collect.append(2)
        else:
            collect.append(1)
    df_sub['collect'] = collect
            
            
    collect = [];
    #df_subP = df_subP.reset_index()
    for i in range(len(df_subP)):
        if df_subP.type[i] == celltype:
            collect.append(2)
        else:
            collect.append(1)
    df_subP['collect'] = collect
    
    sns.lmplot(x='x_umap',y='y_umap',data=df_subP,fit_reg=False,legend=False,hue = 'collect',palette = colors, scatter_kws={"s": 8})
    #plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/umap_PCA_{}.svg'.format(key[celltype]), format='svg')
    plt.show()
    sns.lmplot(x='x_umap',y='y_umap',data=df_sub,fit_reg=False,legend=False,hue = 'collect',palette = colors, scatter_kws={"s": 8})
    #plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/umap_VAE_{}.svg'.format(key[celltype]), format='svg')

#plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes112319/csvs/umap_PCA_{}.eps'.format(key[celltype]), format='eps')
#plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes112319/csvs/umap_PCA.eps', format='eps')



#plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes112319/csvs/umap_VAE_{}.eps'.format(key[celltype]), format='eps')
#plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes112319/csvs/umap_VAE.eps', format='eps')

