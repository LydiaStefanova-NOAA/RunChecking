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
source common_settings.sh


# The scripts are prepared to handle variables on the list below:
oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx )
for exp in $exp1 $exp2 ; do
    wherefrom=${upload_root}/${exp}
    whereto=${processed_root}/${exp}/${res}
    mkdir -p $whereto
    for varname in land tmpsfc t2max t2min prate ulwrftoa ; do
        case "${oknames[@]}" in 
             *"$varname"*)  ;; 
             *)
             echo "Exiting. To continue, please correct: unknown variable ---> $varname <---"
             exit
        esac
        bash preprocess.sh exp=$exp varname=$varname wherefrom=$wherefrom whereto=$whereto res=$res ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep
done
done


