#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30

module load intel/19.0.5.281
module load ncl
source graph_settings.sh

whereexp=$processed_root
whereobs=$obs_root
domain=Global50
domain=Global
#domain=Nino3.4
#exp_new=ufs_p4_pre
exp_old=ufs_b31
exp_new=ufs_p4_base

#varname=tmpsfc
#varname=prate
hardcopy=no


 Start/end delimiters for initial conditions
      ystart=2011; yend=2018;  ystep=1
      mstart=1;    mend=12;    mstep=3
      dstart=1;    dend=15;     dstep=15

#for season in "${season[@]}" ; do
for season in AllAvailable ; do
#   for varname in "${var[@]}" ; do
#    for varname in t2min t2max ulwrftoa ; do
    #for varname in tmpsfc tmp2m prate ulwrftoa ; do
    for varname in tmp2m tmpsfc; do

     for day in 1 2 3 4 5 ; do
       bash map_compare_obs2.sh whereexp=$whereexp  whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new ystart=$ystart yend=$yend ystep=$ystep  mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep d1=$day d2=$day
       #bash map_compare_obs2.sh whereexp=$whereexp  whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new ystart=$ystart yend=$yend  ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep d1=10 d2=19
       #bash map_compare_obs2.sh whereexp=$whereexp  whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new ystart=$ystart yend=$yend  ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep d1=20 d2=29
   done
done
done

