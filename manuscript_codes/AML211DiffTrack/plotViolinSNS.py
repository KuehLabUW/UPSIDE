#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 26 17:02:37 2020

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
#import random
#Get raw latent z data
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffALL/csvs/'
os.chdir(csvs_dirname)
df = pd.read_csv('CombinedUMAPDirFluoClusterZC.csv')
condition = 2
trial = 3

subdf = df[(df.condition == condition) & (df.trial == trial)]
sns.violinplot(x=subdf.cluster, y=np.log10(1+subdf.PE_corr))
plt.show()
sns.violinplot(x=subdf.cluster, y=np.log10(1+subdf.APC_corr))
