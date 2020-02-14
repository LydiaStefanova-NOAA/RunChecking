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

   whereexp=$processed_root
   whereobs=$obs_root

# The scripts are prepared to handle variables on the list below 


for season in "${season[@]}" ; do
    for varname in ulwrftoa prate; do
        domain=NP
        bash anoms12.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=nomask
    done
    for varname in tmpsfc ; do
        domain=Global20
        bash anoms12.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=oceanonly
    done
    for varname in t2max t2min; do
        domain=Global20
        bash anoms12.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2  ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=landonly
    done
 done
