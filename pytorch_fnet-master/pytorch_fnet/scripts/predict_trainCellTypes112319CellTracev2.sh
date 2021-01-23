#!/bin/bash -x

DATASET=${1:-CellTypeCellTraceTrain112319v2}
MODEL_DIR=saved_models/${DATASET}
N_IMAGES=1000000
GPU_IDS=${2:-0}

for TEST_OR_TRAIN in testCellTypes020420
do
    python predict.py \
	   --path_model_dir ${MODEL_DIR} \
           --class_dataset TiffDataset \
	   --path_dataset_csv data/csvs/${DATASET}/${TEST_OR_TRAIN}.csv \
	   --n_images ${N_IMAGES} \
	   --no_prediction_unpropped \
	   --path_save_dir results/3d/${DATASET}/${TEST_OR_TRAIN} \
	   --gpu_ids ${GPU_IDS} 
done

