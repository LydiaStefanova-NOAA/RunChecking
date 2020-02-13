#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30
#
#
# This is a tiny little package that compares two sets of (exp1 and exp2) for a chosen variable, domain, season
# top directory with preprocessed files 

    whereexp=$noscrub/Models
    whereobs=$noscrub/ReferenceData
    
    
    hardcopy=yes                        # yes | no

    ystart=2011
    yend=2018

    mstart=1
    mend=12
    mstep=3

    exp1=ufs_b3
    exp2=ufs_b31


    domain=Global50                      # Global | Global50 | GlobalTropics | Nino3.4 | NAM | CONUS 
    domain=CONUS
    domain=GlobalTropics
    domain=Global20
    season=AllAvailable                  # DJF | MAM | JJA | SON | AllAvailable 

# The scripts are prepared to handle variables on the list below 
    oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx )
     for season in AllAvailable ; do
    # for varname in t2min t2max ulwrftoa; do
     for varname in tmpsfc ; do

     #domain=GlobalTropics      
     domain=Global50
     bash map_compare_obs.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep d1=0 d2=0
     bash map_compare_obs.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep d1=14 d2=27

     #domain=Global      
     #for varname in t2min t2max prate ulwrftoa; do
     #bash map_compare_obs.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep d1=1 d2=7
     #bash map_compare_obs.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp1 nameModelB=$exp2 ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep d1=14 d2=27
     #done

     done
     done

