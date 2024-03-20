load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin

          f1     = addfile("wrfinput_d01","w")
          timestamp0 = "2011-01-01_00:00:00"
          timestamp = stringtochar(timestamp0)
          f1->Times(0,0:18) = (/timestamp(0:18)/)
end
