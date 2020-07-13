    # Start/end delimiters for initial conditions
        ystart=2012; yend=2016;  ystep=4
        mstart=1;    mend=12;    mstep=100
        dstart=1;    dend=15;     dstep=1400

    # Name and location of experiment output on HPSS

        #sub=control
        #exp_old=ufs_p4_${sub}

        #sub=skebspptca_seed
        #sub=wavesoff_control
        #sub=skebsppt_seed
        #sub=skebspptca_seed
        #sub=caglobal_seed
        sub=onlyca_seed

        exp_new=ufs_p4_${sub}


        hpss_root=/NCEPDEV/emc-climate/1year/Lydia.B.Stefanova/HERA/scratch/${sub}  # point to the location on hpss

    
        # Local directories for upload and storage of results

        upload_root=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/JTTI_p4/             # store uploaded data here

        processed_root=/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/JTTI_p4/          # store processed data here 

    # Currently only res=1p00 fully supported
        res=1p00
        #res=Orig

