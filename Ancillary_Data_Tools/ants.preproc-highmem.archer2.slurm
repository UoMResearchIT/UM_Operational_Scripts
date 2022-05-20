#!/bin/bash

#SBATCH --job-name=ants_cci
#SBATCH --time=1:0:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1

#SBATCH --account=n02-weat
#SBATCH --partition=highmem
#SBATCH --qos=highmem


export ANTS_HOME=$(pwd -P)
export ANTS_CONTAINER=/work/y07/shared/umshared/ANTS/latest/ants_latest.sif
export SINGULARITYENV_APPEND_PATH="/opt/conda/envs/ants/bin"
#export SINGULARITYENV_APPEND_PATH=$(pwd -P)"/bin"
export ANTS_OUT=$(pwd -P)"/ants_out"
#export ANTS_NPROCESSES=$SLURM_NTASKS

singularity exec --home $ANTS_HOME $ANTS_CONTAINER ancil_lct_preproc_cci.py ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v2.0.7b.nc --output $ANTS_OUT --igbp-source modis_landcover_class_qd.asc --ants-config ants.highmem.config 
