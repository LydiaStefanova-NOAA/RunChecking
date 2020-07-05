procedure setcolors (varname)

begin
  if (isStrSubset(varname,"cloud")) then
       cmap=read_colormap_file("MPL_gnupmeModelA}_fldlot")
       cmap = cmap(::-1,:)
       res0@cnFillPalette = cmap
       res0@cnMinLevelValF  = 10.
       res0@cnMaxLevelValF  = 90.
       res0@cnLevelSpacingF  = 10.

       res1@cnFillPalette        = "sunshine_diff_12lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
       res1@cnFillColors         = (/ 11,  10,   9,    8,   7,  6,  5,  4,  3,    2,  1/)  ; set the colors to be used


       res2@cnFillPalette        = "sunshine_diff_12lev"
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
       res2@cnFillColors         = (/ 11,  10,   9,    8,   7,  6,  5,  4,  3,    2,  1/)  ; set the colors to be used

  end if

  if (isStrSubset(varname,"shtfl")) then
       res0@cnMinLevelValF  = -40.
       res0@cnMaxLevelValF  = 120.
       res0@cnLevelSpacingF  = 20.

       res1@cnFillPalette        = "temp_diff_18lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -50., -30., -20.,-10.,-5., 5. ,10. ,20. ,30. , 50./)   ; set levels

       res2@cnFillPalette        = "temp_diff_18lev"
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if
       
  if (isStrSubset(varname,"2m")) then
      res0@cnMinLevelValF  = 220.
      res0@cnMaxLevelValF  = 310.
      res0@cnLevelSpacingF  = 10.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -5., -3., -2.,-1.,-0.5, 0.5 ,1. ,2. ,3. , 5./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if 


  if (isStrSubset(varname,"10")) then
      res0@cnMinLevelValF  = -10.
      res0@cnMaxLevelValF  = 10.
      res0@cnLevelSpacingF  = 2.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -4., -3., -2.,-1.,-0.5, -0.2, -0.1, 0.1, 0.2, 0.5 ,1. ,2., 3., 4./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if
  if (isStrSubset(varname,"pres")) then
      res0@cnMinLevelValF  = 500.
      res0@cnMaxLevelValF  = 1000.
      res0@cnLevelSpacingF  = 50.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -5., -3., -2.,-1.,-0.5, -0.2, -0.1, 0.1, 0.2, 0.5 ,1. ,2., 3., 5./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if
  if (isStrSubset(varname,"tmpsfc")) then
      res0@cnMinLevelValF  = 220.
      res0@cnMaxLevelValF  = 310.
      res0@cnLevelSpacingF  = 10.

      res1@cnFillPalette        = "temp_diff_18lev"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -10., -5., -2.,-1.,-0.5, -0.2, -0.1, 0.1, 0.2, 0.5 ,1. ,2., 5., 10./)   ; set levels

      res2@cnFillPalette        = "temp_diff_18lev"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset(varname,"prate").or.isStrSubset(varname,"lhtfl")) then
      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 0.01, 0.1, 0.2, 0.5,  1,   2, 4,   8, 16, 32  /)   ; set levels

      res1@cnFillPalette="CBR_drywet"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/  -4, -2.,-1.,-0.5,-0.1, 0.1, 0.5 ,1. ,2., 4 /)   ; set levels

      res2@cnFillPalette="CBR_drywet"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset(varname,"snod")) then

      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 0.01, 0.1, 0.2, 0.3, 0.5,  1,  1.5 /)   ; set levels

      res1@cnFillPalette="CBR_drywet"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/   -1.,-0.5, -0.2,-0.1,-0.05, 0.05, 0.1, 0.2, 0.5 ,1.  /)   ; set levels

      res2@cnFillPalette="CBR_drywet"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset(varname,"pwat")) then
      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 1, 2, 4, 8, 16, 32, 64  /)   ; set levels

      res1@cnFillPalette="CBR_drywet"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/  -4, -2.,-1.,-0.5,-0.1, 0.1, 0.5 ,1. ,2., 4 /)   ; set levels

      res2@cnFillPalette="CBR_drywet"
      res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if

  if (isStrSubset(varname,"snow")) then
      res0@cnFillPalette="GMT_drywet"
      res0@cnFillPalette="CBR_wet"
      res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res0@cnLevels             = (/ 0.5,  1, 5, 10, 20, 40, 60, 95/)   ; set levels

      res1@cnFillPalette="CBR_drywet"
      res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res1@cnLevels             = (/ -50., -25., -10., -5.,-1., 1.,5., 10., 25., 50. /)   ; set levels

      res2@cnFillPalette="CBR_drywet"
      res2@cnMinLevelValF  = -100.
      res2@cnMaxLevelValF  = 100.
      res2@cnLevelSpacingF  = 20.
  end if

  if (isStrSubset(varname,"wrf")) then
       cmap=read_colormap_file("MPL_gnuplot")
       res0@cnFillPalette = cmap
       res0@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res0@cnLevels             = (/20., 40., 80., 100., 150., 200., 300., 400.,500. /)   ; set levels
       if (isStrSubset(varname,"ulwrftoa")) then
           res0@cnLevels         = (/120., 140., 180., 200., 220., 240., 260., 280.,300. /)   ; set levels
       end if

       res1@cnFillPalette        = "sunshine_diff_12lev"
       res1@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res1@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels

       res2=res1
       res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
       res2@cnLevels             = (/ -40., -20., -10.,-5.,-2., 2. ,5. ,10. ,20. , 40./)   ; set levels
  end if 

  return ( [/res0,res1,res2/])
end