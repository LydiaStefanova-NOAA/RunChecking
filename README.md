The scripts in this directory are intended for comparing the biases of two prototype runs for a set of ICs that is common to both and falls within a range specified in the settings (common_settings.sh).

Biases are calculated in reference to observations that have been previously prepared and reside in subdirectories within obs_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/ReferenceData/

To run the whole process (from obtaining data from HPSS to producing image),

- Specify settings: common_settings.sh, graph_settings.sh
- Get files from HPSS: sbatch get_exp.sh
- Go from individual 6-hourly grib2 files to one netcdf with daily values: sbatch drive_preprocess.sh # (uses preprocess.sh)
- Plot maps of average bias and difference: sbatch drive_mapobs.sh   # (uses map_compare_obs.sh)
- Produce line plots of area mean values, area mean bias, RMSE and bias-corrected RMSE: sbatch drive_anoms.sh

Note that the last two steps generate a number of ncl and txt files - if not interested in the contents, clean up manually.
