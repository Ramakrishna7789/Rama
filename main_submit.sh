#!/bin/bash
#SBATCH -A k1254
#SBATCH -J main_extd
#SBATCH -N 1
#SBATCH --partition=debug
#SBATCH -t 30
#SBATCH -o /scratch/karumulb/Hari_data/logs/out_extract
#SBATCH -e /scratch/karumulb/Hari_data/logs/err_extract

module unload PrgEnv-cray  PrgEnv-gnu PrgEnv-intel
module load PrgEnv-cray
module swap PrgEnv-cray  PrgEnv-gnu
module load wgrib2

set -x

date

export SRC=`pwd`
export JOBS=$SRC/jobscripts 
export LOGS=$SRC/logs

rm -rf $JOBS $LOGS 
mkdir -p $JOBS $LOGS


#for year in 2020  ;   do
#for mon  in {05..10}  ; do
#for mon  in 01  ; do

#for year in 2010  ;   do
for year in {2000..2020} ; do
#for year in {1980..2019} ; do
for mon  in {01..12}  ; do
#for mon in 01 ; do
jfile=ext_${year}${mon}.sh

#cp run_extract_req            $jfile
#cp run_extract_top_sfc_uvprad2             $jfile
cp run_extract_solar_vars            $jfile
sed -i 's|YEAR_EDIT|'$year'|'                    $jfile
sed -i 's|MON_EDIT|'$mon'|'                      $jfile

mv $jfile $JOBS/run_ext_${year}_${mon}.sh
sbatch $JOBS/run_ext_${year}_${mon}.sh

usleep 30
done   #month

done   #year
set +x 

exit
