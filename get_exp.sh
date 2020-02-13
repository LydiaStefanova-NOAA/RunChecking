#!/bin/bash 
#SBATCH --ntasks=1 -p service 
#SBATCH -t 12:00:00 
#SBATCH -A fv3-cpu
#SBATCH -q batch 
#SBATCH -J b31-getfiles

module load hpss
source settings.sh
for exp in $exp1 $exp2 ; do
    upload_location=${upload_root}/${exp}
    for (( yyyy=$ystart; yyyy<=$yend; yyyy+=$ystep )) ; do
    for (( mm1=$mstart; mm1<=$mend; mm1+=$mstep )) ; do
    for (( dd1=$dstart; dd1<=$dend; dd1+=$dstep )) ; do
        mm=$(printf "%02d" $mm1)
        dd=$(printf "%02d" $dd1)
        tag=$yyyy$mm${dd}00
        if [ ! -f ${upload_location}/$tag/gfs.$yyyy$mm$dd/00/gfs.t00z.flux.1p00.f840 ] ; then 
           hpss_location=${hpss_root}/$tag
           atmflux1p00=gfs_flux_1p00.tar
           echo "Working on $tag for $exp"
           mkdir -p ${upload_location}/$tag
           cd ${upload_location}/$tag
           htar -xvf ${hpss_location}/$atmflux1p00
        else
           echo "$exp $tag  already uploaded" 
        fi
    done
    done
    done
done
