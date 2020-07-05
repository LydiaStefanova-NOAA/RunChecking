#!/bin/bash 
#SBATCH --ntasks=1 -p service 
#SBATCH -q debug
#SBATCH -t 00:30:00 
#SBATCH -A ome 
#SBATCH -J jtti-b4-getfiles

module load hpss
source common_settings.sh

for seed in 1 2 3 4 5 6 7 8 9 10 ; do

#for seed in ""; do
for exp in $exp_new ; do

    upload_location=${upload_root}/${exp}${seed}

    for (( yyyy=$ystart; yyyy<=$yend; yyyy+=$ystep )) ; do
    for (( mm1=$mstart; mm1<=$mend; mm1+=$mstep )) ; do
    for (( dd1=$dstart; dd1<=$dend; dd1+=$dstep )) ; do

        mm=$(printf "%02d" $mm1)
        dd=$(printf "%02d" $dd1)
        tag=$yyyy$mm${dd}00

        if [ ! -f ${upload_location}/$tag/gfs.$yyyy$mm$dd/00/gfs.t00z.flux.1p00.f840 ] ; then 

        #if [ ! -f ${upload_location}/$tag/gfs.$yyyy$mm$dd/00/gfs.t00z.sfluxgrbf840.grib2 ] ; then

           hpss_location=${hpss_root}${seed}/$tag
           atmflux1p00=gfs_flux_1p00.tar

           #atmflux1p00=gfs_flux.tar

           mkdir -p ${upload_location}/$tag
           cd ${upload_location}/$tag

           echo "working on $tag for $exp$seed"
           echo htar -xvf ${hpss_location}/$atmflux1p00
           htar -xvf ${hpss_location}/$atmflux1p00
           echo "done with  $tag for $exp$seed"
           #htar -xvf ${hpss_location}/$atmfluxOrig

        else
           echo "$exp $tag$seed  already uploaded" 
        fi
    done
    done
    done
done
done
