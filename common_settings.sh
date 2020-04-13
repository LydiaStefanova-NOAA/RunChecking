    # Start/end delimiters for initial conditions
<<<<<<< HEAD
        ystart=2011; yend=2018;  ystep=1
        mstart=1;    mend=12;    mstep=1
        dstart=1;    dend=15;     dstep=14
=======
        ystart=2012; yend=2013;  ystep=1
        mstart=1;    mend=12;    mstep=3
        dstart=1;    dend=1;     dstep=14        # to use ICs starting on the 1st and 15th, set dstart=1; dend=15; dstep=14
>>>>>>> f397f9ad1194440814569d3595484e511e85020f

    # Name and location of experiment output on HPSS

        #exp_old=ufs_b31_control_seed1           # name to assign to experiment ("." or "-" NOT OK in the name)
        #sub=control_seed3
        #exp_new=ufs_b31_$sub      # name to assign to experiment ("." or "-" NOT OK in the name)

        exp_old=ufs_b31
        exp_new=ufs_b33

        #hpss_root=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS/benchmark3.1/c384/  # point to the location on hpss
        #hpss_root=/NCEPDEV/emc-climate/1year/Lydia.B.Stefanova/HERA/scratch/$sub  # point to the location on hpss

        hpss_root=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS/benchmark3.3/c384

    
        # Local directories for upload and storage of results
          upload_root=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/             # store uploaded data here
          #upload_root=/scratch2/NCEPDEV/climate/Jiande.Wang/z-GEFS-IC/OUTPUT-2017080100
          processed_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/          # store processed data here 

    # Currently only res=1p00 supported
        res=1p00
        #res=Orig

