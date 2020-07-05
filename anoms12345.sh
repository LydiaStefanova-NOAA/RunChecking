#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q batch             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 120               # -t specifies walltime in minutes; if in debug, cannot be more than 30

# (proper RMSe calculation version)

for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)
    case "$KEY" in
            whereexp)   whereexp=${VALUE} ;;
            whereobs)   whereobs=${VALUE} ;;
            hardcopy)   hardcopy=${VALUE} ;;
            domain)     domain=${VALUE} ;;  
            varModel)   varModel=${VALUE} ;;   
            season)     season=${VALUE} ;;   
            nameModelA) nameModelA=${VALUE} ;;
            nameModelB) nameModelB=${VALUE} ;;
            nameModelC) nameModelC=${VALUE} ;;
            nameModelD) nameModelD=${VALUE} ;;
            nameModelE) nameModelE=${VALUE} ;;
            ystart)     ystart=${VALUE} ;;
            yend)       yend=${VALUE} ;;
            mstart)     mstart=${VALUE} ;;
            mend)       mend=${VALUE} ;;
            mstep)      mstep=${VALUE} ;;
            realmask)   realmask=${VALUE} ;;
            *)
    esac
done

case "$domain" in 
    "Global") latS="-90"; latN="90" ;  lonW="0" ; lonE="360" ;;
    "Nino3.4") latS="-5"; latN="5" ;  lonW="190" ; lonE="240" ;;
    "GlobalTropics") latS="-30"; latN="30" ;  lonW="0" ; lonE="360" ;;
    "Global20") latS="-20"; latN="20" ;  lonW="0" ; lonE="360" ;;
    "Global50") latS="-50"; latN="50" ;  lonW="0" ; lonE="360" ;;
    "Global60") latS="-60"; latN="90" ;  lonW="0" ; lonE="360" ;;
    "CONUS") latS="25"; latN="60" ;  lonW="210" ; lonE="300" ;;
    "NAM") latS="0"; latN="90" ;  lonW="180" ; lonE="360" ;;
    "IndoChina") latS="-20"; latN="40" ;  lonW="30" ; lonE="150" ;;
    "NH") latS="50"; latN="90" ;  lonW="0" ; lonE="360" ;;
    "SH") latS="-90"; latN="-50" ;  lonW="0" ; lonE="360" ;;
    "DatelineEq") latS="-1"; latN="1" ;  lonW="179" ; lonE="181" ;;
    *)
esac

       if [ "$varModel" == "t2max" ] ; then
          ncvarModel="TMAX_2maboveground"; multModel=1.; offsetModel=0.; units="deg K"; mask="landonly"
          nameObs="t2max_CPC";  varObs="tmax"; ncvarObs="tmax"; multObs=1.; offsetObs=273.15
       fi
       if [ "$varModel" == "t2min" ] ; then
          ncvarModel="TMIN_2maboveground"; multModel=1.; offsetModel=0.; units="deg K";mask="landonly"
          nameObs="t2min_CPC";  varObs="tmin"; ncvarObs="tmin"; multObs=1.; offsetObs=273.15
       fi
       if [ "$varModel" == "tmpsfc" ] ; then
          ncvarModel="TMP_surface"; multModel=1.; offsetModel=0.; units="deg K";mask="oceanonly"
          nameObs="sst_OSTIA";  varObs="sst_OSTIA"; ncvarObs="analysed_sst"; multObs=1.; offsetObs=0.
       fi
       if [ "$varModel" == "prate" ] ; then
          ncvarModel="PRATE_surface"; multModel=86400.; offsetModel=0.; units="mm/day"; mask="landonly"
          nameObs="pcp_CPC_Global";  varObs="rain"; ncvarObs="rain"; multObs=0.1; offsetObs=0.; mask="landonly"
          nameObs="pcp_TRMM";  varObs="pcp-TRMM"; ncvarObs="precipitation"; multObs=1; offsetObs=0.; mask="oceanonly"
       fi
       if [ "$varModel" == "ulwrftoa" ] ; then
          ncvarModel="ULWRF_topofatmosphere"; multModel=1.; offsetModel=0.; units="W/m^2"; mask="nomask"
          nameObs="olr_HRIS"; varObs="ulwrftoa"; ncvarObs="olr"; multObs=1.; offsetObs=0.; units="W/m^2"; mask="oceanonly"
       fi
       mask=$realmask

          nameModelBA=${nameModelB}_minus_${nameModelA}
          nameModelA0=${nameModelA}_minus_${nameObs}
          nameModelB0=${nameModelB}_minus_${nameObs}
          nameModelC0=${nameModelC}_minus_${nameObs}
          nameModelD0=${nameModelD}_minus_${nameObs}
          nameModelE0=${nameModelE}_minus_${nameObs}
 
        echo $nameModelA0 $nameModelB0 $nameModelC0 $nameModelD0 $nameModelE0

       rm ${varModel}-${nameModelA}-list.txt ${varModel}-${nameModelB}-list.txt    # clean up from last time
       rm ${varModel}-${nameModelC}-list.txt ${varModel}-${nameModelD}-list.txt    # clean up from last time
       rm ${varModel}-${nameModelE}-list.txt ${varModel}-${nameObs}-list.txt

       LENGTH=0
       pass=0
       for (( yyyy=$ystart; yyyy<=$yend; yyyy+=1 ))  ; do
       for (( mm1=$mstart; mm1<=$mend; mm1+=$mstep )) ; do
       for dd1 in {1..15..14} ; do
           mm=$(printf "%02d" $mm1)
           dd=$(printf "%02d" $dd1)
           tag=$yyyy$mm${dd}
           #echo "$whereexp/$nameModelA/1p00/dailymean/${tag}/${varModel}.${nameModelA}.${tag}.dailymean.1p00.nc"
           #echo "$whereexp/$nameModelB/1p00/dailymean/${tag}/${varModel}.${nameModelB}.${tag}.dailymean.1p00.nc"
           #echo "$whereexp/$nameModelC/1p00/dailymean/${tag}/${varModel}.${nameModelC}.${tag}.dailymean.1p00.nc"
           #echo "$whereobs/$nameObs/1p00/dailymean"
           if [ -f $whereexp/$nameModelA/1p00/dailymean/${tag}/${varModel}.${nameModelA}.${tag}.dailymean.1p00.nc ] ; then
              if [ -f $whereexp/$nameModelB/1p00/dailymean/${tag}/${varModel}.${nameModelB}.${tag}.dailymean.1p00.nc ] ; then
                  pathObs="$whereobs/$nameObs/1p00/dailymean"
                  if [ "$nameObs" == "pcp_TRMM" ] ;  then
                      pathObs="$whereobs/$nameObs/1p00"
                  fi
                  echo "yes" $pathObs/${varObs}.day.mean.${tag}.1p00.nc
                  if [ -f $pathObs/${varObs}.day.mean.${tag}.1p00.nc ] ; then

                 case "${season}" in
                      *"DJF"*)
                          if [ $mm1 -ge 12 ] || [ $mm1 -le 2 ] ; then
                             for nameModel in $nameModelA $nameModelB $nameModelC $nameModelD $nameModelE ; do
                                 pathModel="$whereexp/$nameModel/1p00/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.1p00.nc >> ${varModel}-${nameModel}-list.txt
                             done
	                         ls -d -1 $pathObs/${varObs}.day.mean.${tag}.1p00.nc >> ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"MAM"*)
                          if [ $mm1 -ge 3 ] && [ $mm1 -le 5 ] ; then
                             for nameModel in $nameModelA $nameModelB $nameModelC $nameModelD $nameModelE ; do
                                 pathModel="$whereexp/$nameModel/1p00/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.1p00.nc >> ${varModel}-${nameModel}-list.txt
                             done
	                         ls -d -1 $pathObs/${varObs}.day.mean.${tag}.1p00.nc >> ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"JJA"*)
                          if [ $mm1 -ge 6 ] && [ $mm1 -le 8 ] ; then
                             for nameModel in $nameModelA $nameModelB $nameModelC $nameModelD $nameModelE ; do
                                 pathModel="$whereexp/$nameModel/1p00/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.1p00.nc >> ${varModel}-${nameModel}-list.txt
                             done
	                         ls -d -1 $pathObs/${varObs}.day.mean.${tag}.1p00.nc >> ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"SON"*)
                          if [ $mm1 -ge 9 ] && [ $mm1 -le 11 ] ; then
                             for nameModel in $nameModelA $nameModelB $nameModelC $nameModelD $nameModelE ; do
                                 pathModel="$whereexp/$nameModel/1p00/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.1p00.nc >> ${varModel}-${nameModel}-list.txt
                             done
	                         ls -d -1 $pathObs/${varObs}.day.mean.${tag}.1p00.nc >> ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"AllAvailable"*)
                             for nameModel in $nameModelA $nameModelB $nameModelC $nameModelD $nameModelE ; do
                                 pathModel="$whereexp/$nameModel/1p00/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.1p00.nc >> ${varModel}-${nameModel}-list.txt
                             done
	                         ls -d -1 $pathObs/${varObs}.day.mean.${tag}.1p00.nc >> ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                      ;;
                 esac

              fi
           fi
           fi
       done
       done
       done

   echo "A total of $LENGTH ICs are being processed"
   truelength=$LENGTH
echo "landmask: $whereexp/$nameModelA/1p00/dailymean/20120101/land.${nameModelA}.20120101.dailymean.1p00.nc"
# The if below takes care of the situation where there is a single IC by listing it twice (so that it can still be read with "addfiles")
   if [ $LENGTH -eq 1 ] ; then
                             for nameModel in $nameModelA $nameModelB $nameModelC $nameModelD $nameModelE ; do
                              cat ${varModel}-${nameModel}-list.txt ${varModel}-${nameModel}-list.txt > tmp.txt
                              mv tmp.txt ${varModel}-${nameModel}-list.txt
                             done
                              cat ${varModel}-${nameObs}-list.txt ${varModel}-${nameObs}-list.txt > tmp.txt
                              mv tmp.txt ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
   fi
#
   echo "A total of $truelength ICs are being processed"
   LENGTHm1="$(($LENGTH-1))"                          # Needed for counters starting at 0
   s1=0; s2=$LENGTHm1 ; startname="${truelength}ICs"  # Glom together all ICs
   d1=1; d2=34                                        # from day=d1 to day=d1 (counter starting at 0)
   d1p1="$(($d1+1))"                                  # day1 (counter starting at 1)
   d2p1="$(($d2+1))"                                  # day2 (counter starting at 1)

###################################################################################################
#                                            Create ncl script
###################################################################################################

echo $iclist
nclscript="linermse12345_${season}.ncl"                         # Name for the NCL script to be created
cat << EOF > $nclscript

  if isStrSubset("$hardcopy","yes") then
     wks_type                     = "png"
     wks_type@wkWidth             = 3000
     wks_type@wkHeight            = 3000
  else
     wks_type                     = "x11"
     wks_type@wkWidth             = 1200
     wks_type@wkHeight            = 800
  end if 

  wks                          = gsn_open_wks(wks_type,"rmse.${varModel}.${nameModelA}.${nameModelB}.${nameModelC}.${nameModelD}.${nameModelE}.${season}.${startname}.$domain.$mask")

  latStart=${latS}
  latEnd=${latN}
  lonStart=${lonW}
  lonEnd=${lonE}

  if isStrSubset("$domain","Global") then
     lonStart=30
     lonEnd=390
  end if


  ${nameModelA}_list=systemfunc ("awk  '{print} NR==${LENGTH}{exit}' ${varModel}-${nameModelA}-list.txt }") 
  ${nameModelB}_list=systemfunc ("awk  '{print} NR==${LENGTH}{exit}' ${varModel}-${nameModelB}-list.txt }") 
  ${nameModelC}_list=systemfunc ("awk  '{print} NR==${LENGTH}{exit}' ${varModel}-${nameModelC}-list.txt }") 
  ${nameModelD}_list=systemfunc ("awk  '{print} NR==${LENGTH}{exit}' ${varModel}-${nameModelD}-list.txt }") 
  ${nameModelE}_list=systemfunc ("awk  '{print} NR==${LENGTH}{exit}' ${varModel}-${nameModelE}-list.txt }") 
  ${nameObs}_list=systemfunc ("awk  '{print} NR==${LENGTH}{exit}' ${varModel}-${nameObs}-list.txt }") 

  ${nameModelA}_add = addfiles (${nameModelA}_list, "r")   ; note the "s" of addfile
  ${nameModelB}_add = addfiles (${nameModelB}_list, "r")   
  ${nameModelC}_add = addfiles (${nameModelC}_list, "r")   
  ${nameModelD}_add = addfiles (${nameModelD}_list, "r")   
  ${nameModelE}_add = addfiles (${nameModelE}_list, "r")   
  ${nameObs}_add = addfiles (${nameObs}_list, "r")   

  maskMod=addfile("$whereexp/$nameModelA/1p00/dailymean/20120101/land.${nameModelA}.20120101.dailymean.1p00.nc", "r")

  masker=maskMod->LAND_surface(0,:,:)
  masker=where(masker.lt.1,masker,masker@_FillValue)


;---Read variables in "join" mode and print a summary of the variable

  ListSetType (${nameModelA}_add, "join") 
  ListSetType (${nameModelB}_add, "join") 
  ListSetType (${nameModelC}_add, "join") 
  ListSetType (${nameModelD}_add, "join") 
  ListSetType (${nameModelE}_add, "join") 
  ListSetType (${nameObs}_add, "join") 
   
  ${nameModelA}_lat_0=${nameModelA}_add[:]->latitude
  ${nameModelA}_lon_0=${nameModelA}_add[:]->longitude

  ${nameModelA}_fld = ${nameModelA}_add[:]->${ncvarModel}
  ${nameModelB}_fld = ${nameModelB}_add[:]->${ncvarModel}
  ${nameModelC}_fld = ${nameModelC}_add[:]->${ncvarModel}
  ${nameModelD}_fld = ${nameModelD}_add[:]->${ncvarModel}
  ${nameModelE}_fld = ${nameModelE}_add[:]->${ncvarModel}

  if isStrSubset("$nameObs","sst_OSTIA") then
     ${nameObs}_fld = short2flt(${nameObs}_add[:]->${ncvarObs})
  else
     if isStrSubset("$nameObs","TRMM") then
  
       ${nameObs}_fld_toflip = ${nameObs}_add[:]->${ncvarObs}
       ${nameObs}_fld = ${nameObs}_fld_toflip(ncl_join|:,time|:,lat|:,lon|:)
     else
     ${nameObs}_fld = ${nameObs}_add[:]->${ncvarObs}
     end if 
  end if


  lat_0 = ${nameModelA}_lat_0(0,{${latS}:${latN}})
  lon_0 = ${nameModelA}_lon_0(0,{${lonW}:${lonE}})
  nlon=dimsizes(lon_0)
  nlat=dimsizes(lat_0)

  dimsObs=getvardims(${nameObs}_fld)
  dimsModel=getvardims(${nameModelA}_fld)

; Mask out 

  ${nameModelA}_fld=${nameModelA}_fld*${multModel} + 1.*($offsetModel)
  ${nameModelB}_fld=${nameModelB}_fld*${multModel} + 1.*($offsetModel)
  ${nameModelC}_fld=${nameModelC}_fld*${multModel} + 1.*($offsetModel)
  ${nameModelD}_fld=${nameModelD}_fld*${multModel} + 1.*($offsetModel)
  ${nameModelE}_fld=${nameModelE}_fld*${multModel} + 1.*($offsetModel)
  ${nameObs}_fld=${nameObs}_fld*${multObs} + 1.*($offsetObs)

  maskerbig=conform_dims(dimsizes(${nameModelA}_fld),masker,(/2,3/))
  if isStrSubset("$mask","landonly") then
    ${nameObs}_fld=where(ismissing(maskerbig),${nameObs}_fld,${nameObs}_fld@_FillValue)
    ${nameModelA}_fld=where(ismissing(maskerbig),${nameModelA}_fld,${nameModelA}_fld@_FillValue)
    ${nameModelB}_fld=where(ismissing(maskerbig),${nameModelB}_fld,${nameModelB}_fld@_FillValue)
    ${nameModelC}_fld=where(ismissing(maskerbig),${nameModelC}_fld,${nameModelC}_fld@_FillValue)
    ${nameModelD}_fld=where(ismissing(maskerbig),${nameModelD}_fld,${nameModelD}_fld@_FillValue)
    ${nameModelE}_fld=where(ismissing(maskerbig),${nameModelE}_fld,${nameModelE}_fld@_FillValue)
  end if 
  if isStrSubset("$mask","oceanonly") then
    ${nameObs}_fld=where(.not.ismissing(maskerbig),${nameObs}_fld,${nameObs}_fld@_FillValue)
    ${nameModelA}_fld=where(.not.ismissing(maskerbig),${nameModelA}_fld,${nameModelA}_fld@_FillValue)
    ${nameModelB}_fld=where(.not.ismissing(maskerbig),${nameModelB}_fld,${nameModelB}_fld@_FillValue)
    ${nameModelC}_fld=where(.not.ismissing(maskerbig),${nameModelC}_fld,${nameModelC}_fld@_FillValue)
    ${nameModelD}_fld=where(.not.ismissing(maskerbig),${nameModelD}_fld,${nameModelD}_fld@_FillValue)
    ${nameModelE}_fld=where(.not.ismissing(maskerbig),${nameModelE}_fld,${nameModelE}_fld@_FillValue)
  end if 

; limit extent

  ${nameObs}_small=${nameObs}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}})
  ${nameModelA}_small=${nameModelA}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}})
  ${nameModelB}_small=${nameModelB}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}})
  ${nameModelC}_small=${nameModelC}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}})
  ${nameModelD}_small=${nameModelD}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}})
  ${nameModelE}_small=${nameModelE}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}})

; Mean maps

  ${nameModelA}_mean=dim_avg_n_Wrap(${nameModelA}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}}),(/0/))
  ${nameModelB}_mean=dim_avg_n_Wrap(${nameModelB}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}}),(/0/))
  ${nameModelC}_mean=dim_avg_n_Wrap(${nameModelC}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}}),(/0/))
  ${nameModelD}_mean=dim_avg_n_Wrap(${nameModelD}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}}),(/0/))
  ${nameModelE}_mean=dim_avg_n_Wrap(${nameModelE}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}}),(/0/))
  ${nameObs}_mean=dim_avg_n_Wrap(${nameObs}_fld($s1:$s2,:,{${latS}:${latN}},{${lonW}:${lonE}}),(/0/))
  
  ${nameObs}_anom=${nameObs}_small
  ${nameModelA}_anom=${nameModelA}_small
  ${nameModelB}_anom=${nameModelB}_small
  ${nameModelC}_anom=${nameModelC}_small
  ${nameModelD}_anom=${nameModelD}_small
  ${nameModelE}_anom=${nameModelE}_small

  ${nameObs}_anom=${nameObs}_small-conform_dims(dimsizes(${nameObs}_small),${nameObs}_mean, (/1,2,3/))
  ${nameModelA}_anom=${nameModelA}_small-conform_dims(dimsizes(${nameModelA}_small),${nameModelA}_mean, (/1,2,3/))
  ${nameModelB}_anom=${nameModelB}_small-conform_dims(dimsizes(${nameModelB}_small),${nameModelB}_mean, (/1,2,3/))
  ${nameModelC}_anom=${nameModelC}_small-conform_dims(dimsizes(${nameModelC}_small),${nameModelC}_mean, (/1,2,3/))
  ${nameModelD}_anom=${nameModelD}_small-conform_dims(dimsizes(${nameModelD}_small),${nameModelD}_mean, (/1,2,3/))
  ${nameModelE}_anom=${nameModelE}_small-conform_dims(dimsizes(${nameModelE}_small),${nameModelE}_mean, (/1,2,3/))

  ${nameModelA0}_diff=${nameModelA}_mean
  ${nameModelA0}_diff=${nameModelA}_mean-${nameObs}_mean

  ${nameModelB0}_diff=${nameModelB}_mean
  ${nameModelB0}_diff=${nameModelB}_mean-${nameObs}_mean

  ${nameModelC0}_diff=${nameModelC}_mean
  ${nameModelC0}_diff=${nameModelC}_mean-${nameObs}_mean

  ${nameModelD0}_diff=${nameModelD}_mean
  ${nameModelD0}_diff=${nameModelD}_mean-${nameObs}_mean

  ${nameModelE0}_diff=${nameModelE}_mean
  ${nameModelE0}_diff=${nameModelE}_mean-${nameObs}_mean

  ${nameObs}_mean@units="$units"
  ${nameModelA}_mean@units="$units"
  ${nameModelB}_mean@units="$units"
  ${nameModelC}_mean@units="$units"
  ${nameModelD}_mean@units="$units"
  ${nameModelE}_mean@units="$units"
  ${nameModelA0}_diff@units="$units"
  ${nameModelB0}_diff@units="$units"
  ${nameModelC0}_diff@units="$units"
  ${nameModelD0}_diff@units="$units"
  ${nameModelE0}_diff@units="$units"

; area average

  rad    = 4.0*atan(1.0)/180.0
  re     = 6371220.0
  rr     = re*rad

  dlon   = abs(lon_0(2)-lon_0(1))*rr
  dx     = dlon*cos(lat_0*rad)
  dy     = new ( nlat, typeof(dx))
  dy(0)  = abs(lat_0(2)-lat_0(1))*rr
  dy(1:nlat-2)  = abs(lat_0(2:nlat-1)-lat_0(0:nlat-3))*rr*0.5   
  dy(nlat-1)    = abs(lat_0(nlat-1)-lat_0(nlat-2))*rr

  weights2   = dx*dy 
  
   ;weights2  = new((/nlat, nlon/), typeof(${nameModelA}_mean))
   ;weights2  = conform (weights2, dydx, 0)

         opt=0  ; ignore missing values

         ${nameModelA}_aave=wgt_areaave_Wrap(${nameModelA}_mean, weights2,1.0, opt)
         ${nameModelB}_aave=wgt_areaave_Wrap(${nameModelB}_mean, weights2,1.0, opt)
         ${nameModelC}_aave=wgt_areaave_Wrap(${nameModelC}_mean, weights2,1.0, opt)
         ${nameModelD}_aave=wgt_areaave_Wrap(${nameModelD}_mean, weights2,1.0, opt)
         ${nameModelE}_aave=wgt_areaave_Wrap(${nameModelE}_mean, weights2,1.0, opt)

         ${nameModelA0}_aave=wgt_areaave_Wrap(${nameModelA0}_diff, weights2,1.0, opt)
         ${nameModelB0}_aave=wgt_areaave_Wrap(${nameModelB0}_diff, weights2,1.0, opt)
         ${nameModelC0}_aave=wgt_areaave_Wrap(${nameModelC0}_diff, weights2,1.0, opt)
         ${nameModelD0}_aave=wgt_areaave_Wrap(${nameModelD0}_diff, weights2,1.0, opt)
         ${nameModelE0}_aave=wgt_areaave_Wrap(${nameModelE0}_diff, weights2,1.0, opt)

         ${nameObs}_aave=wgt_areaave_Wrap(${nameObs}_mean, weights2,1.0, opt)

         ${nameObs}_reorder=${nameObs}_small( \$dimsObs(1)\$ | :,  \$dimsObs(0)\$ | :, \$dimsObs(2)\$ | : , \$dimsObs(3)\$ | :)
         ${nameModelA}_reorder=${nameModelA}_small( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)
         ${nameModelB}_reorder=${nameModelB}_small( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)
         ${nameModelC}_reorder=${nameModelC}_small( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)
         ${nameModelD}_reorder=${nameModelD}_small( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)
         ${nameModelE}_reorder=${nameModelE}_small( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)

         ${nameModelA}_rmse=wgt_volrmse(${nameObs}_reorder, ${nameModelA}_reorder, 1.0,weights2,1.0, opt)
         ${nameModelB}_rmse=wgt_volrmse(${nameObs}_reorder, ${nameModelB}_reorder, 1.0,weights2,1.0, opt)
         ${nameModelC}_rmse=wgt_volrmse(${nameObs}_reorder, ${nameModelC}_reorder, 1.0,weights2,1.0, opt)
         ${nameModelD}_rmse=wgt_volrmse(${nameObs}_reorder, ${nameModelD}_reorder, 1.0,weights2,1.0, opt)
         ${nameModelE}_rmse=wgt_volrmse(${nameObs}_reorder, ${nameModelE}_reorder, 1.0,weights2,1.0, opt)
 
         
         ${nameObs}_anomreorder=${nameObs}_anom( \$dimsObs(1)\$ | :,  \$dimsObs(0)\$ | :, \$dimsObs(2)\$ | : , \$dimsObs(3)\$ | :)
         ${nameModelA}_anomreorder=${nameModelA}_anom( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)
         ${nameModelB}_anomreorder=${nameModelB}_anom( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)
         ${nameModelC}_anomreorder=${nameModelC}_anom( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)
         ${nameModelD}_anomreorder=${nameModelD}_anom( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)
         ${nameModelE}_anomreorder=${nameModelE}_anom( \$dimsModel(1)\$ | :,  \$dimsModel(0)\$ | :, \$dimsModel(2)\$ | : , \$dimsModel(3)\$ | :)

         ${nameModelA}_anomrmse=wgt_volrmse(${nameObs}_anomreorder, ${nameModelA}_anomreorder, 1.0,weights2,1.0, opt)
         ${nameModelB}_anomrmse=wgt_volrmse(${nameObs}_anomreorder, ${nameModelB}_anomreorder, 1.0,weights2,1.0, opt)
         ${nameModelC}_anomrmse=wgt_volrmse(${nameObs}_anomreorder, ${nameModelC}_anomreorder, 1.0,weights2,1.0, opt)
         ${nameModelD}_anomrmse=wgt_volrmse(${nameObs}_anomreorder, ${nameModelD}_anomreorder, 1.0,weights2,1.0, opt)
         ${nameModelE}_anomrmse=wgt_volrmse(${nameObs}_anomreorder, ${nameModelE}_anomreorder, 1.0,weights2,1.0, opt)
   


  res                     = True
  res@gsnDraw             = False                          ; don't draw
  res@gsnFrame            = False                          ; don't advance frame
  res@xyLineThicknesses = (/10.0, 10.0, 10.0, 10.0, 10.0, 10.0/)          ; make second line thicker
  res@xyLineColors      = (/"black", "blue","red", "purple", "orange" ,"gray"/)          ; change line color
  res@xyExplicitLegendLabels = (/"${nameModelA}", "${nameModelB}", "${nameModelC}","${nameModelD}","${nameModelE}","${nameObs}"/)
 ; res@tiMainString      = "$domain, $season,  $truelength ICs, $mask"       ; add title
  res@gsnYRefLine = 0
  res@gsnXRefLine = (/7,14,21,28,35/)

  res@pmLegendDisplayMode    = "Always"              ; turn on legend
  res@pmLegendSide           = "Right"                 ; Change location of 
 
  res@pmLegendWidthF         = 0.08                  ; Change width and
  res@lgLabelFontHeightF     = .02                   ; change font height
  res@lgPerimOn              = False                 ; no box around

  res0=res
  res1=res
  res2=res

  if (isStrSubset("{$varModel}","Atmpsfc")) then
    res0@trYMinF  = 299  
    res0@trYMaxF  = 300 
    res1@trYMinF  = -0.15 
    res1@trYMaxF  = 0.15
    res2@trYMinF  = 0  
    res2@trYMaxF  = 1 
  end if 
  if (isStrSubset("{$varModel}","At2min")) then
    if (isStrSubset("{$season}", "AJJA")) then
       res0@trYMinF  = 291
       res0@trYMaxF  = 294
       res1@trYMinF  = -1.5 
       res1@trYMaxF  = 1.5
       res2@trYMinF  = 1  
       res2@trYMaxF  = 5 
    else 
       res0@trYMinF  = 288  
       res0@trYMaxF  = 291
       res1@trYMinF  = -1.5 
       res1@trYMaxF  = 1.5
       res2@trYMinF  = 1  
       res2@trYMaxF  = 5 
    end if
  end if
  if (isStrSubset("{$varModel}","At2max")) then
    if (isStrSubset("{$season}", "AJJA")) then
      res0@trYMinF  = 302  
      res0@trYMaxF  = 305 
      res1@trYMinF  = -1.5 
      res1@trYMaxF  = 1.5
      res2@trYMinF  = 1  
      res2@trYMaxF  = 5 
    else
      res0@trYMinF  = 302-2  
      res0@trYMaxF  = 305-2
      res1@trYMinF  = -1.5 
      res1@trYMaxF  = 1.5
      res2@trYMinF  = 1  
      res2@trYMaxF  = 5 
    end if
  end if
  if (isStrSubset("{$varModel}","Aprate")) then
    res0@trYMinF  = 1.
    res0@trYMaxF  = 4.4 
    res1@trYMinF  = -1.5  
    res1@trYMaxF  = 1.5
    res2@trYMinF  = 0  
    res2@trYMaxF  = 15 
  end if
  if (isStrSubset("{$varModel}","Atoa")) then
    res0@trYMinF  = 250  
    res0@trYMaxF  = 275 
    res1@trYMinF  = 0 
    res1@trYMaxF  = 15
    res2@trYMinF  = 15  
    res2@trYMaxF  = 40 
  end if


  plot=new(4,graphic)  

  data0=new((/6,dimsizes(${nameModelA}_aave&time)/),float)
  data0(0,:)=${nameModelA}_aave
  data0(1,:)=${nameModelB}_aave
  data0(2,:)=${nameModelC}_aave
  data0(3,:)=${nameModelD}_aave
  data0(4,:)=${nameModelE}_aave
  data0(5,:)=${nameObs}_aave
  data0@long_name="Area mean, " + "$units"
  data0@units="$units"
  plot(0)=gsn_csm_xy(wks,ispan(1,35,1),data0(:,0:34),res0)

  data1=new((/5,dimsizes(${nameModelA}_aave&time)/),float)
  data1(0,:)=${nameModelA0}_aave
  data1(1,:)=${nameModelB0}_aave
  data1(2,:)=${nameModelC0}_aave
  data1(3,:)=${nameModelD0}_aave
  data1(4,:)=${nameModelE0}_aave
  data1@long_name="Area mean Bias, " + "$units"
  data1@units="$units"
  plot(1)=gsn_csm_xy(wks,ispan(1,35,1),data1(:,0:34),res1)

  data2=new((/5,dimsizes(${nameModelA}_aave&time)/),float)
  data2(0,:)=${nameModelA}_rmse
  data2(1,:)=${nameModelB}_rmse
  data2(2,:)=${nameModelC}_rmse
  data2(3,:)=${nameModelD}_rmse
  data2(4,:)=${nameModelE}_rmse
  data2@long_name="Raw RMSE, " + "$units"
  data2@units="$units"
  plot(2)=gsn_csm_xy(wks,ispan(1,35,1),data2(:,0:34),res2)

  data3=new((/5,dimsizes(${nameModelA}_aave&time)/),float)
  data3(0,:)=${nameModelA}_anomrmse
  data3(1,:)=${nameModelB}_anomrmse
  data3(2,:)=${nameModelC}_anomrmse
  data3(3,:)=${nameModelD}_anomrmse
  data3(4,:)=${nameModelE}_anomrmse
  data3@long_name="Bias-corrected RMSE, "  + "$units"
  data3@units="$units"
  plot(3)=gsn_csm_xy(wks,ispan(1,35,1),data3(:,0:34),res2)

  panelopts                   = True
  panelopts@gsnPanelMainString = "$domain, $mask, ${varModel}, $season,  $truelength ICs"

  panelopts@amJust   = "TopLeft"
  panelopts@gsnOrientation    = "landscape"
  panelopts@gsnPanelLabelBar  = False
  panelopts@gsnPanelRowSpec   = True
  panelopts@gsnMaximize       = True                          ; maximize plot in frame
  panelopts@gsnBoxMargin      = 0
  panelopts@gsnPanelYWhiteSpacePercent = 0
  panelopts@gsnPanelXWhiteSpacePercent = 5
  panelopts@amJust   = "TopLeft"
  gsn_panel(wks,plot,(/2,2/),panelopts)


EOF

ncl linermse12345_${season}.ncl



