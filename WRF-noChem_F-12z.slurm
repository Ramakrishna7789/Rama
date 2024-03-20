#!/bin/sh
#SBATCH -A k1639
#SBATCH -J R-bl_edit_mp_edit
#SBATCH -N 20
#SBATCH --partition=workq
##SBATCH --mail-user=rajesh.sahu@kaust.edu.sa
#SBATCH --mail-type=ALL
#SBATCH -t 1400
#SBATCH -o /scratch/sahurk/Model_run/Logs/wrf_out_%j
#SBATCH -e /scratch/sahurk/Model_run/Logs/wrf_err_%j


set -x
bl=bl_edit
mp=mp_edit
#DATE=2022112200
DATE=2022112400
#DATE=2019020700

export TOP=/scratch/sahurk/Model_run
export TOP1=/scratch/sahurk/Model_run/Input/GFS_inputs
export WPS=${TOP}/WPS
cp -r ${TOP}/WRF/test/em_real ${TOP}/WRF/test/em_real_BL${bl}_MP${mp}
export WRF=${TOP}/WRF/test/em_real_BL${bl}_MP${mp}
#export OUTDIR=${TOP}/Output/MP${mp}_BL${bl}
export OUTDIR=${TOP}/Output/24_25nov2022/sc1/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output/24_25nov2022/sc2/MP${mp}_BL${bl}
#export OUTDIR1=${TOP}/Output_NC1/MP${mp}_BL${bl}
#export OUTDIR1=${TOP}/Output_NC2/MP${mp}_BL${bl} # uncomment later
#export OUTDIR=${TOP}/ERA_Output/MP${mp}_BL${bl}
#export OUTDIR1=${TOP}/ERA_Output_NC/MP${mp}_BL${bl}
#export GFS=${TOP1}/2018/${DATE1}
#cp -r ${TOP}/ARWpost ${TOP}/ARWpost_MP${mp}_BL${bl}
#export ARW=${TOP}/ARWpost_MP${mp}_BL${bl}
mkdir -p ${OUTDIR}
#mkdir -p ${OUTDIR1}
###################################################
export LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/latest/linux/compiler/lib/intel64_lin:$LD_LIBRARY_PATH
source /project/k1639/sahurk/env.intel
TODATDATE=$Tyear"-"$Tmonth"-"$Tday"_"$Thr:"00:00"
####################################################
cd ${WRF}
rm -f met_em.d0*
/bin/ln -fs ${WPS}/met_em* .
sed -i 82s/8/${mp}/g namelist.input 
sed -i 88s/6/${bl}/g namelist.input 

/opt/slurm/default/bin/srun -n 640 ${WRF}/real.exe
if [ `grep -c SUCCESS rsl.out.0000` -lt 1 ]; then
  echo REAL run failed
  exit
fi
#---------------------------------------------------
echo "START JOB AT $(date +"%d-%m-%Y %H:%M")"
echo "#---------------------------------------------------"

cd ${WRF}
/opt/slurm/default/bin/srun -n 640 ${WRF}/wrf.exe
if [ `grep -c SUCCESS rsl.out.0000` -lt 1 ]; then
  echo WRF run failed at ${DATE}
  exit
fi

echo "JOB END AT $(date +"%d-%m-%Y %H:%M")"

echo "#---------------------------------------------------"
mv wrfout_d0* ${OUTDIR}/
exit
