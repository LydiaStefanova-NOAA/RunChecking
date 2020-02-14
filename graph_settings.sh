# Settings for graphical comparison of biases
#

   source common_settings.sh   
   
  
   hardcopy=no           # Valid choices are yes no      
   domain=Global50       # Valid choices see line 47 (case "$domain" list) in map_compare_obs.sh
                         # NB: keep in mind that verifying obs for tmpsfc (OSTIA SST) are not valid in ice-covered areas
        
   declare -a var=("tmpsfc" "prate" "ulwrftoa")     # Valid choices are "tmpsfc" "prate" "ulwrftoa" "tmp2m" "t2min" "t2max" 
   declare -a season=("DJF" "JJA")                  # Valid choices are "DJF" "MAM" "JJA" "SON" "AllAvailable"

   obs_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/ReferenceData/    # Location of OBS: changing it is not recommended
   res=1p00                                                               # Resolution: currently only 1p00 supported


