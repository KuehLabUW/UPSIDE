# -*- coding: utf-8 -*-

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import numpy as np
import sys
from CellTypesDataset_Mask import CellTypesDataset_Mask
from ToTensorLIVE import ToTensorLIVE
import argparse

from Logger import Logger

global args
parser = argparse.ArgumentParser(description="mask feature learning algorithm")
parser.add_argument("-d", "--data_path", dest="data_path", help="enter path of the unsupervised learning data")
parser.add_argument("-w", "--weights_path", dest="weights_path", help="enter directory where weights will be saved")
parser.add_argument("-r", "--recon_contribution", dest="recon_contribution", type=float, help="enter contribution of the reconstruction loss")
parser.add_argument("-k", "--KLD_contribution", dest="KLD_contribution", type=float, help="enter contribution of the KLD loss")
parser.add_argument("-l", "--lr", dest="lr", type=float, help="enter learning rate")
parser.add_argument("-s", "--total_step", dest="total_step", type=int, help="enter number of iteration")
args = parser.parse_args()



data_path = args.data_path
weights_path = args.weights_path
recon_contribution = args.recon_contribution
KLD_contribution = args.KLD_contribution
lr = args.lr
total_step = args.total_step




trainset = CellTypesDataset_Mask(data_path,transform = ToTensorLIVE())
trainloader = torch.utils.data.DataLoader(trainset,batch_size=50,shuffle=True,num_workers=2)


#setup cuda device for running this on GPU
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
print(device)

#create logger
logger = Logger('./logs')

#utility functions

def to_np(x):
    return x.data.cpu().numpy()



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


    def forward(self,x): 
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
        
    
    def forward(self,mean,logstd): 
        
	z = torch.randn_like(torch.exp(0.5*logstd)) + mean #std + rand_sampling
        x = torch.randn_like(torch.exp(0.5*logstd)) + mean #std + rand_sampling
        
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
        
        return x,z
    

#instantiate each networks
N_enc = 100
z_dim = 100
N_dis = 1000
Q = Q_net(N_enc,z_dim,50).cuda() #.cuda() is equivalent to Q.to(device)
P = P_net(N_enc,z_dim,50).cuda()




#encode/decode phase
optimQ_enc = optim.Adam(Q.parameters(),lr=lr)
optimP = optim.Adam(P.parameters(),lr=lr)


#train network
data_iter = iter(trainloader)
for step in range(total_step):
    #reset data iteration once the entire number of batches has been reach
    batch_number = len(trainloader)
    if (step+1) % batch_number == 0:
        data_iter = iter(trainloader)
        print('Step: ')
        print(step+1)
    
    #extract data
    images, position, timepoint, obj, trial = data_iter.next()
    # many that's left the pixel value. images.size(0) gives you the number of batches
    images = images.to(device)
    images = images.float()
    
    ####reconstruction phase
    Q.train() # set Q and P network into training mode. It's in this by default but good to explicitly state
    P.train()
    
    optimQ_enc.zero_grad()
    optimP.zero_grad()
    
    mu, std = Q(images)     #encode image
    X_sample,z = P(mu, std)   #decode image
    #define loss function
    TINY = 1e-15
    total_loss = F.mse_loss(X_sample, images)*recon_contribution + KLD_contribution*-0.5 * torch.sum(1 + std - mu.pow(2) - std.exp())
    MSE_loss = F.mse_loss(X_sample, images)
    KLD_loss = -0.5 * torch.sum(1 + std - mu.pow(2) - std.exp())
    #total_loss = BCE*64*64 + 0.002*KLD
    total_loss.backward()
    #update weights and biases
    optimQ_enc.step()
    optimP.step()
    
    
    ########################
    if (step+1) % 1000 == 0:
        # print statistics
        print('recon_loss:')
        print(MSE_loss.item())
        print('KLD_loss:')
        print(KLD_loss.item())
        
        #logging to tensorboard
        info = {'reconloss':MSE_loss.item(),'KLD_loss':KLD_loss.item()}
        for tag,value in info.items():
            logger.scalar_summary(tag,value,step+1)
        logger.histo_summary('laten_dist',to_np(z),step+1)
        #logger.histo_summary('true_dist',to_np(z_real_gauss),step+1)
        
        #log images
        num_im = 5
        img_size = 64
        images_out = images[:num_im,:,:]
        X_sample_out = X_sample[:num_im,:,:]
        #logger.image_summary('INPUT_im',images_out.view(-1,img_size,img_size).cpu().detach().numpy(),step+1)
        logger.image_summary('OUTPUT_im',X_sample_out.view(-1,img_size,img_size).cpu().detach().numpy(),step+1)
        
        torch.save(Q.state_dict(),weights_path + 'Q_VAE_CellTypes__large_LIVE_100z_nodropout_Mask_{}.pt'.format(step+1)) 
        torch.save(P.state_dict(),weights_path + 'P_VAE_CellTypes__large_LIVE_100z_nodropout_Mask_{}.pt'.format(step+1))

print('finished training!')
#save the weights and bias of the encoder:
#torch.save(Q.state_dict(),'VAE_AML211__large_LIVE_100z_nodropout_{}.pt')    
