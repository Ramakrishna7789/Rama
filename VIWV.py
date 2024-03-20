#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
for year in range(40):
	currentyear=year+1979
	server = ECMWFDataServer()
	server.retrieve({
	"class": "ei",
	"dataset": "interim",
	"date": str(currentyear)+"-01-01/to/"+str(currentyear)+"-12-31",
	"expver": "1",
	"grid": "0.75/0.75",
	"levtype": "sfc",
	"param": "71.162/72.162",
	"step": "0",
	"stream": "oper",
	"time": "00:00:00/06:00:00/12:00:00/18:00:00",
	"type": "an",
	"target": "VIWV."+str(currentyear)+".grib",
	})
