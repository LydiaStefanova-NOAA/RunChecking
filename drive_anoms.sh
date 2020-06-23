#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30
#

   module load intel/19.0.5.281
   module load ncl

   source graph_settings.sh 

   exp_old=ufs_b31
   exp_new=ufs_p4_base

   whereexp=$processed_root
   whereobs=$obs_root

for season in "${season[@]}" ; do

    for varname in tmpsfc ; do
        for domain in Global20 Global50 Nino3.4 ; do
            bash anoms12.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new  ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=oceanonly
        done
    done

    for varname in t2max t2min; do
        for domain in CONUS Global20 Global50; do
           bash anoms12.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new  ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=landonly

        done
     done
    for varname in ulwrftoa ; do
         for domain in SP NP Global20 Global50; do
             bash anoms12.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new  ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=nomask
         done
    done

    for varname in prate ; do
        for domain in Global20 Global50 Nino3.4 ; do
            bash anoms12.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new  ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=nomask
        done
    done

 done

