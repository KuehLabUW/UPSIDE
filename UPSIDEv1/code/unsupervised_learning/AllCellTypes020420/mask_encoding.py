#This script encodes a cell's texture image crop into a barcode of 100
#It outputs 2 csv files, one contains all the barcodes for the cells
#and the other contains their identifying information like, position,time,ID,
#and trial.
#batch size is hard coded to 100, change if neccessary
#visualization can be done through umap or tsne

#%% save raw data into a directory called 'NNData'
import torch
#import torchvision.utils.save_image as save_image
import torch.nn as nn
import torch.nn.functional as F
import sys
from CellTypesDataset_Mask import CellTypesDataset_Mask
from ToTensorLIVE import ToTensorLIVE
import argparse

import csv

global args
parser = argparse.ArgumentParser(description="mask feature encoding algorithm")
parser.add_argument("-d", "--data_path", dest="data_path", help="enter the directory to the csv file of your cell crop data ")
parser.add_argument("-w", "--weights_path", dest="weights_path", help="enter the directory to the learned weights to be used")
parser.add_argument("-r", "--rawdata_path", dest="rawdata_path", help="enter the directory where all the raw data would be saved")
parser.add_argument("-o", "--output_path", dest="output_path", help="enter the output csv file directory")
args = parser.parse_args()



data_path = args.data_path
rawdata_path = args.rawdata_path
weights_path = args.weights_path
output_path = args.output_path


#transform = transforms.Compose([Invert(),ToTensor()])
trainset = CellTypesDataset_Mask(data_path,transform = ToTensorLIVE())
trainloader = torch.utils.data.DataLoader(trainset,batch_size=100,shuffle=False,num_workers=2)
#setup cuda device for running this on GPU
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
print(device)

#utility functions
def to_np(x):
    return x.data.cpu().numpy()
def write_csv(datanum,total_z_data,total_root_data):
    with open(rawdata_path + 'total_z_data{}.csv'.format(datanum), mode='w') as data:
        data_writer = csv.writer(data, delimiter=',')
        data_writer.writerows(total_z_data)
    with open(rawdata_path + 'total_root_data{}.csv'.format(datanum), mode='w') as data:
        data_writer = csv.writer(data, delimiter=',')
        data_writer.writerows(total_root_data)

#show some images
#Define the networks

#Q_net is the encoder
class Q_net(nn.Module):
    def __init__(self,N,z_dim,batch_num):
        super(Q_net,self).__init__()
        self.conv1 = nn.Conv2d(1,N,5,padding=2)   #to keep output size the same as input, set padding equal to
                                                             #(kernel_size - 1 / 2)
        self.conv1_bn = nn.BatchNorm2d(N)
        self.conv2 = nn.Conv2d(N,N*2,5,padding=2)
        self.conv2_bn = nn.BatchNorm2d(N*2)
        self.conv3 = nn.Conv2d(N*2,N*4,5,padding=2)
        self.conv3_bn = nn.BatchNorm2d(N*4)
        self.conv4 = nn.Conv2d(N*4,N*4,3)
        self.conv4_bn = nn.BatchNorm2d(N*4)
        
        self.fc1 = nn.Linear(N*4*3*3,1000)
        self.fc1_bn = nn.BatchNorm1d(1000)
        self.fc2 = nn.Linear(1000,1000)
        self.fc2_bn = nn.BatchNorm1d(1000)
        self.fc31 = nn.Linear(1000,z_dim)
        self.fc32 = nn.Linear(1000,z_dim)
        
        
        self.pool  = nn.MaxPool2d(2, 2)
        self.batch_num = batch_num
        self.N = N


    def forward(self,x): #use randomized relu (rrelu) or else this won't work!
        x = self.pool(F.leaky_relu(self.conv1_bn(self.conv1(x)))) #N 32 x 32
        x = self.pool(F.leaky_relu(self.conv2_bn(self.conv2(x)))) #2*N 16 x 16
        x = self.pool(F.leaky_relu(self.conv3_bn(self.conv3(x)))) #4*N 8 x 8
        x = self.pool(F.leaky_relu(self.conv4_bn(self.conv4(x)))) #4*N 3 x 3
        x = x.view(-1,4*self.N*3*3)  #straighten the images
        
        x = F.leaky_relu(self.fc1_bn(self.fc1(x))) # 1000
        x = F.leaky_relu(self.fc2_bn(self.fc2(x))) # 1000
        mean = F.leaky_relu(self.fc31(x)) # mean vector
        std = F.leaky_relu(self.fc32(x)) # mean vector
        
        return mean,std
    
    
#Create an instance for each of the encoder
N_enc = 100
#N_enc = 100
z_dim = 100
N_dis = 1000
Q = Q_net(N_enc,z_dim,100).cuda() #.cuda() is equivalent to Q.to(device)
#load the trained weights and biases
Q.load_state_dict(torch.load(weights_path))


if len(trainset)%100 != 0:    
    total_step = int(len(trainset)/100) + 1
else:
    total_step = int(len(trainset)/100)
    
data_iter = iter(trainloader)
for step in range(total_step):
    print('step')
    print(step)
    print('%%%%%%%%%%%%')
    #remove the following iter reset section since there's no need for it in prediction mode 
    #reset data iteration once the entire number of batches has been reach
    #batch_number = len(trainloader)
    #if (step+1) % batch_number == 0:
    #    data_iter = iter(trainloader)
    #    #print(step)
    images, position, timepoint, obj, trial = data_iter.next()
    images = images.float()
    images = images.to(device)
    position = position.view(-1,1)
    timepoint = timepoint.view(-1,1)
    obj = obj.view(-1,1)
    trial = trial.view(-1,1)
    #obj = obj.int()
    root = torch.cat((position,timepoint,obj,trial),1)
    #Set encoder Q into training mode
    Q.eval()
    #pass images through Q
    z_sample,_ = Q(images)
    #add to the total tensor
    #total_z = torch.cat((total_z,z_sample),0) #stitching two tensors in the 1st dimension, etc (4,50) and (4,50) will return (8,50)
    #total_labels = torch.cat((total_labels,roots),0)
    #write csv to hard drive
    write_csv(step,to_np(z_sample),to_np(root))
#%%
#################
#import csv files
import pandas as pd


filenum = total_step
total_z = torch.zeros(0)
total_labels = torch.zeros(0)
for file in range(filenum):
    z_df = pd.read_csv(rawdata_path + "total_z_data{}.csv".format(file),header=None)
    z_df = z_df.values.tolist()
    z_df = torch.FloatTensor(z_df)
    
    labels_df = pd.read_csv(rawdata_path + "total_root_data{}.csv".format(file),header=None)
    labels_df = labels_df.values.tolist()
    labels_df = torch.FloatTensor(labels_df)
    
    total_z = torch.cat((total_z,z_df),0)
    total_labels = torch.cat((total_labels,labels_df),0)

#turn tensors back into array   
total_z = to_np(total_z)
total_labels = to_np(total_labels)
#%%
#################
with open(output_path + 'style_CellTypes020420_VAE_MaskChosen.csv', mode='w') as data:
        data_writer = csv.writer(data, delimiter=',')
        data_writer.writerows(total_z)
with open(output_path + 'root_CellTypes020420_VAE_MaskChosen.csv', mode='w') as data:
        data_writer = csv.writer(data, delimiter=',')
        data_writer.writerows(total_labels)
