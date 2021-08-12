from __future__ import print_function, division

import pandas as pd
from skimage import io, transform
from torch.utils.data import Dataset, DataLoader
import numpy as np

#dataset will be a dict {'image': image,'pos': pos
#                        'time': time, 'obj':object}
class AML211Dataset(Dataset):
    """AML261 cell pic dataset."""
    def __init__(self,csv_file,transform = None):
        self.data_frame = pd.read_csv(csv_file)
        self.transform = transform
    def __len__(self):
        return len(self.data_frame)
    def __getitem__(self, idx):
        image_name = self.data_frame.iloc[idx,2]
        image = io.imread(image_name)
        image = np.reshape(image,(64,64,1)) # reshape to standard format (H,W,C)
        position = self.data_frame.iloc[idx,3]
        timepoint = self.data_frame.iloc[idx,4]
        obj = self.data_frame.iloc[idx,5]
        sample =[image,position,timepoint,obj]
        if self.transform:
            sample = self.transform(sample)
        return sample
    
    
    
    
    
    