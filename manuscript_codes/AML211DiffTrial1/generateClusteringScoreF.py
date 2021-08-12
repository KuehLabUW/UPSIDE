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
# this function takes in a dataframe with type, x_umap, and y_umap fields along with the number of neighors
# and then returns the neighbor purity score for each type
def generateNeighboringScore(dataframe,n_neighbor):
    
    df = dataframe
    #first get x and y umap values from dataframe
    x_umap = np.reshape(df.iloc[:,1].values,(len(df),1))
    y_umap = np.reshape(df.iloc[:,2].values,(len(df),1))

    #concantenate the two x and y coordinate
    cell_loc = np.concatenate((x_umap,y_umap),1)
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

# inititalize dataframe to store neighbor purity result
df_COMPCA = pd.DataFrame(fractionMask, columns = ['fractionMask'])
df_COMVAE = pd.DataFrame(fractionMask, columns = ['fractionMask'])
df_BOTH = pd.DataFrame(fractionMask, columns = ['fractionMask'])

#first get the PCA VAE textures and mask on its own first
print ('analyzing single latent z....')
df_PCAonly_mask = pd.concat([df_label.type,df_label.x_umapPCA,df_label.y_umapPCA],1);
result_PCAonly_mask = generateNeighboringScore(df_PCAonly_mask,n_neighbor)

df_VAEonly_mask = pd.concat([df_label.type,df_label.x_umap,df_label.y_umap],1);
result_VAEonly_mask = generateNeighboringScore(df_VAEonly_mask,n_neighbor)

df_PCAonly_texture = pd.concat([df_label.type,df_label.x_umap_tPCA,df_label.y_umap_tPCA],1);
result_PCAonly_texture = generateNeighboringScore(df_PCAonly_texture,n_neighbor)

df_VAEonly_texture = pd.concat([df_label.type,df_label.x_umap_t,df_label.y_umap_t],1);
result_VAEonly_texture = generateNeighboringScore(df_VAEonly_texture,n_neighbor)
print ('done!')

# now for each combination, loop through each f and add the result into prebuilt df
print('performing COM PCA.....')
AML_Stem = [];
AML_Blast = [];
Kasumi_1 = [];
Macrophage = [];
for f in fractionMask:
    arrayCOM_PCA = np.concatenate((arrayPCA_m*f,arrayPCA_t*(1-f)),1)
    umap_resultsCOM_PCA = reducer.fit_transform(arrayCOM_PCA)
    df_new = pd.DataFrame(umap_resultsCOM_PCA,columns=['x_umap','y_umap'])
    df_sub = pd.concat([df_label.type,df_new],1)
    result = generateNeighboringScore(df_sub,n_neighbor)
    AML_Stem.append(result['AML_Stem'])
    AML_Blast.append(result['AML_Blast'])
    Kasumi_1.append(result['Kasumi_1'])
    Macrophage.append(result['Macrophage'])
df_COMPCA['AML_Stem'] = AML_Stem
df_COMPCA['AML_Blast'] = AML_Blast
df_COMPCA['Kasumi_1'] = Kasumi_1
df_COMPCA['Macrophage'] = Macrophage

print('performing COM VAE.....')
AML_Stem = [];
AML_Blast = [];
Kasumi_1 = [];
Macrophage = [];
for f in fractionMask:
    arrayCOM_VAE = np.concatenate((arrayVAE_m*f,arrayVAE_t*(1-f)),1)
    umap_resultsCOM_VAE = reducer.fit_transform(arrayCOM_VAE)
    df_new = pd.DataFrame(umap_resultsCOM_VAE,columns=['x_umap','y_umap'])
    df_sub = pd.concat([df_label.type,df_new],1)
    result = generateNeighboringScore(df_sub,n_neighbor)
    AML_Stem.append(result['AML_Stem'])
    AML_Blast.append(result['AML_Blast'])
    Kasumi_1.append(result['Kasumi_1'])
    Macrophage.append(result['Macrophage'])
df_COMVAE['AML_Stem'] = AML_Stem
df_COMVAE['AML_Blast'] = AML_Blast
df_COMVAE['Kasumi_1'] = Kasumi_1
df_COMVAE['Macrophage'] = Macrophage

print('performing BOTH.....')
AML_Stem = [];
AML_Blast = [];
Kasumi_1 = [];
Macrophage = [];
for f in fractionMask:
    arrayBOTH = np.concatenate((arrayPCA_m*f,arrayVAE_t*(1-f)),1)
    umap_resultsBOTH = reducer.fit_transform(arrayBOTH)
    df_new = pd.DataFrame(umap_resultsBOTH,columns=['x_umap','y_umap'])
    df_sub = pd.concat([df_label.type,df_new],1)
    result = generateNeighboringScore(df_sub,n_neighbor)
    AML_Stem.append(result['AML_Stem'])
    AML_Blast.append(result['AML_Blast'])
    Kasumi_1.append(result['Kasumi_1'])
    Macrophage.append(result['Macrophage'])
df_BOTH['AML_Stem'] = AML_Stem
df_BOTH['AML_Blast'] = AML_Blast
df_BOTH['Kasumi_1'] = Kasumi_1
df_BOTH['Macrophage'] = Macrophage

#convert single latent z into df
df_PCAonly_mask = pd.DataFrame.from_dict(result_PCAonly_mask,orient = 'index')
df_VAEonly_mask = pd.DataFrame.from_dict(result_VAEonly_mask,orient = 'index')
df_PCAonly_texture = pd.DataFrame.from_dict(result_PCAonly_texture, orient = 'index')
df_VAEonly_texture = pd.DataFrame.from_dict(result_VAEonly_texture,orient = 'index')


df_PCAonly_mask.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/PCAonly_mask.csv')
df_VAEonly_mask.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/VAEonly_mask.csv')
df_PCAonly_texture.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/PCAonly_texture.csv')
df_VAEonly_texture.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/VAEonly_texture.csv')
df_COMPCA.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/COMPCA.csv')
df_COMVAE.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/COMVAE.csv')
df_BOTH.to_csv('/media/phnguyen/Data2/Imaging/CellMorph/data/CellTypesShapes/csvs/BOTH.csv')    








    
