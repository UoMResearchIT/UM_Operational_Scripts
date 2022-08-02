#!/bin/bash

#SBATCH --job-name=ants_ocean
#SBATCH --time=3:0:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

#SBATCH --account=n02-NEV012681
#SBATCH --partition=serial
#SBATCH --qos=serial
#SBATCH --mem=124G

module load cray-python/3.8.5.0

python ESA_WB_regrid.py
