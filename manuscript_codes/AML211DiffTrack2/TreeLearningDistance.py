#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar  3 14:38:57 2020

@author: phnguyen
"""

import pandas as pd
import os
from scipy.spatial import distance_matrix
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import networkx as nx
import xgboost as xgb
import shap
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
#import random
#Get raw latent z data
csvs_dirname = '/media/phnguyen/Data2/Imaging/CellMorph/data/AML211DiffTrack/csvs/'
os.chdir(csvs_dirname)
df = pd.read_csv('CombinedUMAPDirFluoClusterTCdist.csv')
dfshort = pd.read_csv('CombinedUMAPDirFluoClusterTCdistShort.csv')

dataset = 0;

if dataset == 1:
    data = df[df['distance'] != 0];
else:
    data = dfshort[dfshort['distance'] != 0];

# Extract data for tree regression    
F, dist = data.iloc[:,17:],data.iloc[:,16]
# convert to xgboost format
data_dmatrix = xgb.DMatrix(data=F,label=dist/np.max(dist))
# split dataset
X_train, X_test, y_train, y_test = train_test_split(F, dist/np.max(dist), test_size=0.2, random_state=123)
# create model object
xg_reg = xgb.XGBRegressor(objective ='reg:logistic', colsample_bytree = 0.3, learning_rate = 0.5,
                max_depth = 8, alpha = 40, n_estimators = 10)
# train model
xg_reg.fit(X_train,y_train)

# predict data and calculate errors
preds = xg_reg.predict(X_test)
rmse = np.sqrt(mean_squared_error(y_test, preds))
print("RMSE: %f" % (rmse))

