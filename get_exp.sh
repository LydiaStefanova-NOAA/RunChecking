#!/bin/bash 
#SBATCH --ntasks=1 -p service 
#SBATCH -t 12:00:00 
#SBATCH -A fv3-cpu
#SBATCH -q batch 
#SBATCH -J b31-getfiles


exp=b31                                                                        # name to assign to experiment; AVOID PUNCTUATION
hpss_location=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS/benchmark3.1/c384/  # point to the location of exp on hpss


module load hpss
rundir=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/ufs_${exp}

for yyyy in {2011..2018..1} ; do
   for mm in {1..12..1} ; do
       mm=$(printf "%02d" $mm)
       for dd in {1..15..14} ; do
           dd=$(printf "%02d" $dd)
           tag=$yyyy$mm${dd}00
              if [ ! -d $rundir ] ; then mkdir $rundir ; fi
              if [ ! -f $rundir/$tag/gfs.$yyyy$mm$dd/00/gfs.t00z.flux.1p00.f840 ] ; then #if the last hour already extracted, skip
                 cd $rundir
                 echo working on $tag

                 base=${hpss_location}/$tag

                 atmflux1p00=$base/gfs_flux_1p00.tar
                 sst=$base/SST.tar
                 pgrb2b=$base/gfs_pgrb2b.tar
                 atmflux=$base/gfs_flux.tar
                 ocean=$base/ocn.tar
                 ice=$base/ice.tar

                 if [ ! -d $tag ] ; then
                   mkdir $tag
                 fi

                 cd $tag
                 htar -xvf $atmflux1p00
   
              else 
                  echo "skipping $tag"
              fi
       done
   done
done
