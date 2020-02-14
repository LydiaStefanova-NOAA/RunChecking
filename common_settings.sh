    # Start/end delimiters for initial conditions
        ystart=2011; yend=2018;  ystep=1
        mstart=1;    mend=12;    mstep=1
        dstart=1;    dend=15;     dstep=14

    # Name and location of experiment output on HPSS

        exp_old=ufs_b3                                                                # name to assign to experiment ("." or "-" NOT OK in the name
        exp_new=ufs_b31                                                                # name to assign to experiment ("." or "-" NOT OK in the name
        hpss_root=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS/benchmark3.1/c384/  # point to the location on hpss

    
    # Local directories for upload and storage of results
        upload_root=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/             # store uploaded data here
        processed_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/          # store processed data here 

    # Currently only res=1p00 supported
        res=1p00

