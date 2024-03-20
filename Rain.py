#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
for year in range(41):
	currentyear=year+1979
	server = ECMWFDataServer()
	server.retrieve({
	"class": "ei",
	"dataset": "interim",
	"date": str(currentyear)+"-01-01/to/"+str(currentyear)+"-12-31",
	"expver": "1",
	"grid": "0.75/0.75",
	"levtype": "sfc",
	"param": "59.128/228.128",
	"step": "3/6/9/12",
	"stream": "oper",
	"time": "00:00:00/12:00:00",
	"type": "fc",
	"target": "Raincape."+str(currentyear)+".grib",
	})
