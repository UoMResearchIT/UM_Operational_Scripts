#!/bin/bash

#SBATCH --job-name=ants_cci
#SBATCH --time=1:0:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

#SBATCH --account=n02-NEV012681
#SBATCH --partition=serial
#SBATCH --qos=serial
#SBATCH --mem=124G

module load nco/5.0.5

ncap2 -O -s 'where(lccs_class == -45) lccs_class=116' ants_out.nc ants_out.nc
ncap2 -O -s 'where(lccs_class == -47) lccs_class=118' ants_out.nc ants_out.nc
