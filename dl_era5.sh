#!/bin/bash

mkdir era5
if [ -z "$1" ]; then
    echo "Please specify the year" ; exit
fi ; y=$1

#for m in 01 02 03 04 05 06 07 08 09 10 11 12; do
for m in 01 ; do
if [ ! -f "era5/$y.$m.sfc.grib" ]; then
 python dl.sfc.py $y $m &
 sleep 1
fi
done

#for m in 01 02 03 04 05 06 07 08 09 10 11 12; do
for m in 01 ; do
 if [ ! -f "era5/$y.$m.prs.grib" ]; then
  python dl.prs.py $y $m &
  sleep 1
 fi
done
