#this script decodes 100 element barcode of a cell crop into a synthetic image

import torch
import torchvision
import torchvision.utils
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import sys
from Latent_Z_100_DatasetLIVE_VAE import Latent_Z_100_DatasetLIVE_VAE
from ToTensorLatent_Z_100_VAE import ToTensorLatent_Z_100_VAE
import argparse


global args
parser = argparse.ArgumentParser(description="texture feature decoding algorithm")
parser.add_argument("-d", "--data_path", dest="data_path", help="enter the directory of the csv file with barcodes for decoding")
parser.add_argument("-o", "--out_path", dest="out_path", help="enter the directory and file name where decoded images will be saved (.png)")
parser.add_argument("-v", "--num_var", dest="num_var", type=int, help="enter the number of features being changed (number of rows)")
parser.add_argument("-s", "--num_std", dest="num_std", type=int, help="enter contribution of the KLD loss")
parser.add_argument("-w", "--weights_path", dest="weights_path", help="enter the weights being used for the predictor")

args = parser.parse_args()



data_path = args.data_path
out_path = args.out_path
num_var = args.num_var
num_std = args.num_std
weights_path = args.weights_path



#transform = transforms.Compose([Invert(),ToTensor()])
trainset =Latent_Z_100_DatasetLIVE_VAE(data_path,transform = ToTensorLatent_Z_100_VAE())
#no need to shuffle
trainloader = torch.utils.data.DataLoader(trainset,batch_size=num_std*num_var,shuffle=False,num_workers=2)

#setup cuda device for running this on GPU
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
print(device)

#utility functions
def to_np(x):
    return x.data.cpu().numpy()

#show some images
#Define the networks

#P_net is the decoder
class P_net(nn.Module):
    def __init__(self,N,z_dim,batch_num):
        super(P_net,self).__init__()
        #no need for up sampling layer, use F.interpolate instead
        self.fc1 = nn.Linear(z_dim,1000)
        self.fc1_bn = nn.BatchNorm1d(1000)
        self.fc2 = nn.Linear(1000,1000)
        self.fc1_bn = nn.BatchNorm1d(1000)
        self.fc3 = nn.Linear(1000,N*4*3*3)
        self.fc3_bn = nn.BatchNorm1d(N*4*3*3)
        
        self.conv0 = nn.ConvTranspose2d(4*N,N*4,3)
        self.conv0_bn = nn.BatchNorm2d(N*4)
        self.conv1 = nn.ConvTranspose2d(4*N,N*2,5,padding = 2)
        self.conv1_bn = nn.BatchNorm2d(N*2)
        self.conv2 = nn.ConvTranspose2d(N*2,N,5,padding = 2) #to keep output size the same as input, set padding equal to
                                                             #(kernel_size - 1 / 2)
        self.conv2_bn = nn.BatchNorm2d(N)
        self.conv3 = nn.ConvTranspose2d(N,1,5,padding = 2)
        
        self.batch_num = batch_num
        self.N         = N
        self.latent   = latent_z
        
    def reparameterize(self, mu, logvar):
        std = torch.exp(0.5*logvar)
        eps = torch.randn_like(std)
        
        return mu + eps*std
    
    def forward(self,latent_z): #use randomized relu (rrelu) or else this won't work!
        
        #z = self.reparameterize(mu, logvar)
        #x = self.reparameterize(mu, logvar)
        x = latent_z
        
        x = F.leaky_relu(self.fc1_bn(self.fc1(x))) #1000
        x = F.leaky_relu(self.fc1_bn(self.fc2(x))) #1000
        x = F.leaky_relu(self.fc3_bn(self.fc3(x))) #N*4*3*3
        x = x.view(-1,self.N*4,3,3) #N*4 3x3
    
        x = F.interpolate(x,scale_factor = 2) #N*4 6 x 6
        x = F.leaky_relu(self.conv0_bn(self.conv0(x)))  #N*4  8 x 8
        x = F.leaky_relu(self.conv1_bn(self.conv1(x)))  #N*2  8 x 8
        x = F.interpolate(x,scale_factor = 2) #N*2 16 x 16
        x = F.leaky_relu(self.conv2_bn(self.conv2(x))) #N 16 x 16
        x = F.interpolate(x,scale_factor = 2)    #N 32 x 32
        x = F.leaky_relu(self.conv3(x)) #1  32x32
        x = F.interpolate(x,scale_factor = 2)    #N 64 x 64
        
        return x
    
    
data_iter = iter(trainloader)
latent_z = data_iter.next()
latent_z = latent_z.to(device)
latent_z = latent_z.float()
#Create an instance for each of the encoder
N_enc = 100
z_dim = 100
N_dis = 1000
P = P_net(N_enc,z_dim,num_std*num_var).cuda() #.cuda() is equivalent to Q.to(device)
#load the trained weights and biases
P.load_state_dict(torch.load(weights_path))

P.eval()


images = P(latent_z)
torchvision.utils.save_image(images,out_path,nrow = num_std)

