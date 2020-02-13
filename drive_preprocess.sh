#!/bin/bash -l
#SBATCH -A fv3-cpu
#SBATCH --job-name=preprocess
#SBATCH --partition=hera
#SBATCH -t 4:00:00                 # -t specifies walltime in minutes; if in debug, cannot be more than 30
#SBATCH --nodes=1

module load intel/19.0.5.281
module load nco
module load cdo
module load wgrib2


# This is a driver script that specifies the settings preprocess.sh
# It takes 1x1 surface grib files from $wherefrom/$exp/${yyyy}${mm}${dd}00/gfs.$yyyy$mm$dd/00/gfs.t00z.flux.1p00.f$hhh and creates
# netcdf timeseries for select variables in $whereexp/$exp/1p00/6hourly and $whereexp/$exp/1p00/dailymean

    # Experiment name
    exp=ufs_b31

    # years/months to extract
    ystart=2011; yend=2018
    mstart=1; mend=12; mstep=1

    # Resolution (bias comparison needs 1p00)
    res=1p00

    # Directory with 1x1 surface grib files files uploaded from HPSS with structure $wherefrom/${yyyy}${mm}${dd}00/gfs.$yyyy$mm$dd/00/ 
    wherefrom=$scratch/fromHPSS/${exp}

    # Destination directory for preprocessed files
    whereto=$noscrub/Models/${exp}/${res}
    mkdir -p $whereto

#--------------------------- GENERALLY, DO NOT CHANGE BELOW ------------------------------------------


# The scripts are prepared to handle variables on the list below:

    oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx )

    for varname in land tmpsfc t2max t2min prate ulwrftoa ; do

        case "${oknames[@]}" in 
                 *"$varname"*)  ;; 
                 *)
                 echo "Exiting. To continue, please correct: unknown variable ---> $varname <---"
                 exit
        esac

        # Prepare data; if the preprocessing is already done it will not be redone
        bash preprocess.sh exp=$exp varname=$varname wherefrom=$wherefrom whereto=$whereto res=$res ystart=$ystart yend=$yend mstart=$mstart mend=$mend mstep=$mstep
    done


