#!/bin/bash
set -x
echo "Job Submitted in $(hostname) by Karumuri"
export workarea=/scratch/karumulb/Operational/Input/
mkdir -p  $workarea

gfsForecastDownload()
{
export startCyc="${YYYY}-${MM}-${DD} ${cyc}:00:00"
echo ${YYYY}${MM}${DD}_${cyc}
mkdir -p ${workarea}/GFS_$YYYY$MM$DD${cyc}
cd ${workarea}/GFS_$YYYY$MM$DD${cyc}
for hr in {000..240..006};do
   echo $hr
   echo $(date)
        if [ ! -f "${workarea}/GFS_$YYYY$MM$DD${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${hr}" ]; then
          echo "download started/completed for: ${hr} hour at ${workarea}/GFS_$YYYY$MM$DD${cyc}"
          echo "wget -c  https://noaa-gfs-bdp-pds.s3.amazonaws.com/gfs.${YYYY}${MM}${DD}/${cyc}/atmos/gfs.t${cyc}z.pgrb2.0p25.f${hr}"
          wget  -bqc https://noaa-gfs-bdp-pds.s3.amazonaws.com/gfs.${YYYY}${MM}${DD}/${cyc}/atmos/gfs.t${cyc}z.pgrb2.0p25.f${hr}
          sleep 2s
          if [ ! -s "${workarea}/GFS_$YYYY$MM$DD${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${hr}" ]; then
               rm -f ${workarea}/GFS_$YYYY$MM$DD${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${hr}   
          fi
          echo  "filesize:" $(stat -c%s ${workarea}/GFS_$YYYY$MM$DD${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${hr}) 
          #echo "wget -c -t 20 --no-check-certificate http://www.ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs.${YYYY}${MM}${DD}/${cyc}/atmos/gfs.t${cyc}z.pgrb2.0p25.f${hr}"
          #wget -c -t 20 --no-check-certificate http://www.ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs.${YYYY}${MM}${DD}/${cyc}/atmos/gfs.t${cyc}z.pgrb2.0p25.f${hr} >&log${hr}.txt &
          #sleep 2s
          #if [ ! -s "${workarea}/GFS_$YYYY$MM$DD${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${hr}" ]; then
          #     rm -f ${workarea}/GFS_$YYYY$MM$DD${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${hr}   
          #fi
          #echo  "filesize:" $(stat -c%s ${workarea}/GFS_$YYYY$MM$DD${cyc}/gfs.t${cyc}z.pgrb2.0p25.f${hr}) 
  fi
done
echo "download completed"
}

###############
cd $workarea
#echo $(date -u)
export hr=`date -u +%H` # UTC
## condition ##
if [ ${hr} -ge 04 -a ${hr} -lt 14 ]
 then
 export cyc=00
 export YYYY=`date -u -d "-0 day" +%Y` # UTC
 export MM=`date -u -d "-0 day" +%m` # UTC
 export DD=`date -u -d "-0 day" +%d` # UTC
 gfsForecastDownload
elif [ ${hr} -ge 14 ]
 then
 export cyc=12
 export YYYY=`date -u -d "-0 day" +%Y` # UTC
 export MM=`date -u -d "-0 day" +%m` # UTC
 export DD=`date -u -d "-0 day" +%d` # UTC
 echo $(date)
 gfsForecastDownload
elif [ ${hr} -lt 4 ]
 then
 export cyc=12
 export YYYY=`date -u -d "-1 day" +%Y` # UTC
 export MM=`date -u -d "-1 day" +%m` # UTC
 export DD=`date -u -d "-1 day" +%d` # UTC
 echo $(date)
 gfsForecastDownload
fi
### Clean Logs ########333
find  /home/karumulb/log  -name "*.log" -type f -mtime +3 -delete
