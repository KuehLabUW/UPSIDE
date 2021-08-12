import torch
import numpy as np
class ToTensorLiveDead(object):
    def __init__(self):
        pass
    def __call__(self, sample):
        image, status = sample[0], sample[1]
        # swap color axis because
        # numpy image: H x W x C
        # torch image: C X H X W
        image = image.transpose((2, 0, 1))
        new_sample = [torch.from_numpy(image),torch.from_numpy(status)]
                      
        return new_sample