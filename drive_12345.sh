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

   #sub=wavesoff_control
   exp1=ufs_p4_wavesoff_control

        #sub=skebspptca_seed
        #sub=skebsppt_seed
        #sub=onlyca_seed
        #sub=skebspptca_seed
        sub=caglobal_seed

   exp2=ufs_p4_${sub}1
   exp3=ufs_p4_${sub}2
   exp4=ufs_p4_${sub}3
   exp5=ufs_p4_${sub}4

   whereexp=$processed_root
   whereobs=$obs_root
   domain=Global20

   echo $whereexp $exp2

for season in "${season[@]}" ; do
        #bash anoms12345.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 nameModelC=$exp3 nameModelD=$exp4 nameModelE=$exp5 ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep realmask=landonly
        #bash anoms12345.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 nameModelC=$exp3 nameModelD=$exp4 nameModelE=$exp5 ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep realmask=oceanonly
    for varname in tmpsfc ; do
        bash anoms12345.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 nameModelC=$exp3 nameModelD=$exp4 nameModelE=$exp5 ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep realmask=oceanonly
    done
    for varname in prate; do
        bash anoms12345.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 nameModelC=$exp3 nameModelD=$exp4 nameModelE=$exp5 ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep realmask=nomask

    done
 done

