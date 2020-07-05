#!/bin/bash -l
#SBATCH -A marine-cpu
#SBATCH --job-name=preprocess
#SBATCH --partition=hera
#SBATCH -q debug
#SBATCH -t 00:30:00                 # if in debug, cannot be more than 00:30:00
#SBATCH --nodes=1

    # Start/end delimiters for initial conditions

        ystart=2011; yend=2018;  ystep=1
        mstart=1;    mend=12;    mstep=1
        dstart=1;    dend=15;    dstep=14

    # Name and location of experiment output on HPSS

        exp_new=ufs_b33
        upload_root=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/                # store uploaded data here
        processed_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/
        res=1p00                                                                       # currently the only resolution implemented

    # Specify list of variables to preprocess (turn from 6-hourly grib2 into a 35-day series of daily netcdf)

        declare -a varlist=( "icetk" ) 

    # The plotting scripts are prepared to handle variables on the list below:

        oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx soill01d soill14d soill41m soill12m tsoil01d tsoil14d tsoil41m tsoil12mo soilm02m sfcr)


#====================================================================================================
for exp in $exp_new ; do
    wherefrom=${upload_root}/${exp}
    whereto=${processed_root}/${exp}/${res}
    mkdir -p $whereto
    for varname in ${varlist[@]} ; do
        case "${oknames[@]}" in 
             *"$varname"*)  ;; 
             *)
             echo "Exiting. To continue, please correct: plotting not implemented for variable ---> $varname <---"
             exit
        esac
        bash preprocess.sh exp=$exp varname=$varname wherefrom=$wherefrom whereto=$whereto res=$res ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep
done
done

