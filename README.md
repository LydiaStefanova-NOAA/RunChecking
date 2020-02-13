RunChecking
First, get files from HPSS

get_b31.sh

Second, extract desired variables and convert to 1x1

drive_preprocess.sh # (uses preprocess.sh)

Third, plot maps of average bias and difference

drive_mapobs.sh   # (uses map_compare_obs.sh)
