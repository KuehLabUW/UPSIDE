#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan  7 09:57:22 2020

@author: phnguyen
"""

import pandas as pd
import os
from scipy.spatial import distance_matrix
from sklearn.neighbors import kneighbors_graph
import umap
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import community
import networkx as nx
from sklearn.cluster import DBSCAN
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/'
os.chdir(csvs_dirname)
df = pd.read_csv('ClusteredTypesChosen.csv')

for i in range(6):
    exec("df{} = df[df['group']=={}]".format(i,i))
    
base = range(6)
c_1 = [];
c_2 = [];
c_3 = [];
c_4 = [];
c_5 = [];
for i in range(6):
    exec('c_1.append(len(df{}[df{}.type == 1]))'.format(i,i))
    exec('c_2.append(len(df{}[df{}.type == 2]))'.format(i,i))
    exec('c_3.append(len(df{}[df{}.type == 3]))'.format(i,i))
    exec('c_4.append(len(df{}[df{}.type == 4]))'.format(i,i))
    exec('c_5.append(len(df{}[df{}.type == 5]))'.format(i,i))
    
plt.bar(base,c_1)
plt.bar(base,c_2,bottom = c_1)
plt.bar(base,c_3,bottom = np.add(c_2,c_1).tolist())
plt.bar(base,c_4,bottom = np.add(np.add(c_2,c_1).tolist(),c_3).tolist())
plt.bar(base,c_5,bottom = np.add(np.add(np.add(c_2,c_1).tolist(),c_3).tolist(),c_4).tolist())
plt.ylim(0,1900)
plt.legend(['Mac','K-1','P2C2','Stem','Blast'])

    

