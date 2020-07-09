#!/bin/bash -l
#SBATCH -A marine-cpu        # -A specifies the account
#SBATCH -n 1                 # -n specifies the number of tasks (cores) (-N would be for number of nodes) 
#SBATCH --exclusive          # exclusive use of node - hoggy but OK
#SBATCH -q debug             # -q specifies the queue; debug has a 30 min limit, but the default walltime is only 5min, to change, see below:
#SBATCH -t 30                # -t specifies walltime in minutes; if in debug, cannot be more than 30
#
    # Start/end delimiters for initial conditions

        ystart=2012; yend=2012;  ystep=1
        mstart=1;    mend=1;    mstep=1
        dstart=1;    dend=1;     dstep=14

    # Name and location of experiment and obs (data as 35-day time series in netcdf)

        obs_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/ReferenceData/    # Location of OBS: changing it is not recommended
        exp_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/JTTI_p4/   # Location of OBS: changing it is not recommended

        whereexp=$exp_root
        whereobs=$obs_root

        exp_old=ufs_p4_wavesoff_control
        exp_new=ufs_p4_onlyca_seed
        exp_new=ufs_p4_skebsppt_seed
        #exp_new=ufs_p4_caglobal_seed

        res=1p00

    # Other specitications


        hardcopy=no         # Valid choices are yes no      
                            # NB: keep in mind that verifying obs for tmpsfc (OSTIA SST) are not valid for ice-covered areas because tmpsfc there is not sst

        declare -a varlist=( "t2min" "tmpsfc" )            # Valid choices for comparison with OBS are "tmpsfc" "prate" "ulwrftoa" "tmp2m" "t2min" "t2max" 
        declare -a seasonlist=( "DJF" )     # Valid choices are "DJF" "MAM" "JJA" "SON" "AllAvailable"



for season in "${seasonlist[@]}" ; do
    for varname in tmpsfc; do
        for domain in Global20  ; do
            bash anoms_seed.sh whereexp=$whereexp whereobs=$whereobs varModel=$varname domain=$domain hardcopy=$hardcopy season=$season nameModelA=$exp_old nameModelB=$exp_new  ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep mask=oceanonly
        done
    done

 done

