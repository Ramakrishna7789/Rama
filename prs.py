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
		"levelist": "1/2/3/5/7/10/20/30/50/70/100/125/150/175/200/225/250/300/350/400/450/500/550/600/650/700/750/775/800/825/850/875/900/925/950/975/1000",
		"levtype": "pl",
		"param": "129.128/130.128/131.128/132.128/133.128",
		"step": "0",
		"stream": "oper",
		"time": "00:00:00/06:00:00/12:00:00/18:00:00",
		"type": "an",
		"target": "prs."+str(currentyear)+""+str(currentmonth).zfill(2)+".grib",
		})





