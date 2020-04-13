#!/bin/bash -l
#SBATCH -A fv3-cpu
#SBATCH --job-name=preprocess
#SBATCH --partition=hera
#SBATCH -q batch
#SBATCH -t 03:30:00                 # if in debug, cannot be more than 00:30:00
#SBATCH --nodes=1

module load intel/19.0.5.281
module load nco
module load cdo
module load wgrib2
source common_settings.sh
exp_new=ufs_b33


# The scripts are prepared to handle variables on the list below:
oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx soill01d soill14d soill41m soill12m tsoil01d tsoil14d tsoil41m tsoil12mo soilm02m)
for exp in $exp_new ; do
    wherefrom=${upload_root}/${exp}
    whereto=${processed_root}/${exp}/${res}
    mkdir -p $whereto
    for varname in land tmpsfc tmp2m t2max t2min prate ulwrftoa soilm02m ; do
        case "${oknames[@]}" in 
             *"$varname"*)  ;; 
             *)
             echo "Exiting. To continue, please correct: unknown variable ---> $varname <---"
             exit
        esac
        bash preprocess.sh exp=$exp varname=$varname wherefrom=$wherefrom whereto=$whereto res=$res ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep
done
done


