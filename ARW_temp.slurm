#!/bin/sh
#SBATCH -A k1639
#SBATCH -J WRF-bl_edit_mp_edit
#SBATCH -N 1 
#SBATCH -t 60
#SBATCH -o /scratch/sahurk/Model_run/Logs/wrf_out_%j
#SBATCH -e /scratch/sahurk/Model_run/Logs/wrf_err_%j

set -x
bl=bl_edit
mp=mp_edit
export TOP=/scratch/sahurk/Model_run
export WPS=${TOP}/WPS
export WRF=${TOP}/WRF/test/em_real_BL${bl}_MP${mp}
#export OUTDIR=${TOP}/Output/sf_clay_1_sf_surface_2/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output/sc1_sf2_36hr/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output/sc2_sf2_36hr/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output/wrfoutputfiles/24_25nov2022/sc1/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output/wrfoutputfiles/24_25nov2022/sc2/MP${mp}_BL${bl}
export OUTDIR=${TOP}/Output/24_25nov2022/sc1/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output/24_25nov2022/sc2/MP${mp}_BL${bl}

#export OUTDIR=${TOP}/Output/sf_clay_2_sf_surface_2/MP${mp}_BL${bl}
#export OUTDIR=${TOP}/Output/tropical_M_6_b1_lw4_sw4_c91_sf2/MP${mp}_BL${bl}
#export OUTDIR1=${TOP}/Output_NC1/MP${mp}_BL${bl}
#export OUTDIR1=${TOP}/Output_NC2/MP${mp}_BL${bl}
export OUTDIR1=${TOP}/Output_NC2/24_25nov2022/cl1_sf2/MP${mp}_BL${bl}
#export OUTDIR1=${TOP}/Output_NC2/24_25nov2022/cl2_sf2/MP${mp}_BL${bl}

#export OUTDIR=${TOP}/ERA_Output/MP${mp}_BL${bl}
#export OUTDIR1=${TOP}/ERA_Output_NC/MP${mp}_BL${bl}
#export GFS=${TOP1}/2018/${DATE1}
cp -r ${TOP}/ARWpost ${TOP}/ARWpost_MP${mp}_BL${bl}
export ARW=${TOP}/ARWpost_MP${mp}_BL${bl}
mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR1}
###################################################
export LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/latest/linux/compiler/lib/intel64_lin:$LD_LIBRARY_PATH
source /project/k1639/sahurk/env.intel
TODATDATE=$Tyear"-"$Tmonth"-"$Tday"_"$Thr:"00:00"

cd ${ARW}
rm wrfout_d01* *.ctl *.dat
ln -sf ${OUTDIR}/wrfout_d01* .

sed -i 11s/Novevent_MP103_BL203/Novevent_MP${mp}_BL${bl}/g namelist.ARWpost
#sed -i 11s/Novevent_MP${mp}_BL${bl}/g namelist.ARWpost
#sed -i 11s/203/${bl}/g namelist.ARWpost
#sed -e '11s/103/${mp}/g' -e '11s/203/${bl}/g' namelist.ARWpost
cat > wrfarwpost.slurm << END
#!/bin/sh
#SBATCH -A k1639
#SBATCH -J Hyd
#SBATCH -N 1  
##SBATCH --partition=debug
#SBATCH -t 1440
##SBATCH --mem=MaxMemPerNode
#SBATCH -o ARW_out_file

module unload PrgEnv-cray  PrgEnv-gnu  PrgEnv-intel
module load PrgEnv-intel
export LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/latest/linux/compiler/lib/intel64_lin:$LD_LIBRARY_PATH
cd ${ARW}
/opt/slurm/default/bin/srun -n 1 ${ARW}/ARWpost.exe
srun -n 1 ${ARW}/ARWpost.exe

##module unload PrgEnv-cray  PrgEnv-gnu  PrgEnv-intel
##module load PrgEnv-gnu
##module load cdo

##cdo -f nc import_binary Novevent_MP${mp}_BL${bl}.ctl Novevent_MP${mp}_BL${bl}.nc
##mv *.ctl *.dat *.nc ${OUTDIR1}/ 
mv *.ctl *.dat *.nc ${OUTDIR1}/

END
sh run.sh

exit
