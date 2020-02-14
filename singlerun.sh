#!/bin/bash -l   
#SBATCH --ntasks=1 -p service 
#SBATCH -t 12:00:00 
#SBATCH -A fv3-cpu
#SBATCH -q batch 
#SBATCH -J getfiles 

module load intel/19.0.5.281
module load wgrib2 
module load hpss 
#set -x 

#=== set HPSS source, temporary work directory, and  storage directory
exp=ufs_b31
hpssdir=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS/benchmark3.1/c384
tmpdir=$scratch/testing/${exp}
storedir=$scratch/testing/${exp}
cleanup=yes

#===  set start/end year and month 
ystart=2018; yend=2018; ystep=1
mstart=1; mend=1; mstep=1
dstart=1; dend=1; dstep=1

#===
res=1p00    # Valid options are 1p00 and Orig
res=fake

#=== specs for plotting
domain=Nino3.4  # valid choices are Global, Global20, Global30, Global50,  Nino3.4, NP, SP, CONUS, etc (see $domain)
hardcopy=no

###################################################################################################
#                                   Work below                                                    #
###################################################################################################
here=$PWD

if [ $res == "1p00" ] ; then
    archfile=gfs_flux_1p00.tar
elif [  $res == "Orig" ] ; then
    archfile=gfs_flux.tar
else 
    echo "Aborting. Please pick a valid resolution"
    exit 
fi

gfs.t00z.sfluxgrbf780.grib2
if [ ! -d $tmpdir ] ; then mkdir -p $tmpdir; fi
if [ ! -d $storedir ] ; then mkdir -p $storedir; fi
cd $tmpdir
for (( yyyy=$ystart; yyyy<=$yend; yyyy+=ystep )) ; do
for (( mm1=$mstart; mm1<=$mend; mm1+=mstep )) ; do
for (( dd1=$dstart; dd1<=$dend; dd1+=dstep )) ; do
    mm=$(printf "%02d" $mm1)
    dd=$(printf "%02d" $dd1)
    tag=$yyyy$mm$dd
    workdir=$tmpdir/gfs.${tag}/00
    #=== do sfc files if not yet done
    if [ ! -f $storedir/fluxsubset.${exp}.${tag}00.${res}.nc ] ; then
       htar -xvf $hpssdir/${tag}00/$archfile
       for (( hhh1=0; hhh1<=840; hhh1+=6 )) ; do
           hhh=$(printf "%03d" $hhh1)
           if [ $res == "1p00" ] ; then
               gribin=$workdir/gfs.t00z.flux.1p00.f${hhh}
           else
               gribin=$workdir/gfs.t00z.sfluxgrbf${hhh}.grib2
           fi
           gribout=$workdir/subset.t00z.flux.${res}.f${hhh}
           wgrib2 $gribin -match ":(TMP|TMIN|TMAX|PRATE|LAND|ULWRF|ICETK|ICEC):(surface|2 m|top of)" -grib $gribout
       done
       cat $workdir/subset.t00z.flux.${res}.f* > $workdir/flux_allhours.grib2
       wgrib2  $workdir/flux_allhours.grib2 -netcdf $storedir/fluxsubset.${exp}.${tag}00.${res}.nc
       if [ $cleanup == "yes" ] ; then       
          rm -r $tmpdir/gfs.${tag}/
       fi
    else
       echo "$storedir/fluxsubset.${exp}.${tag}00.${res}.nc already exists"
    fi
done
done
done

###################################################################################################
#                                            Create ncl script                                    #
###################################################################################################
case "$domain" in 
    "Global") latS="-90"; latN="90" ;  lonW="0" ; lonE="360" ;;
    "Nino3.4") latS="-5"; latN="5" ;  lonW="190" ; lonE="240" ;;
    "Global30") latS="-30"; latN="30" ;  lonW="0" ; lonE="360" ;;
    "Global20") latS="-20"; latN="20" ;  lonW="0" ; lonE="360" ;;
    "Global50") latS="-50"; latN="50" ;  lonW="0" ; lonE="360" ;;
    "Global60") latS="-60"; latN="90" ;  lonW="0" ; lonE="360" ;;
    "CONUS") latS="25"; latN="60" ;  lonW="210" ; lonE="300" ;;
    "NAM") latS="0"; latN="90" ;  lonW="180" ; lonE="360" ;;
    "NP") latS="50"; latN="90" ;  lonW="0" ; lonE="360" ;;
    "SP") latS="-90"; latN="-50" ;  lonW="0" ; lonE="360" ;;
    "IndoChina") latS="-20"; latN="40" ;  lonW="30" ; lonE="150" ;;
    *)
esac
nclscript="$here/newtestplot.ncl"                         # Name for the NCL script to be created
cat << EOF > $nclscript
;----------------------------------------------------------------------
; testplot.ncl
;----------------------------------------------------------------------
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"

begin

   f    = addfile ("$storedir/fluxsubset.${exp}.${tag}00.${res}.nc", "r")  
   names=getfilevarnames(f)

   lon_0=f->longitude
   lat_0=f->latitude

   latS=$latS
   latN=$latN
   lonW=$lonW
   lonE=$lonE

   lat = lat_0({latS:latN})
   lon = lon_0({lonW:lonE})
   time=f->time
   date=cd_calendar(time,-3)
   ;print(date)
   land=f->LAND_surface(:,{latS:latN},{lonW:lonE})
   tmpsfc=f->TMP_surface(:,{latS:latN},{lonW:lonE})
   tmp2m=f->TMP_2maboveground(:,{latS:latN},{lonW:lonE})
   tmin2m=f->TMIN_2maboveground(:,{latS:latN},{lonW:lonE})
   tmax2m=f->TMAX_2maboveground(:,{latS:latN},{lonW:lonE})
   prate=f->PRATE_surface(:,{latS:latN},{lonW:lonE})
   ulwrf=f->ULWRF_surface(:,{latS:latN},{lonW:lonE})
   olr=f->ULWRF_topofatmosphere(:,{latS:latN},{lonW:lonE})
   icetk=f->ICETK_surface(:,{latS:latN},{lonW:lonE})
   icec=f->ICEC_surface(:,{latS:latN},{lonW:lonE})

;--- define weights

   nlon=dimsizes(lon)
   nlat=dimsizes(lat)
   
   pi=get_pi("float")
   rad    = 4.0*atan(1.0)/180.0
   re     = 6371220.0
   rr     = re*rad
   dlon   = abs(lon(2)-lon(1))*rr
   dx     = dlon*cos(lat*rad)
   dy     = new ( nlat, typeof(dx))
   dy(0)  = abs(lat(2)-lat(1))*rr
   dy(1:nlat-2)  = abs(lat(2:nlat-1)-lat(0:nlat-3))*rr*0.5   
   dy(nlat-1)    = abs(lat(nlat-1)-lat(nlat-2))*rr
   weights   = dx*dy 

;--- calculate area mean

   opt=0 ; ignore missing values

   tmax2m_mean=wgt_areaave_Wrap(tmax2m,weights,1.0,opt)
   tmin2m_mean=wgt_areaave_Wrap(tmin2m,weights,1.0,opt)
   tmp2m_mean=wgt_areaave_Wrap(tmp2m,weights,1.0,opt)
   tmpsfc_mean=wgt_areaave_Wrap(tmpsfc,weights,1.0,opt)
   
   data=new((/4,dimsizes(date)/),float) 
   data(0,:)=tmax2m_mean
   data(1,:)=tmin2m_mean
   data(2,:)=tmp2m_mean
   data(3,:)=tmpsfc_mean

;--- hardcopy yes/no
   if isStrSubset("$hardcopy","yes") then
     wks_type                     = "png"
     wks_type@wkWidth             = 3000
     wks_type@wkHeight            = 3000
   else
     wks_type                     = "x11"
     wks_type@wkWidth             = 1200
     wks_type@wkHeight            = 800
   end if 
   wks=gsn_open_wks(wks_type,"areamean.${domain}."+date(0)) 

;--- plot settings
   res=True
   res@tiMainString="Area mean for $domain, IC="+date(0)
   res@xyLineThicknesses = (/2., 2., 2., 2./)                   ; make second line thicker
   res@xyLineColors      = (/"red","blue","green","black"/)        ; change line color
   res@xyDashPatterns    = (/0,0,0,0/)
   res@pmLegendDisplayMode    = "Always"              ; turn on legend
   res@pmLegendSide           = "Top"                 ; Change location of 
   res@pmLegendParallelPosF   = 1.15                  ; move units right
   res@pmLegendOrthogonalPosF = -0.3                  ; more neg = down
 
   res@pmLegendWidthF         = 0.1                  ; Change width and
   res@pmLegendHeightF        = 0.1                  ; height of legend.
   res@lgLabelFontHeightF     = .015                   ; change font height
   res@lgPerimOn              = False                 ; no box around

;--- labels for the legend
   res@xyExplicitLegendLabels = (/"tmax2m","tmin2m", "tmp2m", "tmpsfc"/)

;--- labels for the time axis
   restick=True
   restick@ttmFormat="%c%D"
   time_axis_labels(time,res,restick) ; call the formatting procedure
;--- plot
   plot  = gsn_csm_xy (wks,time,data,res) ; create plot


end
EOF
echo "ncl script generated: $nclscript"
