#!/bin/bash
#SBATCH -A k1639
#SBATCH -J main_extd
#SBATCH -N 1 
#SBATCH --partition=debug
#SBATCH -t 30
#SBATCH -o out_extract
#SBATCH -e err_extract

module unload PrgEnv-cray  PrgEnv-gnu PrgEnv-intel
module load PrgEnv-cray
module swap PrgEnv-cray  PrgEnv-gnu
module load wgrib2

set -x

date

export SRC=/scratch/sahurk/Model_run
export JOBS=$SRC/Temp_scripts
export LOGS=$SRC/Logs

#rm -rf $JOBS $LOGS 
mkdir -p $JOBS $LOGS

# sf_clay_1_sf_surface_2
for bl in 1 5 7 8 ; do
for mp in 1 2 6 8 10 ; do


# sf_clay_2_sf_surface_2
#for bl in 2 5 8 9 ; do
#for mp in 1 2 5 6 8 10 ; do

#for bl in 1  ; do
#for mp in 6 ; do


	jfile=ext_temp.sh

cp ARW_temp.slurm          $SRC/$jfile
sed -i 's|bl_edit|'$bl'|'                   $SRC/$jfile
sed -i 's|mp_edit|'$mp'|'                   $SRC/$jfile

mv $SRC/$jfile $JOBS/run_ARW_${bl}_${mp}.sh
sbatch $JOBS/run_ARW_${bl}_${mp}.sh

sleep 2
done   #month
done
set +x 

exit
