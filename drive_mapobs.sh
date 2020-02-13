#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30

module load intel/19.0.5.281
module load ncl
source common_settings.sh
source graph_settings.sh

whereexp=$processed_root
whereobs=$obs_root

for season in "${season[@]}" ; do
   for varname in "${var[@]}" ; do
       bash map_compare_obs.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 ystart=$ystart yend=$yend ystep=$ystep  mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep d1=0 d2=0
       bash map_compare_obs.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 ystart=$ystart yend=$yend  ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep d1=14 d2=27
   done
done

