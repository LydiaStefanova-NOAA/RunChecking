The scripts in this directory are intended for comparing the biases of two prototype runs for a set of ICs that is common to both and falls within a range specified in the settings (common_settings.sh).

Biases are calculated in reference to observations that have been previously prepared and reside in subdirectories within obs_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/ReferenceData/



To run the whole process (from obtaining data from HPSS to producing image):

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
