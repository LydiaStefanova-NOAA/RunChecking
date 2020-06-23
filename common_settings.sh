    # Start/end delimiters for initial conditions
        ystart=2011; yend=2018;  ystep=1
        mstart=1;    mend=12;    mstep=1
        dstart=1;    dend=15;     dstep=14

    # Name and location of experiment output on HPSS

        #exp_old=ufs_b31_control_seed1           # name to assign to experiment ("." or "-" NOT OK in the name)
        #sub=control_seed3
        #exp_new=ufs_b31_$sub      # name to assign to experiment ("." or "-" NOT OK in the name)

        exp_new=ufs_p4_pre
        hpss_root=/NCEPDEV/emc-climate/5year/Jessica.Meixner/WCOSS/scratch/preUFSp4/c384/
        hpss_root=/NCEPDEV/emc-climate/5year/Jiande.Wang/WCOSS/scratch/preUFSp4/c384


        #exp_new=ufs_p4_base
        #hpss_root=/NCEPDEV/emc-climate/5year/Jessica.Meixner/WCOSS/scratch/UFSp4_base/c384/

        #exp_new=heratest
        #hpss_root=/NCEPDEV/emc-climate/1year/Jessica.Meixner/HERA/scratch/test_3d

    
        # Local directories for upload and storage of results
          upload_root=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/             # store uploaded data here
          #upload_root=/scratch2/NCEPDEV/climate/Jiande.Wang/z-GEFS-IC/OUTPUT-2017080100
          processed_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/          # store processed data here 

    # Currently only res=1p00 supported
        res=1p00
        #res=Orig

