#!/bin/sh
#SBATCH -A k1254
#SBATCH -J WRF-Chem
#SBATCH -N 40
#SBATCH -t 1400
#SBATCH -o wrf_out_%j
#SBATCH -e wrf_err_%j

set -x

DATE=`date +%Y%m%d`12
#DATE=2022042312
export TOP=/scratch/karumulb/Operational
export WPS=${TOP}/WPS-4.2
export WRF=${TOP}/WRF-4.2/test/em_real
#export WRFDA=${TOP}/wrfda/var/run
export OUTDIR=${TOP}/output-wrf/${DATE}
export WORK=${TOP}/work1
export GFS=${TOP}/Input/GFS_${DATE}
export ARW=${TOP}/ARWpost
mkdir -p ${OUTDIR}
###################################################
#export CYCLE_PERIOD=72
#export CLC_PERIOD=3
#export NDATE=$(${WRFDA}/da_advance_time.exe $DATE +$CYCLE_PERIOD 2>/dev/null)
#export MAXA_DATE=$(${WRFDA}/da_advance_time.exe $DATE +$CLC_PERIOD 2>/dev/null)
#export PREV_DATE=$(${WRFDA}/da_advance_time.exe $DATE -$CLC_PERIOD 2>/dev/null)
export TODAT=`echo ${DATE}|cut -c1-8`
export Tyear=`echo $DATE|cut -c1-4`
export Tmonth=`echo $DATE|cut -c5-6`
export Tday=`echo $DATE|cut -c7-8`
export Thr=`echo $DATE|cut -c9-10`
export TODAT=`echo ${DATE}|cut -c1-8`
#export NDAT=`echo ${NDATE}|cut -c1-8`

#export Nyear=`echo $NDATE|cut -c1-4`
#export Nmonth=`echo $NDATE|cut -c5-6`
#export Nday=`echo $NDATE|cut -c7-8`
#export Nhr=`echo $NDATE|cut -c9-10`

TODATDATE=$Tyear"-"$Tmonth"-"$Tday"_"$Thr:"00:00"
###################################################
#cd ${GFS}
#./start12

#sleep 300

cd ${WORK}
${WORK}/incr_wrf_date ${DATE} 240
cat namelist.input.botmidap >> namelist.input
cat namelist.wps.botmidap >> namelist.wps
cp namelist.input ${WRF}
cp namelist.wps ${WPS}
###################################################
cd ${WPS}

rm met_em.d0* SFC\:* PFILE:* GRIBFILE.A* ${WRF}/rsl.*  ${WRF}/met_em.d0* ${WRF}/wrfrst* 

#srun -n 1 ./geogrid.exe

${WPS}/link_grib.csh ${GFS}/gfs*

srun -n 1 ./ungrib.exe
if [ `grep -c Successful ungrib.log` -lt 1 ]; then
  echo Ungrib failed
  exit
fi

srun -n 1 ./metgrid.exe
if [ `grep -c Successful metgrid.log.0000 ` -lt 1 ]; then
  echo metgrid failed
  exit
fi
###################################################
cd ${WRF}
/bin/ln -fs ${WPS}/met_em* .

srun -n 1280 ${WRF}/real.exe
if [ `grep -c SUCCESS rsl.out.0000` -lt 1 ]; then
  echo REAL run failed
  exit
fi
#---------------------------------------------------
echo "START JOB AT $(date +"%d-%m-%Y %H:%M")"
echo "#---------------------------------------------------"

cd ${WRF}
srun -n 1280 ${WRF}/wrf.exe
if [ `grep -c SUCCESS rsl.out.0000` -lt 1 ]; then
  echo WRF run failed at ${DATE}
  exit
fi

echo "JOB END AT $(date +"%d-%m-%Y %H:%M")"

echo "#---------------------------------------------------"
mv wrfout_d0* ${OUTDIR}/

#cd $ARW

#ln -sf ${OUTDIR}/wrfout_d01* .

#CTNAME=C${DATE}
#CTLNAME="'"${CTNAME}"'"
#TODATDATE=$Tyear"-"$Tmonth"-"$Tday"_"$Thr:"00:00"
#NEXTDATE=$Nyear"-"$Nmonth"-"$Nday"_"$Nhr:"00:00"

#cat > namelist.ARWpost1 << END
#&datetime
# start_date = ${TODATDATE},
# end_date   = ${NEXTDATE},
# interval_seconds = 3600,
# tacc = 0,
# debug_level = 0,
#/

#&io
# input_root_name = './wrfout_d02*'
# output_root_name = ${CTLNAME}
# plot = 'file'
# fields = 'height,pressure,tk,tc'
# mercator_defs = .true.
# output_type = 'grads'
# fields_file = 'myLIST.4'
#/
#&interp
# interp_method = 1,
# interp_levels = 1000.0, 975.0, 950.0, 925.0, 900., 875.0, 850.0, 825.0, 800.,750.,700.,650.,600.,550.,500.,450.,400.,350.,300.,250.,200.,150., 100., 
#/
#END

#module swap PrgEnv-cray PrgEnv-intel
#cp  namelist.ARWpost1 namelist.ARWpost
#cat > wrfarwpost.sh << END

#!/bin/sh
#SBATCH -A k1254
#SBATCH -J ARW
#SBATCH -N 1  
#SBATCH --partition=debug
#SBATCH -t 30
##SBATCH --mem-per-cpu=20480
#SBATCH -o wrf_out_file
#module swap PrgEnv-cray PrgEnv-intel

#cd /scratch/dasarih/operational/arwpost-3
#srun -n 1 /scratch/dasarih/operational/arwpost-3/ARWpost.exe

#module swap PrgEnv-intel PrgEnv-gnu
#module load cdo

#cdo -f nc import_binary ${CTLNAME}.ctl  ${CTLNAME}.nc

#mv  ${CTLNAME}.nc /project/k1254/hari/operational/outputs_nc/
#chmod 777  /project/k1254/hari/operational/outputs_nc/${CTLNAME}.nc

#END

#ln -sf ${WRF}/wrfout_d02* .
#sbatch wrfarwpost.sh
exit

#---------------------------------------------------
