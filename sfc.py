#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
for year in range(40):
	for month in range(12):
		currentyear=year+1979
		currentmonth=month+1
		server = ECMWFDataServer()
		server.retrieve({
		"class": "ei",
		"dataset": "interim",
		"date": str(currentyear)+"-"+str(currentmonth).zfill(2)+"-01/to/"+str(currentyear)+"-"+str(currentmonth).zfill(2)+"-31",
		"expver": "1",
		"grid": "0.75/0.75",
		"levtype": "sfc",
		"param": "31.128/33.128/34.128/39.128/40.128/41.128/42.128/134.128/139.128/141.128/151.128/165.128/166.128/167.128/170.128/183.128/235.128/236.128/71.162/72.162",
		"step": "0",
		"stream": "oper",
		"time": "00:00:00/06:00:00/12:00:00/18:00:00",
		"type": "an",
		"target": "sfc."+str(currentyear)+""+str(currentmonth).zfill(2)+".grib",
		})

