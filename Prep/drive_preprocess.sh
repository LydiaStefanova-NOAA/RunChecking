#!/bin/bash -l
#SBATCH -A ome
#SBATCH --job-name=preprocess
#SBATCH --partition=hera
#SBATCH -q debug 
#SBATCH -t 30 
#SBATCH --nodes=1

module load intel/19.0.5.281
module load nco
module load cdo
module load wgrib2
source common_settings.sh

ystart=2012; yend=2016;  ystep=4
mstart=1;    mend=12;    mstep=100
dstart=1;    dend=15;     dstep=1400



exp=$exp_new

#for seed in 1 2 3 4 5 6 7 8 9 10 ; do
for seed in 1 2 3 4 5 6 7 8 9 10  ; do
#for seed in ""; do

# The scripts are prepared to handle variables on the list below:
oknames=(land tmpsfc tmp2m t2min t2max ulwrftoa dlwrf dswrf ulwrf uswrf prate pwat icetk icec cloudbdry cloudlow cloudmid cloudhi snow weasd snod lhtfl shtfl pres u10 v10 uflx vflx soill01d soill14d soill41m soill12m tsoil01d tsoil14d tsoil41m tsoil12mo soilm02m)


    wherefrom=${upload_root}/${exp}${seed}
    whereto=${processed_root}/${exp}${seed}/${res}
    mkdir -p $whereto
        for varname in land tmpsfc t2max t2min prate ; do
        #for varname in soilm02m ; do
        case "${oknames[@]}" in 
             *"$varname"*)  ;; 
             *)
             echo "Exiting. To continue, please correct: unknown variable ---> $varname <---"
             exit
        esac
        bash preprocess.sh exp=$exp$seed varname=$varname wherefrom=$wherefrom whereto=$whereto res=$res ystart=$ystart yend=$yend ystep=$ystep mstart=$mstart mend=$mend mstep=$mstep dstart=$dstart dend=$dend dstep=$dstep
done
done


