#!/bin/sh
#SBATCH -A k1639
#SBATCH -J c-bl_edit_mp_edit
#SBATCH -N 1
#SBATCH -t 60
#SBATCH -o /scratch/sahurk/Model_run/Logs/wrf_out_%j
#SBATCH -e /scratch/sahurk/Model_run/Logs/wrf_err_%j

set -x
bl=bl_edit
mp=mp_edit
export TOP=/scratch/sahurk/Model_run
#export OUTDIR1=${TOP}/Output_NC/out_arw_sf_clay_2_sf_surface_2/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output_NC1/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output_NC2/MP${mp}_BL${bl}
export OUTDIR=${TOP}/Output_NC2/24_25nov2022/cl1_sf2/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output_NC2/24_25nov2022/cl2_sf2/MP${mp}_BL${bl}
#export GFS=${TOP1}/2018/${DATE1}
#cp -r ${TOP}/ARWpost ${TOP}/ARWpost_MP${mp}_BL${bl}
#export ARW=${TOP}/ARWpost_MP${mp}_BL${bl}
#mkdir -p ${OUTDIR}
#mkdir -p ${OUTDIR1}
###################################################
module swap  PrgEnv-cray PrgEnv-intel
module load cdo

cd ${OUTDIR}/ 
cdo -f nc import_binary Novevent_MP${mp}_BL${bl}.ctl Novevent_MP${mp}_BL${bl}.nc
exit
