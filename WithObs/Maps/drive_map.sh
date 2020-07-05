#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30

    # Start/end delimiters for initial conditions

        ystart=2011; yend=2018;  ystep=1
        mstart=1;    mend=12;    mstep=1
        dstart=1;    dend=15;     dstep=14

    # Name and location of experiment and obs (data as 35-day time series in netcdf)

        obs_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/ReferenceData/    # Location of OBS: changing it is not recommended
        exp_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/            # Location of OBS: changing it is not recommended
        whereexp=$exp_root
        whereobs=$obs_root

        exp_old=ufs_b31
        exp_new=ufs_p4_pre
        res=1p00

    # Other specitications


        nplots=3      #valid choices are 9 or 3  
   
        mapscript=map_compare_obs.sh    # choices map_compare_obs.sh, map_compare_noobs.sh, map_compare_polar.sh
        hardcopy=no         # Valid choices are yes no      
        domain=Global       # Valid choices see [case "$domain" list] in mapping script
                            # NB: keep in mind that verifying obs for tmpsfc (OSTIA SST) are not valid for ice-covered areas because tmpsfc there is not sst
        
        declare -a varlist=( "prate" )            # Valid choices for comparison with OBS are "tmpsfc" "prate" "ulwrftoa" "tmp2m" "t2min" "t2max" 
        declare -a seasonlist=( "DJF" "JJA" )     # Valid choices are "DJF" "MAM" "JJA" "SON" "AllAvailable"


        for season in ${seasonlist[@]} ; do
        for varname in ${varlist[@]}; do

        for day in 1  ; do
            echo "using $mapscript"
            bash $mapscript whereexp=$whereexp  whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new ystart=$ystart yend=$yend ystep=$ystep  mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep d1=$day d2=$day  nplots=$nplots
   done
done
done
