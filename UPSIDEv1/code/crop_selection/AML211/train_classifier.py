# -*- coding: utf-8 -*-
import sys
import torch
import torchvision
import torchvision.transforms as transforms
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import torch.distributions as dis
import matplotlib.pyplot as plt
import numpy as np
from torch.utils.data.sampler import SubsetRandomSampler
from AML211AnnotatedDataset import AML211AnnotatedDataset
from ToTensorLiveDead import ToTensorLiveDead


from Logger import Logger



data_path = sys.argv[1] # path of csv file with training data
weights_path = sys.argv[2] # path where learned weights will be saved
learning_rate = sys.argv[3] # learning rate
step_num = sys.argv[4] # number of iteration step


#split data into training and test batches
validation_split = .1
random_seed= 42
dataset = AML211AnnotatedDataset(data_path,transform = ToTensorLiveDead())
# generate data indices for training and testing. shuffle data before applying indices
dataset_size = len(dataset)  #total of 109750 images
indices = list(range(dataset_size))
split = int(np.floor(validation_split * dataset_size))
np.random.seed(random_seed)
np.random.shuffle(indices)
train_indices, val_indices = indices[split:], indices[:split] #98775 for train and 10975 for validation
#apply indices
train_sampler = SubsetRandomSampler(train_indices)
valid_sampler = SubsetRandomSampler(val_indices)

trainloader = torch.utils.data.DataLoader(dataset, batch_size=60, 
                                           sampler=train_sampler,num_workers = 2)
validationloader = torch.utils.data.DataLoader(dataset, batch_size=60,
                                                sampler=valid_sampler, num_workers = 2)

#setup cuda device for running this on GPU
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
print(device)

#create logger
logger = Logger('./logs')

#utility functions
def imshow(img):
    img = img/0.2 + 0.5 # denormalize
    npimg = img.numpy() # convert image into numpy format
    plt.imshow(np.transpose(npimg, (1, 2, 0)))
    # transpose is needed because when turned into numpy, the data size is still (1,28,28) as (x,y,z)
    # needs to to turn the shape back into (28,28,1) as (x,y,z) for imshow to work. np.transpose(image,(1,2,0)) means the second
    # dimension (1) will be the first dimension, and third dimension (2) will be 2nd dimension, and the first dimension will be 
    # third dimension
    plt.show()
def to_np(x):
    return x.data.cpu().numpy()
def sampleMixedGauss(mean_set,variance_set,weight_set,batch_size,z_dim):
    #convert data to tensors
    mean_set = torch.FloatTensor(mean_set)
    variance_set = torch.FloatTensor(variance_set)
    weight_set = torch.FloatTensor(weight_set)
    #define categorical based on the weights for each gaussian
    categorical = dis.categorical.Categorical(weight_set)
    Gauss_total = torch.zeros(0)
    for batch in range(batch_size):
        #define an empty vector for z_dim
        Gauss = torch.zeros(z_dim)
        for i in range(z_dim):
            #first decide which gaussian to sample from
            gauss_ith = categorical.sample()
            #then sample a value from that gaussian
            gauss = dis.normal.Normal(mean_set[gauss_ith],variance_set[gauss_ith])
            gauss = gauss.sample()
            Gauss[i] = gauss            
        Gauss_total = torch.cat((Gauss_total,Gauss),0)   
    return Gauss_total.view(batch_size,-1)
#show some images
TestViewIm = False
if TestViewIm:
    dataiter = iter(trainloader)
    images, labels = dataiter.next()
    #show images
    imshow(torchvision.utils.make_grid(images)) #torchvision.utils.make_grid puts many pictures in a grid
    
#Define the networks

#Q_net is the encoder
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

Q = Q_net(N_enc,z_dim,60).cuda() #.cuda() is equivalent to Q.to(device)



#Create optimizer
#set learning rate
gen_lr = learning_rate  #learning rate for encode/decode phase


#encode/decode phase
optimQ_enc = optim.Adam(Q.parameters(),lr=gen_lr)


#train network
total_step = step_num
data_iter = iter(trainloader)
val_data_iter = iter(validationloader)
for step in range(total_step):
    #reset data iteration once the entire number of batches has been reach
    batch_number = len(trainloader)
    if (step+1) % batch_number == 0:
        data_iter = iter(trainloader)
        print(step+1)
    
    val_batch_number = len(validationloader)
    if (step+1) % val_batch_number == 0:
        val_data_iter = iter(validationloader)
        
    
    ####training phase
    ###################
    
    Q.train() # set Q into training mode
    
    
    
    #try adding noise to the weights
    #with torch.no_grad():
    #    for param in Q.parameters():
    #        noise = torch.randn(param.size())
    #        noise = noise.to(device)
    #        param.add_(noise * 0.01)
            
    optimQ_enc.zero_grad()
    #extract data
    imagesAnno, status = data_iter.next()
    imagesAnno = imagesAnno.to(device)
    status = status.to(device)
    status = status.float()
    
    
    z_sample_cat = Q(imagesAnno)     #encode image
    
    #define loss function
    TINY = 1e-15
    recon_loss = F.binary_cross_entropy(z_sample_cat,status)
    recon_loss.backward()
    #update weights and biases
    optimQ_enc.step()
    
    ####validation phase
    ####################
    
    Q.eval() # set Q into evaluation mode
    
    optimQ_enc.zero_grad()
    
    #extract data
    images_val, status_val = val_data_iter.next()
    
    images_val = images_val.to(device)
    status_val = status_val.to(device)
    status_val = status_val.float()
    
    z_sample_cat_val = Q(images_val)     #encode image
    
    #define loss function
    valid_loss = F.binary_cross_entropy(z_sample_cat_val,status_val)
    
    
    ########################
    if (step+1) % 100 == 0:
        # print statistics
        print('batchloss:')
        print(recon_loss.item())
        print('validloss:')
        print(valid_loss.item())
        
        
        #logging to tensorboard
        info = {'batchloss':recon_loss.item(),'validloss':valid_loss.item()}
        logger.scalar_summary('batchloss',recon_loss.item(),step+1)
        logger.scalar_summary('validloss',valid_loss.item(),step+1)
        logger.histo_summary('latent_dist_cat',to_np(z_sample_cat_val),step+1)
        
        torch.save(Q.state_dict(),weights_path + 'AML211LiveDeadClassifier_LargeMask{}.pt'.format(step))  

print('finished training!')
#save the weights and bias of the encoder:
  