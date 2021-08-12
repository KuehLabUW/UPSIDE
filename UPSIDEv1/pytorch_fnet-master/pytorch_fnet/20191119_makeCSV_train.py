# -*- coding: utf-8 -*-
"""
Spyder Editor
Script from Sam

This is a temporary script file.
"""
import csv
import numpy

#enter the number of time points in your movie
#numpy.linspace(first_timepoint,last_timepoint,last_timepoint)

# I have 4 base file names..
# 20191114_BF_10ms_RF: 2 timepoints, 98 positions
# 20191114_24hr_BF_50ms_RF: 2 timepoints, 98 positions
# 20191114_30hr_BF_10ms_RF: 2 timepoints, 98 positions
# 20191114_36hr_BF_10ms_RF: 3 timepoints, 86 positions
basenames = ['20191114_BF_10ms_RF', '20191114_24hr_BF_50ms_RF', '20191114_30hr_BF_10ms_RF', '20191114_36hr_BF_10ms_RF']
TimepointA = numpy.linspace(1,2,2)
TimepointB = numpy.linspace(1,2,2)
TimepointC = numpy.linspace(1,2,2)
TimepointD = numpy.linspace(1,3,3)
#enter the number of positions you have
#numpy.linspace(1,number_of_pos,number_of_pos)
PositionA = numpy.linspace(1,98, 98)
PositionB = numpy.linspace(1,98, 98)
PositionC = numpy.linspace(1,98, 98)
PositionD = numpy.linspace(1,86, 86)


#enter the name of your folder with BF and fluorescence images 'data/name_of_your_folder/'
root_dir = 'data/20191114_KA_training_CTV_BF10ms/'

with open('20191114_KA_train.csv','w') as mycvsfile: # you can change the name of your output file in ' .csv'
        thedatawriter = csv.writer(mycvsfile,lineterminator = '\n')
        thedatawriter.writerow(('path_signal','path_target'))
        for i in PositionA:
            for j in TimepointA:
		#between the ' ', enter your BF amd fluorescence image names, respectively:
                # 'basename_channelname_s{}_t{}.TIF' Keep the 's{}_t{}' as is!
                signal_name = '{}_w1Camera BF_s{}_t{}.TIF'.format(basenames[0], int(i),int(j))
                target_name = '{}_w2LDI 405_s{}_t{}.TIF'.format(basenames[0], int(i),int(j))
                thedatawriter.writerow((root_dir+signal_name,root_dir+target_name))

        for i in PositionB:
            for j in TimepointB:
		#between the ' ', enter your BF amd fluorescence image names, respectively:
                # 'basename_channelname_s{}_t{}.TIF' Keep the 's{}_t{}' as is!
                signal_name = '{}_w1Camera BF_s{}_t{}.TIF'.format(basenames[1], int(i),int(j))
                target_name = '{}_w2LDI 405_s{}_t{}.TIF'.format(basenames[1], int(i),int(j))
                thedatawriter.writerow((root_dir+signal_name,root_dir+target_name))

        for i in PositionC:
            for j in TimepointC:
		#between the ' ', enter your BF amd fluorescence image names, respectively:
                # 'basename_channelname_s{}_t{}.TIF' Keep the 's{}_t{}' as is!
                signal_name = '{}_w1Camera BF_s{}_t{}.TIF'.format(basenames[2], int(i),int(j))
                target_name = '{}_w2LDI 405_s{}_t{}.TIF'.format(basenames[2], int(i),int(j))
                thedatawriter.writerow((root_dir+signal_name,root_dir+target_name))

        for i in PositionD:
            for j in TimepointD:
		#between the ' ', enter your BF amd fluorescence image names, respectively:
                # 'basename_channelname_s{}_t{}.TIF' Keep the 's{}_t{}' as is!
                signal_name = '{}_w1Camera BF_s{}_t{}.TIF'.format(basenames[3], int(i),int(j))
                target_name = '{}_w2LDI 405_s{}_t{}.TIF'.format(basenames[3], int(i),int(j))
                thedatawriter.writerow((root_dir+signal_name,root_dir+target_name))
