UPSIDE SOFTWARE USER GUIDE

System Requirements

    • We recommend Linux Ubuntu 16.04.
    • > 10 GB of RAM NVIDIA graphics card. We used NVIDIA Titan X Pascal.
Installation

    • Python version 3.8.6 with conda version 4.8.2
    • CUDA version 9.1 or higher.
    • Pytorch version 1.4.0 or higher.
    • Docker version 19.03.5 or higher.
    • Tensorflow version 1.12.0 or higher for Tensorboard integration in Pytorch. (We used the customized version by https://github.com/yunjey/pytorch-tutorial/tree/master/tutorials/04-utils/tensorboard).
    • MATLAB v9.0 or higher with ictrack software (download and installation instructions: https://github.com/KuehLabUW/ictrack/)
    
Description

This is the user guide on how to run the UPSIDE software that accompanies the manuscript ‘Unsupervised discovery of dynamic cell phenotypic states from transmitted light movies’ (Nguyen et al., 2021). Image data is available for download separately at https://idr.openmicroscopy.org/about/experiments.html (work in progress)
Once the data file is downloaded from IDR, place it in the UPSIDEv1/pytorch_fnet-master/pytorch_fnet/data/ directory. 
Attached in UPSIDEv1 folder is a tutorial of how to apply the UPSIDE software to generate latent encoding and decoding on the Hematopoietic Cell Types Dataset. Additionally, refer to UPSIDE license file in the same folder for license information
