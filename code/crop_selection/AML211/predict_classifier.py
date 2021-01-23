##################################################################
#%% This script classifies a cell crop brightfield image as live or dead
import torch
import torchvision
import torchvision.transforms as transforms
import torch.nn as nn
import torch.nn.functional as F
import sys
import matplotlib.pyplot as plt
import numpy as np
import csv

from AML211Dataset import AML211Dataset
from ToTensor import ToTensor




tiff_data_path = sys.argv[1] # path of csv file containing to-be-predicted cells
data_path = sys.argv[2]      # main path of the dataset
weight_data_path = sys.argv[3] # path to to the trained weights and biases
output_data_path = sys.argv[4] # path of the output file

trainset = AML211Dataset(tiff_data_path,transform = ToTensor())
#no need to shuffle
trainloader = torch.utils.data.DataLoader(trainset,batch_size=100,shuffle=False,num_workers=2)

#setup cuda device for running this on GPU
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
print(device)

#utility functions
def imshow(img):
    #img = img/0.2 + 0.5 # denormalize
    npimg = img.numpy() # convert image into numpy format
    plt.imshow(np.transpose(npimg, (1, 2, 0)))
    # transpose is needed because when turned into numpy, the data size is still (1,28,28) as (x,y,z)
    # needs to to turn the shape back into (28,28,1) as (x,y,z) for imshow to work. np.transpose(image,(1,2,0)) means the second
    # dimension (1) will be the first dimension, and third dimension (2) will be 2nd dimension, and the first dimension will be 
    # third dimension
    plt.show()
def to_np(x):
    return x.data.cpu().numpy()
def isnan(x):
    return x!=x
def write_csv(datanum,total_z_data,total_root_data):
    with open(data_path + 'NNData/total_z_data{}.csv'.format(datanum), mode='w') as data:
        data_writer = csv.writer(data, delimiter=',')
        data_writer.writerows(total_z_data)
    with open(data_path + 'NNData/total_root_data{}.csv'.format(datanum), mode='w') as data:
        data_writer = csv.writer(data, delimiter=',')
        data_writer.writerows(total_root_data)


#Define the networks

#Q_net is the encoder
class Q_net(nn.Module):
    def __init__(self,N,z_dim_cat,batch_num):
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
        
        
        self.fc3_cat = nn.Linear(1000,z_dim_cat)
        
        #self.fc4_semi = nn.Linear(z_dim_gauss,1)
        
        
        self.pool  = nn.MaxPool2d(2, 2)
        self.batch_num = batch_num
        self.N = N


    def forward(self,x): #use randomized relu (rrelu) or else this won't work!
        x = self.pool(F.rrelu(self.conv1_bn(self.conv1(x)))) #N 32 x 32
        x = self.pool(F.rrelu(self.conv2_bn(self.conv2(x)))) #2*N 16 x 16
        x = self.pool(F.rrelu(self.conv3_bn(self.conv3(x)))) #4*N 8 x 8
        x = self.pool(F.rrelu(self.conv4_bn(self.conv4(x)))) #4*N 3 x 3
        x = x.view(self.batch_num,-1)  #straighten the images
        
        x = F.rrelu(self.fc1_bn(self.fc1(x))) # 1000
        x = F.dropout(x,p=0.25,training=self.training)
        x = F.rrelu(self.fc2_bn(self.fc2(x))) # 1000
        x = F.dropout(x,p=0.25,training=self.training)
        
        x_cat = F.softmax(self.fc3_cat(x))   # z_dim_cat
        
        
        return x_cat
    
    
    
#instantiate each networks
N_enc = 100
z_dim = 2

Q = Q_net(N_enc,z_dim,100).cuda() #.cuda() is equivalent to Q.to(device)

#load the trained weights and biases
Q.load_state_dict(torch.load(weight_data_path))



#Run MNIST images through the network and save the outputs
if len(trainset)%100 != 0:
    total_step = len(trainset)/100 + 1
else:
    total_step = len(trainset)/100
    
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
    images, position, timepoint, obj,trial = data_iter.next()
    images = images.to(device)
    position = position.view(-1,1)
    timepoint = timepoint.view(-1,1)
    obj = obj.view(-1,1)
    trial = trial.view(-1,1)
    root = torch.cat((position,timepoint,obj,trial),1)
    #Set encoder Q into training mode
    Q.eval()
    #pass images through Q
    z_sample_cat = Q(images)     #encode image
    
    #turn z_sample_cat into true onehot
    value, ind = z_sample_cat.max(1)
    for row in range(ind.numel()):
        z_sample_cat[row,:] = (z_sample_cat[row,:]==value[row])
        #check for nan error
        #for element in range(len(z_sample_cat[row,:])):
        #    if isnan(z_sample_cat[row,element])==1:
        #        z_sample_cat[row,element] = z_sample_cat[row,element]*0
        #        print('NaN Eroor!!')
                
            
    
    z_sample = z_sample_cat #concatenate discrete and cont. latent var
    #add to the total tensor
    #total_z = torch.cat((total_z,z_sample),0) #stitching two tensors in the 1st dimension, etc (4,50) and (4,50) will return (8,50)
    #total_labels = torch.cat((total_labels,roots),0)
    #write csv to hard drive
    write_csv(step,to_np(z_sample),to_np(root))

###############################################
#%%
#import csv files
import pandas as pd

if len(trainset)%100 != 0:
    filenum = len(trainset)/100 + 1
else:
    filenum = len(trainset)/100
    
total_z = torch.zeros(0)
total_labels = torch.zeros(0)
for file in range(filenum):
    z_df = pd.read_csv(data_path + "NNData/total_z_data{}.csv".format(file),header=None)
    z_df = z_df.values.tolist()
    z_df = torch.FloatTensor(z_df)
    
    labels_df = pd.read_csv(data_path + "NNData/total_root_data{}.csv".format(file),header=None)
    labels_df = labels_df.values.tolist()
    labels_df = torch.FloatTensor(labels_df)
    
    total_z = torch.cat((total_z,z_df),0)
    total_labels = torch.cat((total_labels,labels_df),0)

#turn tensors back into array   
total_z = to_np(total_z)
total_labels = to_np(total_labels)

#make a dataframe with raw dir and raw z_dim
dir_df = pd.read_csv(data_path) #get the directory file
dirname = list(dir_df['dirname'])
        
live =  total_z[:,0]             #get z_data property
dead =  total_z[:,1]


#save into dataframe
z_data = [[x1,x2,x3,x4,x5,x6,x7] for x1,x2,x3,x4,x5,x6,x7 in zip(dirname,live,dead,total_labels[:,0],total_labels[:,1],total_labels[:,2],total_labels[:,3])]
df = pd.DataFrame(z_data,columns = ['dirname','live','dead','pos','t','cell','trial']) #This creates data object with 3 columns labeled as followed

##############################################
#%%
df_live = df[df['live'] == 1]
df_live.to_csv(output_data_path + 'LIVE.csv')
df_dead = df[df['dead'] == 1]
df_dead.to_csv(output_data_path + 'DEAD.csv')