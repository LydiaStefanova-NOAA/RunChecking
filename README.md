First, specify settings by editing
    
    settings.sh
   
Second, get files from HPSS

    sbatch get_exp.sh

Third, extract desired variables and convert to daily

    sbatch drive_preprocess.sh # (uses preprocess.sh)

Fourth, plot maps of average bias and difference

    sbatch drive_mapobs.sh   # (uses map_compare_obs.sh)
