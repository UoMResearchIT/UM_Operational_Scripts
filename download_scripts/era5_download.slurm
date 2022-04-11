#!/bin/bash

#SBATCH --job-name=era5_download
#SBATCH --time=12:0:0
#SBATCH --ntasks=1

#SBATCH --account=n02-weat
#SBATCH --partition=serial
#SBATCH --qos=serial

. ~/bin/conda_init.sh

conda activate cdsapi


python download.py

