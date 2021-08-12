from __future__ import print_function, division

import pandas as pd
from skimage import io, transform
from torch.utils.data import Dataset, DataLoader
import numpy as np

#dataset will be a dict {'image': image,'pos': pos
#                        'time': time, 'obj':object}
class CellTypesDataset_Texture(Dataset):
    """AML261 cell pic dataset."""
    def __init__(self,csv_file,transform = None):
        self.data_frame = pd.read_csv(csv_file)
        self.transform = transform
    def __len__(self):
        return len(self.data_frame)
    def __getitem__(self, idx):
        image_name = self.data_frame.iloc[idx,0]
        image_name = image_name[:-4] + '_texture.TIF'
        image = io.imread(image_name)
        image = np.reshape(image,(64,64,1)) # reshape to standard format (H,W,C)
        image = image.astype(float)
        position = self.data_frame.iloc[idx,1]
        timepoint = self.data_frame.iloc[idx,2]
        obj = self.data_frame.iloc[idx,3]
        trial = self.data_frame.iloc[idx,6]
        sample =[image,position,timepoint,obj,trial]
        if self.transform:
            sample = self.transform(sample)
        return sample
    
    
    
    
    
    
