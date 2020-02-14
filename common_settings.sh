    # Start/end delimiters for initial conditions
        ystart=2012; yend=2013;  ystep=1
        mstart=1;    mend=12;    mstep=3
        dstart=1;    dend=1;     dstep=14        # to use ICs starting on the 1st and 15th, set dstart=1; dend=15; dstep=14

    # Name and location of experiments

        exp1=ufs_b3                                                                # name to assign to experiment ("." or "-" NOT OK in the name
        hpss_root1=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS/benchmark3/c384/   # point to the location on hpss

        exp2=ufs_b31                                                                # name to assign to experiment ("." or "-" NOT OK in the name
        hpss_root2=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS/benchmark3.1/c384/  # point to the location on hpss
    
    # Other locations
        upload_root=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/             # store uploaded data here
        processed_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/          # store processed data here 

