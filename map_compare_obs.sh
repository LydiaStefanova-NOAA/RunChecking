#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q batch             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 120               # -t specifies walltime in minutes; if in debug, cannot be more than 30


for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    #ystart=2011
    #yend=2018

    #mstart=1
    #mend=12

    case "$KEY" in
            whereexp)   whereexp=${VALUE} ;;
            whereobs)   whereobs=${VALUE} ;;
            hardcopy)   hardcopy=${VALUE} ;;
            domain)     domain=${VALUE} ;;  
            varModel)   varModel=${VALUE} ;;   
            season)     season=${VALUE} ;;   
            nameModelA) nameModelA=${VALUE} ;;
            nameModelB) nameModelB=${VALUE} ;;
            ystart)     ystart=${VALUE};;
            yend)       yend=${VALUE};;
            mstart)     mstart=${VALUE};;
            mend)       mend=${VALUE};;
            mstep)      mstep=${VALUE};;
            d1)         d1=${VALUE};;
            d2)         d2=${VALUE};;
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
          #nameObs="pcp_CPC_Global";  varObs="rain"; ncvarObs="rain"; multObs=0.1; offsetObs=0.; mask="landonly"
          nameObs="pcp_TRMM";  varObs="pcp_TRMM"; ncvarObs="precipitation"; multObs=1; offsetObs=0.; mask="nomask"
       fi
       if [ "$varModel" == "ulwrftoa" ] ; then
          ncvarModel="ULWRF_topofatmosphere"; multModel=1.; offsetModel=0.; units="W/m^2"; mask="nomask"
		  nameObs="olr_HRIS"; varObs="ulwrftoa"; ncvarObs="olr"; multObs=1.; offsetObs=0.; units="W/m^2"; mask="nomask"
       fi
          nameModelBA=${nameModelB}_minus_${nameModelA}
          nameModelB0=${nameModelA}_minus_${nameObs}
          nameModelA0=${nameModelB}_minus_${nameObs}

       rm ${varModel}-${nameModelA}-list.txt ${varModel}-${nameModelB}-list.txt    # clean up from last time
       rm ${varModel}-${nameObs}-list.txt

       LENGTH=0
       pass=0
       for (( yyyy=$ystart; yyyy<=$yend; yyyy+=1 )) ; do
       for (( mm1=$mstart; mm1<=$mend; mm1+=$mstep )) ; do
       for dd1 in {1..15..14} ; do
           mm=$(printf "%02d" $mm1)
           dd=$(printf "%02d" $dd1)
           tag=$yyyy$mm${dd}

           #echo "$whereexp/$nameModelA/1p00/dailymean/${tag}/${varModel}.${nameModelA}.${tag}.dailymean.1p00.nc"

           if [ -f $whereexp/$nameModelA/1p00/dailymean/${tag}/${varModel}.${nameModelA}.${tag}.dailymean.1p00.nc ] ; then
              if [ -f $whereexp/$nameModelB/1p00/dailymean/${tag}/${varModel}.${nameModelB}.${tag}.dailymean.1p00.nc ] ; then
                  pathObs="$whereobs/$nameObs/1p00/dailymean"
                  if [ ! -d $pathObs ] ; then
                     pathObs="$whereobs/$nameObs/1p00/"
                  fi
           #       echo $pathObs/${varObs}.day.mean.${tag}.1p00.nc
                  if [ -f $pathObs/${varObs}.day.mean.${tag}.1p00.nc ] ; then

                 case "${season}" in
                      *"DJF"*)
                          if [ $mm1 -ge 12 ] || [ $mm1 -le 2 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                                 pathModel="$whereexp/$nameModel/1p00/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.1p00.nc >> ${varModel}-${nameModel}-list.txt
                             done
	                     ls -d -1 $pathObs/${varObs}.day.mean.${tag}.1p00.nc >> ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"MAM"*)
                          if [ $mm1 -ge 3 ] && [ $mm1 -le 5 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                                 pathModel="$whereexp/$nameModel/1p00/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.1p00.nc >> ${varModel}-${nameModel}-list.txt
                             done
	                     ls -d -1 $pathObs/${varObs}.day.mean.${tag}.1p00.nc >> ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"JJA"*)
                          if [ $mm1 -ge 6 ] && [ $mm1 -le 8 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                                 pathModel="$whereexp/$nameModel/1p00/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.1p00.nc >> ${varModel}-${nameModel}-list.txt
                             done
	                     ls -d -1 $pathObs/${varObs}.day.mean.${tag}.1p00.nc >> ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"SON"*)
                          if [ $mm1 -ge 9 ] && [ $mm1 -le 11 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                                 pathModel="$whereexp/$nameModel/1p00/dailymean"
                                 ls -d -1 $pathModel/${tag}/${varModel}.${nameModel}.${tag}.dailymean.1p00.nc >> ${varModel}-${nameModel}-list.txt
                             done
	                         ls -d -1 $pathObs/${varObs}.day.mean.${tag}.1p00.nc >> ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
                          fi
                      ;;
                      *"AllAvailable"*)
                             for nameModel in $nameModelA $nameModelB ; do
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
   truelength=$LENGTH
   if [ $LENGTH -eq 1 ] ; then
                             for nameModel in $nameModelA $nameModelB ; do
                              cat ${varModel}-${nameModel}-list.txt ${varModel}-${nameModel}-list.txt > tmp.txt
                              mv tmp.txt ${varModel}-${nameModel}-list.txt
                             done
                              cat ${varModel}-${nameObs}-list.txt ${varModel}-${nameObs}-list.txt > tmp.txt
                              mv tmp.txt ${varModel}-${nameObs}-list.txt
                                 LENGTH="$(($LENGTH+1))"                       # How many ICs are considered
   fi
   echo "A total of $truelength ICs are being processed"


   LENGTHm1="$(($LENGTH-1))"                        # Needed for counters starting at 0
   ic1=0; ic2=$LENGTHm1 ; startname="${truelength}ICs"  # Glom together all ICs
   d1p1="$(($d1+1))"                                #  (counter starting at 1)
   d2p1="$(($d2+1))"

###################################################################################################
#                                            Create ncl script
###################################################################################################

echo $iclist
nclscript="bias_${season}.ncl"                         # Name for the NCL script to be created
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

  wks                          = gsn_open_wks(wks_type,"biasmaps.${varModel}.${nameModelB}.vs.${nameModelA}.${season}.${startname}.$domain.d${d1p1}-d${d2p1}")

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
  ${nameObs}_list=systemfunc ("awk  '{print} NR==${LENGTH}{exit}' ${varModel}-${nameObs}-list.txt }") 

  ${nameModelA}_add = addfiles (${nameModelA}_list, "r")   ; note the "s" of addfile
  ${nameModelB}_add = addfiles (${nameModelB}_list, "r")   
  ${nameObs}_add = addfiles (${nameObs}_list, "r")   

  maskMod=addfile("$whereexp/${nameModelA}/1p00/dailymean/20120101/land.${nameModelA}.20120101.dailymean.1p00.nc", "r")
  masker=maskMod->LAND_surface(0,{${latS}:${latN}},{${lonW}:${lonE}})
  masker=where(masker.ne.1,masker,masker@_FillValue)


;---Read variables in "join" mode and print a summary of the variable

  ListSetType (${nameModelA}_add, "join") 
  ListSetType (${nameModelB}_add, "join") 
  ListSetType (${nameObs}_add, "join") 
   
  ${nameModelA}_lat_0=${nameModelA}_add[:]->latitude
  ${nameModelA}_lon_0=${nameModelA}_add[:]->longitude

  ${nameModelA}_fld = ${nameModelA}_add[:]->${ncvarModel}
  ${nameModelB}_fld = ${nameModelB}_add[:]->${ncvarModel}
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

  timeObs = ${nameObs}_add[:]->time
  timeModel = ${nameModelA}_add[:]->time
  dateObs=cd_calendar(timeObs,3)
  dateModel=cd_calendar(timeModel,3)

  ;print(dimsizes(dateObs))

  ;print(dateObs)
  ;print(getvardimnames(${nameObs}_fld))


  lat_0 = ${nameModelA}_lat_0(0,{${latS}:${latN}})
  lon_0 = ${nameModelA}_lon_0(0,{${lonW}:${lonE}})
  nlon=dimsizes(lon_0)
  nlat=dimsizes(lat_0)
  timesize=dimsizes(timeObs)

  nstarts=timesize(0)
  ndays=timesize(1)

  

; Mean maps

  ${nameModelA}_mean=dim_avg_n_Wrap(${nameModelA}_fld($ic1:$ic2,$d1:$d2,{${latS}:${latN}},{${lonW}:${lonE}}),(/0,1/))
  ${nameModelB}_mean=dim_avg_n_Wrap(${nameModelB}_fld($ic1:$ic2,$d1:$d2,{${latS}:${latN}},{${lonW}:${lonE}}),(/0,1/))
  ${nameObs}_mean=dim_avg_n_Wrap(${nameObs}_fld($ic1:$ic2,$d1:$d2,{${latS}:${latN}},{${lonW}:${lonE}}),(/0,1/))

  ${nameModelA}_mean=${nameModelA}_mean*${multModel} + 1.*($offsetModel)
  ${nameModelB}_mean=${nameModelB}_mean*${multModel} + 1.*($offsetModel)
  ${nameObs}_mean=${nameObs}_mean*${multObs} + 1.*($offsetObs)

  ${nameModelA0}_diff=${nameModelA}_mean
  ${nameModelA0}_diff=${nameModelA}_mean-${nameObs}_mean

  ${nameModelB0}_diff=${nameModelB}_mean
  ${nameModelB0}_diff=${nameModelB}_mean-${nameObs}_mean

  ${nameModelBA}_diff=${nameModelA}_mean
  ${nameModelBA}_diff=${nameModelB}_mean-${nameModelA}_mean

  if isStrSubset("$mask","landonly") then
    ${nameModelA}_mean=where(ismissing(masker),${nameModelA}_mean,${nameModelA}_mean@_FillValue)
    ${nameModelB}_mean=where(ismissing(masker),${nameModelB}_mean,${nameModelB}_mean@_FillValue)
    ${nameModelA0}_diff=where(ismissing(masker),${nameModelA0}_diff,${nameModelA0}_diff@_FillValue)
    ${nameModelB0}_diff=where(ismissing(masker),${nameModelB0}_diff,${nameModelB0}_diff@_FillValue)
    ${nameModelBA}_diff=where(ismissing(masker),${nameModelBA}_diff,${nameModelBA}_diff@_FillValue)
  end if 
  if isStrSubset("$mask","oceanonly") then
    ${nameModelA}_mean=where(.not.ismissing(masker),${nameModelA}_mean,${nameModelA}_mean@_FillValue)
    ${nameModelB}_mean=where(.not.ismissing(masker),${nameModelB}_mean,${nameModelB}_mean@_FillValue)
    ${nameModelA0}_diff=where(.not.ismissing(masker),${nameModelA0}_diff,${nameModelA0}_diff@_FillValue)
    ${nameModelB0}_diff=where(.not.ismissing(masker),${nameModelB0}_diff,${nameModelB0}_diff@_FillValue)
    ${nameModelBA}_diff=where(.not.ismissing(masker),${nameModelBA}_diff,${nameModelBA}_diff@_FillValue)
  end if 

  ${nameObs}_mean@units="$units"
  ${nameModelA}_mean@units="$units"
  ${nameModelB}_mean@units="$units"
  ${nameModelA0}_diff@units="$units"
  ${nameModelB0}_diff@units="$units"
  ${nameModelBA}_diff@units="$units"

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
  
         opt=0  ; ignore missing values
         ${nameModelA}_aave=wgt_areaave_Wrap(${nameModelA}_mean, weights2,1.0, opt)
         ${nameModelB}_aave=wgt_areaave_Wrap(${nameModelB}_mean, weights2,1.0, opt)
         ${nameModelA0}_aave=wgt_areaave_Wrap(${nameModelA0}_diff, weights2,1.0, opt)
         ${nameModelB0}_aave=wgt_areaave_Wrap(${nameModelB0}_diff, weights2,1.0, opt)
         ${nameModelBA}_aave=wgt_areaave_Wrap(${nameModelBA}_diff, weights2,1.0, opt)
         ${nameObs}_aave=wgt_areaave_Wrap(${nameObs}_mean, weights2,1.0, opt)

         ${nameModelA}_rmsd=wgt_arearmse(${nameObs}_mean,${nameModelA}_mean,weights2,1.0, opt)
         ${nameModelB}_rmsd=wgt_arearmse(${nameObs}_mean,${nameModelB}_mean,weights2,1.0, opt)
         ${nameModelBA}_rmsd=wgt_arearmse(${nameModelA}_mean,${nameModelB}_mean,weights2,1.0, opt)
       
         tf=True  ;round off, not truncate
         ndig=3
         ${nameModelA}_aave=decimalPlaces(${nameModelA}_aave,ndig,tf)
         ${nameModelB}_aave=decimalPlaces(${nameModelB}_aave,ndig,tf)
         ${nameModelA0}_aave=decimalPlaces(${nameModelA0}_aave,ndig,tf)
         ${nameModelB0}_aave=decimalPlaces(${nameModelB0}_aave,ndig,tf)
         ${nameModelBA}_aave=decimalPlaces(${nameModelBA}_aave,ndig,tf)
         ${nameObs}_aave=decimalPlaces(${nameObs}_aave,ndig,tf)

         ${nameModelA}_rmsd=decimalPlaces(${nameModelA}_rmsd,ndig,tf)
         ${nameModelB}_rmsd=decimalPlaces(${nameModelB}_rmsd,ndig,tf)
         ${nameModelBA}_rmsd=decimalPlaces(${nameModelBA}_rmsd,ndig,tf)

   

  ${nameObs}_mean@long_name=${nameModelA}_mean@long_name + " " + "${nameObs}" +"; mean=" + ${nameObs}_aave
  ${nameModelA}_mean@long_name=${nameModelA}_mean@long_name + " " + "${nameModelA}" +"; mean=" + ${nameModelA}_aave
  ${nameModelB}_mean@long_name=${nameModelB}_mean@long_name + " " + "${nameModelB}" +"; mean=" + ${nameModelB}_aave
  ;${nameModelA0}_diff@long_name="Bias" + " " + "${nameModelA}" + "; mean=" + ${nameModelA0}_aave + "; rmsd=" + ${nameModelA}_rmsd
  ;${nameModelB0}_diff@long_name="Bias" + " " + "${nameModelB}" + "; mean=" + ${nameModelB0}_aave + "; rmsd=" + ${nameModelB}_rmsd
  ${nameModelA0}_diff@long_name="Bias" + " " + "${nameModelA}" + "; mean=" + ${nameModelA0}_aave 
  ${nameModelB0}_diff@long_name="Bias" + " " + "${nameModelB}" + "; mean=" + ${nameModelB0}_aave 
  ${nameModelBA}_diff@long_name="Bias" + " " + "${nameModelBA}" + "; mean=" + ${nameModelBA}_aave 

  plot=new(9,graphic)

  res                     = True
  if (isStrSubset("$domain","CONUS").or.isStrSubset("$domain","NAM").or.isStrSubset("$domain","IndoChina")) then
     res@gsnAddCyclic        = False
  end if
  res@gsnDraw             = False                          ; don't draw
  res@gsnFrame            = False                          ; don't advance frame
  res@cnFillOn             = True               ; turns on the color
  res@mpFillOn             = False              ; turns off continent gray
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnFillMode          = "RasterFill"

  res@mpCenterLonF        = (lonStart+lonEnd)/2
  res@mpMinLatF           = latStart
  res@mpMaxLatF           = latEnd
  res@mpMinLonF           = lonStart
  res@mpMaxLonF           = lonEnd

  res@mpGridAndLimbOn        = True
  res@mpShapeMode            = "FreeAspect"
  res@vpWidthF               = 0.8
  res@vpHeightF              = 0.4
  res@mpGridLineDashPattern  = 5                  ; lat/lon lines dashed
  res@mpGridLatSpacingF      = 30
  res@mpGridLonSpacingF      = 30
  res@mpGridLineColor        = "Gray30"

  res@cnLevelSelectionMode="ManualLevels"

  res0=res
  res1=res
  res2=res

  if (isStrSubset("{$varModel}","cloud")) then
       cmap=read_colormap_file("MPL_gnuplot")
       cmap = cmap(::-1,:)
       res0@cnFillPalette = cmap
       res0@cnMinLevelValF  = 10.
       res0@cnMaxLevelValF  = 90.
       res0@cnLevelSpacingF  = 10.

       res1@cnFillPalette        = "sunshine_diff_12lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
       res1@cnFillColors         = (/ 11,  10,   9,    8,   7,  6,  5,  4,  3,    2,  1/)  ; set the colors to be used


       res2=res1
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
       res2@cnFillColors         = (/ 11,  10,   9,    8,   7,  6,  5,  4,  3,    2,  1/)  ; set the colors to be used
  end if

  if (isStrSubset("{$varModel}","shtfl")) then
       res0@cnMinLevelValF  = -40.
       res0@cnMaxLevelValF  = 120.
       res0@cnLevelSpacingF  = 20.

       res1@cnFillPalette        = "temp_diff_18lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -50., -30., -20.,-10.,-5., 5. ,10. ,20. ,30. , 50./)   ; set levels

       res2@cnFillPalette        = "temp_diff_18lev"
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if
       
  if (isStrSubset("{$varModel}","2m")) then
      res0@cnMinLevelValF  = 220.
      res0@cnMaxLevelValF  = 310.
      res0@cnLevelSpacingF  = 10.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -5., -3., -2.,-1.,-0.5, 0.5 ,1. ,2. ,3. , 5./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if 


  if (isStrSubset("{$varModel}","10")) then
      res0@cnMinLevelValF  = -10.
      res0@cnMaxLevelValF  = 10.
      res0@cnLevelSpacingF  = 2.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -4., -3., -2.,-1.,-0.5, -0.2, -0.1, 0.1, 0.2, 0.5 ,1. ,2., 3., 4./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if
  if (isStrSubset("{$varModel}","pres")) then
      res0@cnMinLevelValF  = 500.
      res0@cnMaxLevelValF  = 1000.
      res0@cnLevelSpacingF  = 50.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -5., -3., -2.,-1.,-0.5, -0.2, -0.1, 0.1, 0.2, 0.5 ,1. ,2., 3., 5./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if
  if (isStrSubset("{$varModel}","tmpsfc")) then
      res0@cnMinLevelValF  = 220.
      res0@cnMaxLevelValF  = 310.
      res0@cnLevelSpacingF  = 10.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -10., -5., -2.,-1.,-0.5, -0.2, -0.1, 0.1, 0.2, 0.5 ,1. ,2., 5., 10./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset("{$varModel}","prate").or.isStrSubset("{$varModel}","lhtfl")) then
      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 0.01, 0.1, 0.2, 0.5,  1,   2, 4,   8, 16, 32  /)   ; set levels

      res1@cnFillPalette="CBR_drywet"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/  -4, -2.,-1.,-0.5,-0.1, 0.1, 0.5 ,1. ,2., 4 /)   ; set levels

      res2@cnFillPalette="CBR_drywet"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset("{$varModel}","snod")) then

      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 0.01, 0.1, 0.2, 0.3, 0.5,  1,  1.5 /)   ; set levels

      res1@cnFillPalette="CBR_drywet"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/   -1.,-0.5, -0.2,-0.1,-0.05, 0.05, 0.1, 0.2, 0.5 ,1.  /)   ; set levels

      res2@cnFillPalette="CBR_drywet"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset("{$varModel}","pwat")) then
      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 1, 2, 4, 8, 16, 32, 64  /)   ; set levels

      res1@cnFillPalette="CBR_drywet"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/  -4, -2.,-1.,-0.5,-0.1, 0.1, 0.5 ,1. ,2., 4 /)   ; set levels

      res2@cnFillPalette="CBR_drywet"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset("{$varModel}","snow")) then
      res0@cnFillPalette="GMT_drywet"
      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 0.5,  1, 5, 10, 20, 40, 60, 95/)   ; set levels

      res1@cnFillPalette="CBR_drywet"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -50., -25., -10., -5.,-1., 1.,5., 10., 25., 50. /)   ; set levels

      res2@cnFillPalette="CBR_drywet"
      res2@cnMinLevelValF  = -100.
      res2@cnMaxLevelValF  = 100.
      res2@cnLevelSpacingF  = 20.
  end if

  if (isStrSubset("{$varModel}","wrf")) then
       cmap=read_colormap_file("MPL_gnuplot")
       res0@cnFillPalette = cmap
       res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res0@cnLevels             = (/20., 40., 80., 100., 150., 200., 300., 400.,500. /)   ; set levels
       if (isStrSubset("{$varModel}","ulwrftoa")) then
           res0@cnLevels         = (/120., 140., 180., 200., 220., 240., 260., 280.,300. /)   ; set levels
       end if

       res1@cnFillPalette        = "sunshine_diff_12lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels

       res2=res1
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if 

  plot(0) = gsn_csm_contour_map(wks,${nameObs}_mean,res0)

  plot(3) = gsn_csm_contour_map(wks,${nameModelA}_mean,res0)
  plot(4) = gsn_csm_contour_map(wks,${nameModelA0}_diff,res1)

  plot(6) = gsn_csm_contour_map(wks,${nameModelB}_mean,res0)
  plot(7) = gsn_csm_contour_map(wks,${nameModelB0}_diff,res1)
  plot(8) = gsn_csm_contour_map(wks,${nameModelBA}_diff,res1)


  panelopts                   = True
  panelopts@gsnPanelMainString = "${varModel}, $season, day ${d1p1} - day ${d2p1},  $truelength ICs"
  panelopts@amJust   = "TopLeft"
  panelopts@gsnOrientation    = "landscape"
  panelopts@gsnPanelLabelBar  = False
  panelopts@gsnPanelRowSpec   = True
  panelopts@gsnMaximize       = True                          ; maximize plot in frame
  panelopts@gsnBoxMargin      = 0
  panelopts@gsnPanelYWhiteSpacePercent = 0
  panelopts@gsnPanelXWhiteSpacePercent = 5
  panelopts@amJust   = "TopLeft"
  ;gsn_panel(wks,plot,(/3,3/),panelopts)
  gsn_panel(wks,plot,(/3,3,3/),panelopts)

EOF

ncl bias_${season}.ncl



