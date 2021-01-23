import torch
import numpy as np
class ToTensor(object):
    def __init__(self):
        pass
    def __call__(self, sample):
        image, position, timepoint, obj, trial = sample[0], sample[1], sample[2], sample[3], sample[4]
        # swap color axis because
        # numpy image: H x W x C
        # torch image: C X H X W
        image = image.transpose((2, 0, 1))
        
        new_sample = [torch.from_numpy(image),position,
                      timepoint
                      ,obj,trial]
        return new_sample