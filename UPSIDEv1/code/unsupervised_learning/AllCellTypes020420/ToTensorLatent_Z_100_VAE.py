import torch
import numpy as np
class ToTensorLatent_Z_100_VAE(object):
    def __init__(self):
        pass
    def __call__(self, sample):
        latent_z  = sample 
        # swap color axis because
        # numpy image: H x W x C
        # torch image: C X H X W
         
        new_sample = torch.from_numpy(latent_z)
        
        return new_sample