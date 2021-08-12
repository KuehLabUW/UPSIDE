# -*- coding: utf-8 -*-
"""
Created on Tue Jun  1 15:35:12 2021

@author: samng
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np





def getVector(df,sub_df):
    #get the individual vector from a cell
    
    xnow = sub_df['xumap']
    ynow = sub_df['yumap']
    p_cell = sub_df['pcell']
    pos = sub_df['pos']
    t = sub_df['t']
    trial = sub_df['trial']
    sub_df_target  = df[(df['cell']==p_cell) & (df['pos']==pos) & (df['t']==t+1) & (df['trial']==trial)]
    if len(sub_df_target) > 0:
        xnext = sub_df_target['xumap']
        ynext = sub_df_target['yumap']
        return [xnext-xnow,ynext-ynow]
    else:
        return ['nan','nan']

df = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/cluster2_tracked_dist.csv')
#eliminate untracked cells
df = df[(df['pcell']>0) & (df['pos']<6)]
#reassign the clusters
newC = [];
for i in range(len(df)):
    subdf = df.iloc[i,:]
    if subdf['cluster'] == 1:
        newC.append(1)
    elif subdf['cluster'] == 2:
        newC.append(8)
    elif subdf['cluster'] == 3:
        newC.append(2)
    elif subdf['cluster'] == 4:
        newC.append(7)
    elif subdf['cluster'] == 5:
        newC.append(3)
    elif subdf['cluster'] == 6:
        newC.append(4)
    elif subdf['cluster'] == 7:
        newC.append(5)
    elif subdf['cluster'] == 8:
        newC.append(6)
df['newC'] = newC
#delinate the mesh data
Npoints = 20
max_xumap = np.max(df['xumap'])
max_yumap = np.max(df['yumap'])
min_xumap = np.min(df['xumap'])
min_yumap = np.min(df['yumap'])
spaceX = (max_xumap+1 - min_xumap-1)/float(Npoints)
spaceY = (max_yumap+1 - min_yumap-1)/float(Npoints)
xinterval = np.arange(min_xumap-1,max_xumap+1,spaceX)
yinterval = np.arange(min_yumap-1,max_yumap+1,spaceY)

[Xgrid,Ygrid] = np.meshgrid(xinterval,yinterval)
Ugrid = np.zeros([len(Xgrid),len(Xgrid[0])])
Vgrid = np.zeros([len(Ygrid),len(Ygrid[0])])
Agrid = np.zeros([len(Ygrid),len(Ygrid[0])])
for i in range(len(Xgrid)):
    for j in range(len(Xgrid[0])):
        #find all cells living in such grid
        xcenter = Xgrid[i,j]
        ycenter = Ygrid[i,j]
        xleft = xcenter - spaceX/2.00
        xright = xcenter + spaceX/2.00
        ybottom = ycenter - spaceY/2.00
        ytop = ycenter + spaceY/2.00
        df_grid = df[(df['xumap'] > xleft)&(df['xumap'] < xright)&(df['yumap'] > ybottom)&(df['yumap'] < ytop)]
        
        if len(df_grid) == 0:
            #print('No')
            #if no live cells, set vector to zero
            Ugrid[i,j] = 0
            Vgrid[i,j] = 0
            Agrid[i,j] = 0
        else:
            #print('Yes')
            #take the mean values of the vector's size
            u_all = [];v_all = [];
            for c in range(len(df_grid)):
                [u,v] = getVector(df,df_grid.iloc[c,:])
                # only add data if partner cell is found
                if (type(u) != str) & (type(v) != str):
                    u_all.append(u.to_list()[0])
                    v_all.append(v.to_list()[0])
                    
            if (len(u_all) > 0) & (len(v_all) > 0):
            #only calculate the mean if a vector is present    
                Ugrid[i,j] = np.mean(u_all)
                Vgrid[i,j] = np.mean(v_all)
                Agrid[i,j] = np.mean(np.abs(v_all))
            else:
                Ugrid[i,j] = 0
                Vgrid[i,j] = 0
                Agrid[i,j] = 0
#%%
#try plotting this as a vector field
sns.lmplot(data=df,x='xumap',y='yumap',hue='cluster',fit_reg=False,scatter_kws={"s": 0.5})                
plt.quiver(Xgrid,Ygrid,Ugrid,Vgrid,headwidth=10)
plt.savefig('/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/vectorfield.pdf')
#plt.scatter(Xgrid,Ygrid,s=Agrid**2,c='black')
#plt.xlim([min_xumap-2,max_xumap+2])
#plt.ylim([min_yumap-2,max_yumap+2])
plt.show()
#plt.quiver(Xgrid,Ygrid,Ugrid,Vgrid)
sns.lmplot(data=df,x='xumap',y='yumap',hue='cluster',fit_reg=False,scatter_kws={"s": 0.5})
plt.scatter(Xgrid,Ygrid,s=Agrid**5,c='black')
plt.show()
