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
import matplotlib.pyplot as plt
# this function takes in a dataframe with type, x_umap, and y_umap fields along with the number of neighors
# and then returns the neighbor purity score for each type
def generateNeighboringScore(dataframe,n_neighbor):
    
    df = dataframe
    #first get x and y umap values from dataframe
    #x_umap = np.reshape(df.iloc[:,1].values,(len(df),1))
    #y_umap = np.reshape(df.iloc[:,2].values,(len(df),1))

    #concantenate the two x and y coordinate
    cell_loc = df_sub.iloc[:,-200:].values
    #calculate the distance matrix for all the cells in df
    dist = distance_matrix(cell_loc,cell_loc)

    n = n_neighbor
    #this function returns the indices of sorted values lowest to highest
    sorted_ind = np.argsort(dist,axis= 1)
    #find the first n neighbor that is nearest to each point
    first_n_smallest = sorted_ind[:,1:1+n]
    #grab the cell types of the neighbors
    type_array = df.type.values
    first_n_name = type_array[first_n_smallest]
    
    #get the cell type the neighbor distance is being compared to 
    og_type = type_array[sorted_ind[:,0]]
    og_type = np.resize(og_type,[len(og_type),1])
    
    #see how many matched. Add them up and caluclate fraction
    compared = first_n_name ==og_type
    sum_compared = np.sum(compared,1)
    ratio_compared = sum_compared/n
    
    #get the list of all unique cell type
    type_list = df.type.unique()
    
    #loop through all cell type, get the mean neighbor purity and put it in a list
    mean_neighbor = {};
    for name in type_list:
        ind = np.where(og_type == name)[0]
        mean_ind = np.mean(ratio_compared[ind])
        if name == 'Kasumi-1':
            name = 'Kasumi_1'
        mean_neighbor[name] = mean_ind
        
    return mean_neighbor

######################## Main Script #####################
df_label = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/CombinedDirTypeChosen2.csv')


model_namelist = ['VAE','PCA','AutoEncoder','1XAAE','4XAAE','GAN']

# generate data one model at a time
for model in model_namelist:
    df_t = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/style_CellTypes020420_{}_TextureChosen.csv'.format(model))
    array_t = df_t.values
    
    df_m = pd.read_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/style_CellTypes020420_{}_MaskChosen.csv'.format(model))
    array_m = df_m.values

    fraction = np.arange(0,1.1,0.01)
    
    n_neighbor =  10
    
    trial = 2
    
    df_COM = pd.DataFrame(fraction, columns = ['fraction'])

    print('performing COM {}.....'.format(model))
    AML_Stem = [];
    Kasumi_1 = [];
    Macrophage = [];
    P2C2 = [];


    for f in fraction:
        arrayCOM = np.concatenate((array_m*f,array_t*(1-f)),1)
        df_new = pd.DataFrame(arrayCOM)
        df_sub = pd.concat([df_label,df_new],1)
    
        if trial == 1:
            df_sub = df_sub[df_sub.trial == 1]
        elif trial == 2:
            df_sub = df_sub[df_sub.trial == 2]
         
        result = generateNeighboringScore(df_sub,n_neighbor)
        AML_Stem.append(result[4])
        Kasumi_1.append(result[2])
        Macrophage.append(result[1])
        P2C2.append(result[3])
        
    df_COM['AML_Stem'] = AML_Stem
    df_COM['Kasumi_1'] = Kasumi_1
    df_COM['Macrophage'] = Macrophage
    df_COM['P2C2'] = P2C2
    
    df_COM.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypes020420/csvs/COM_Chosen_{}_{}.csv'.format(model,trial))













