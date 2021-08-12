# -*- coding: utf-8 -*-
"""
Created on Fri May 21 13:21:50 2021

@author: samng
"""
# This script cluster cells based on its latent dimensions from shape and texture analysis
import pandas as pd
import os
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import random
import umap
import community
from scipy.spatial import distance_matrix
from sklearn.neighbors import kneighbors_graph
from scipy.optimize import linear_sum_assignment
from scipy.spatial import distance_matrix
import sklearn
import networkx as nx


csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/PlosCompReview/LiveDeadPerformance/'
os.chdir(csvs_dirname)



for i in ['100Rnd','100','93','75']:

    exec("df_root_mask = pd.read_csv('root_AML211_VAE_Mask{}.csv',names=['pos', 't', 'cell'])".format(i))
    exec("df_root_texture = pd.read_csv('root_AML211_VAE_Texture{}.csv', names=['pos', 't', 'cell'])".format(i))
    
    mnames = ['m{}'.format(j) for j in np.arange(1,101)]
    tnames = ['t{}'.format(j) for j in np.arange(1,101)]
    exec("df_style_mask = pd.read_csv('style_AML211_VAE_Mask{}.csv',names = mnames)".format(i))
    array_m = df_style_mask.values
    array_m = array_m*0.7
    exec("df_style_texture = pd.read_csv('style_AML211_VAE_Texture{}.csv',names = tnames)".format(i))
    array_t = df_style_texture.values
    array_t = array_t*0.3
    df_z_mask = pd.concat([df_root_mask,df_style_mask],1)
    df_z_texture = pd.concat([df_root_texture,df_style_texture],1)
    
    if i == '100Rnd':
        outfile = 'LiveDead100.csv'
    else:    
        outfile = 'LiveDead{}.csv'.format(i)
    df_dir = pd.read_csv(outfile)
    
    merge_df = pd.merge(df_dir,df_z_mask,on=['pos', 't','cell'],how = 'inner')
    merge_df = pd.merge(merge_df,df_z_texture,on=['pos', 't','cell'],how = 'inner')
    
    
    if i =='100':
        df_100 = merge_df
    elif  i == '93':
        df_93 = merge_df
    elif i == '100Rnd':
        df_100Rnd = merge_df
    else:
        df_75 = merge_df

#only choose the reference live cells for analysis
df_75 = df_75[df_75['DEAD']==0];
df_75_dir  = df_75.iloc[:,0];
df_75_dir = df_75_dir.to_frame()
df_75_dir = df_75_dir.reset_index(drop=True)
df_100Rnd = pd.merge(df_100Rnd,df_75_dir,on=['dirname'],how = 'inner')
df_100 = pd.merge(df_100,df_75_dir,on=['dirname'],how = 'inner')
df_93 = pd.merge(df_93,df_75_dir,on=['dirname'],how = 'inner')

#calculate umap and clustering for these data
for i in ['100Rnd','100','93','75']:
    exec('df= df_{}'.format(i))
    array_m = df.iloc[:,7:7+100]
    array_m = array_m.values
    array_t = df.iloc[:,7+100:7+100+100]
    array_t = array_t.values
    
    f = 0.7 # specify contribution from mask
    array_mt = np.concatenate((array_m*f,array_t*(1-f)),1)
    reducer2D = umap.UMAP(n_components=2,random_state=50)
    print('performing combined umap 2D...')
    umap_result2D = reducer2D.fit_transform(array_mt)

    print('calculating louvain...')
    G = kneighbors_graph(array_mt, 200, mode='connectivity', include_self=True) #was 50
    G1 = nx.from_scipy_sparse_matrix(G)
    partition = community.best_partition(G1,resolution = 0.9,random_state = 50)
     
    print('adding to dataframe...')

    df['xumap'] = umap_result2D[:,0]
    df['yumap'] = umap_result2D[:,1]
    df['group'] = list(partition.values())

    exec('df_{}= df'.format(i))
    


# loop through each dataset, generate a distance matrix between the mean location
# of each cluster
group_ref = np.unique(df_100.iloc[:,-1])
ref_mean = np.zeros([len(group_ref),200])
#for g in group_ref:
#    sub_df = df_100[df_100['group']==g]
#    sub_z = sub_df.iloc[:,7:7+200]
#    ref_mean[g,:] = np.mean(sub_z,axis = 0)
    
    
sns.lmplot(data=df_100,x='xumap',y='yumap',hue='group',scatter=True,fit_reg=False,scatter_kws={"s": 10})
plt.xlim([-10,10])
plt.ylim([-10,10])
plt.savefig(csvs_dirname+'df_100.svg')   

RandMatrix =[]; 
for i in ['100Rnd','93','75']:
    exec('dfnow = df_{}'.format(i))
    
    #calculate randi index
    Rscore = sklearn.metrics.adjusted_mutual_info_score(df_100.iloc[:,-1], dfnow.iloc[:,-1], average_method='arithmetic')
    RandMatrix.append(Rscore)
    
    
    group = np.unique(dfnow.iloc[:,-1])
    sim_cost_matrix = np.zeros([len(group_ref),len(group)]) 
    for gref in group_ref:
        for g in group:
            sub_df_ref = df_100[df_100['group']==gref]
            sub_df = dfnow[dfnow['group']==g]
             
            #calculate inverse jaccard index
            #first find how many unique cells in overlapped set
            overlap_name = len(pd.merge(sub_df_ref,sub_df,on = ['dirname'],how='inner'))
            #second find how many unique cells in both set
            both_name = len(pd.merge(sub_df_ref,sub_df,on = ['dirname'],how='outer'))
            
            TINY = 0.00001
            print(float(overlap_name)/both_name)
            sim_cost_matrix[gref,g] = float(both_name)/(overlap_name+TINY)
            
        
        

    row_ind, col_ind = linear_sum_assignment(sim_cost_matrix)
    leftover = np.setdiff1d(np.arange(len(group)),col_ind)
    if leftover:
        leftover_new = len(group_ref)+np.arange(1,len(leftover)+1)-1
    
    
    
    group_new =[];
    for idx in range(len(dfnow)):
            flag = False
            for j in range(len(col_ind)):
                if dfnow.iloc[idx,-1] == col_ind[j]:
                    group_new.append(row_ind[j])
                    flag = True
                    continue
            if flag == False:
                    for k in range(len(leftover)):
                        if dfnow.iloc[idx,-1] == leftover[k]:
                            group_new.append(leftover_new[k])
                            continue
    
    
    
    dfnow['group_new'] = group_new
    exec('df_{}=dfnow'.format(i))
    sns.lmplot(data=dfnow,x='xumap',y='yumap',hue='group_new',scatter=True,fit_reg=False,scatter_kws={"s": 10})
    plt.xlim([-10,10])
    plt.ylim([-10,10]) 
    dfnow.to_csv(csvs_dirname+'group_new_{}.csv'.format(i))
    #plt.savefig(csvs_dirname+'df_{}.svg'.format(i))   


    

























