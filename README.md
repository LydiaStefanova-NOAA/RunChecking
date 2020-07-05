**Step 0**
- Acquire data from HPSS: `Prep/get_exp.sh`
- Convert hourly grib files to a single file per IC with 35 daily values: `Prep/drive_preprocess.sh` (invokes `preprocess.sh`)

**Objective A** 

Plot the biases of two experiment runs for a set of ICs that is common to both. 
Biases are calculated in reference to observations that have been previously prepared and reside in subdirectories within `obs_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/ReferenceData/`
- Produce maps of average bias and difference: `WithObs/Maps/drive_map_obs.sh`   # (invokes `map_compare_obs.sh`)

**Objective B**
- Produce line plots of area mean values, area mean bias, RMSE and bias-corrected RMSE: `WithObs/Maps/drive_anoms.sh` # (invokes `anoms12.sh`)

**Note** that the scripts generate a number of ncl and txt files - if not interested in the contents, clean up manually.
Also note that `drive_map_obs.sh` and `drive_anoms.sh` expect 35-day long netcdf files with daily values from two experiments (exp1 and exp2) for various ICs (prepared in Step 0); The subdirectories for exp1 and exp2 are expected in a common directory (e.g. `/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/`).


