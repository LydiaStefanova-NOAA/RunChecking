**Objective A**: Plot area mean from surface flux grib2 files for a single run

Use `singlerun.sh`. It uploads from a specified directory in HPSS a set of grib2 files for the surface fluxes. From these, a few variables are extracted, concatenated into a single file for a 35-day-long forecast, and converted to netcdf. The script also generates a ncl script that can be used to plot an area mean of (currently) t2min, t2max, t2m, tmpsfc over a specified domain. (Before running `ncl newtestplot.ncl`, it is necessary to `module load intel/19.0.5.281` and `module load ncl`  )


**Objective B**: Comparing the biases of two experiment runs for a set of ICs that is common to both

Biases are calculated in reference to observations that have been previously prepared and reside in subdirectories within `obs_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/ReferenceData/`

To run the whole process (from obtaining data from HPSS to producing image(s)),

- Specify settings: edit `common_settings.sh`, `graph_settings.sh`
- Get files from HPSS: `sbatch get_exp.sh`
- Go from individual 6-hourly grib2 files to one netcdf with daily values: `sbatch drive_preprocess.sh` # (invokes *preprocess.sh*)
- Produce maps of average bias and difference: `drive_mapobs.sh`   # (invokes *map_compare_obs.sh*)
- Produce line plots of area mean values, area mean bias, RMSE and bias-corrected RMSE: `drive_anoms.sh` # (invokes *anoms12.sh*)

Note that the last two steps generate a number of ncl and txt files - if not interested in the contents, clean up manually.

Also note that drive_mapobs.sh and drive_anoms.sh expect 35-day long netcdf files with daily values from two experiments (exp1 and exp2) for various ICs; The subdirectories for exp1 and exp2 are expected in the same directory.


