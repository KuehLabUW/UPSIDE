from __future__ import print_function, division

import pandas as pd
from skimage import io, transform
from torch.utils.data import Dataset, DataLoader
import numpy as np

#dataset will be a dict {'image': image,'pos': pos
#                        'time': time, 'obj':object}
class Latent_Z_100_DatasetLIVE_VAE(Dataset):
    """latent dimension scan dataset."""
    def __init__(self,csv_file,transform = None):
        self.data_frame = pd.read_csv(csv_file,header = None)
        self.transform = transform
    def __len__(self):
        return len(self.data_frame)
    def __getitem__(self, idx):
        z = self.data_frame.iloc[idx,:]
        z = z.values
        if self.transform:
            z = self.transform(z)
        return z
    
    
    
    
    
    
