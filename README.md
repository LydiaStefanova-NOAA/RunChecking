First, specify settings by editing
    
    common_settings.sh
   
Second, get files from HPSS

    sbatch get_exp.sh

Third, extract desired variables and convert to daily

    sbatch drive_preprocess.sh # (uses preprocess.sh)

Fourth, specify graphical analysis settings by specifying

    graph_settings.sh
    
Fifth, plot maps of average bias and difference

    sbatch drive_mapobs.sh   # (uses map_compare_obs.sh)

Note that the last step generates a number of ncl and txt files - if not interested in the contents, clean up manually.
