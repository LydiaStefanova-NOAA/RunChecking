'reinit'
obs='/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/ReferenceData/pcp_TRMM/1p00/dailymean/pcp_TRMM.day.mean.'
obs='pcp-TRMM.'; factor = 86400
varobs='prate'
obs='sst_OSTIA.day.mean.'; factor=1
varobs='analysed_sst'

base='/scratch2/NCEPDEV/climate/Lydia.B.Stefanova/Models/JTTI_p4'
control='ufs_p4_wavesoff_control'
exp.1='ufs_p4_skebsppt_seed'
exp.2='ufs_p4_skebspptca_seed'
exp.3='ufs_p4_caglobal_seed'
exp.4='ufs_p4_onlyca_seed'

vrange=2
nseed=10
var='tmpsfc'
varname='tmp'
color=2
laby=6

i=1
while (i <= 4)
exp=exp.i
i = i+1

year=2012
while (year<2013)

   'sdfopen 'base'/'control'/1p00/dailymean/'year'0101/'var'.'control'.'year'0101.dailymean.1p00.nc'
   seed=1
   while (seed<=nseed)
      'sdfopen 'base'/'exp''seed'/1p00/dailymean/'year'0101/'var'.'exp''seed'.'year'0101.dailymean.1p00.nc'
      seed=seed+1
   endwhile
   'sdfopen 'obs''year'0101.1p00.shift.nc'  

     t1=1; t2=35
     lonW=190; lonE=240
     latS=-5; latN=5
*     lonW=190; lonE=280
     lonW=0; lonE=360
     latS=-30; latN=30
     'set t 't1' 't2' '
     'set lat 'latS' 'latN' '
     'set lon 'lonW' 'lonE' '

* For OBS
  'set dfile 12'
     'undefine mask'
     'define mask=mask'
     'define obs=maskout('varobs',1-mask)'
*     'define obs='varobs''
* Define CONTROL
  'set dfile 1'
     'define control=maskout('varname'_surface.1, 1-mask)*'factor''
*     'define control='varname'_surface.1*'factor''
* Define SEEDS 
     seed=1
     while (seed<=10)
       'define seed'seed'=maskout('varname'_surface.'seed+1',1-mask)*'factor''
*       'define seed'seed'='varname'_surface.'seed+1'*'factor''
        seed=seed+1
     endwhile
* Define MEAN
  'define ensmean=(seed1+seed2+seed3+seed4+seed5+seed6+seed7+seed8+seed9+seed10)/(10.)'
* Define variance
  'define seedterma=pow(seed1-ensmean,2) + pow(seed2-ensmean,2) + pow(seed3-ensmean,2)  + pow(seed4-ensmean,2)  + pow(seed5-ensmean,2) '
  'define seedtermb=pow(seed6-ensmean,2) + pow(seed7-ensmean,2) + pow(seed8-ensmean,2)  + pow(seed9-ensmean,2)  + pow(seed10-ensmean,2) '
  'define seedstd=((seedterma+seedtermb)/(10.))'

* PLOT

'set dfile 1'
'set t 't1' 't2' '
'set x 1'; 'set y 1'

'define seedts=sqrt(aave(seedstd,lon='lonW',lon='lonE',lat='latS',lat='latN'))'

'define rms=sqrt(aave((ensmean-obs)*(ensmean-obs),lon='lonW',lon='lonE',lat='latS',lat='latN'))'
'define rmsctrl=sqrt(aave((control-obs)*(control-obs),lon='lonW',lon='lonE',lat='latS',lat='latN'))'


'set xaxis 1 35 7'; 'set vrange 0 'vrange''
'set xlopts 1 3 0.2'; 'set ylopts 1 3 0.2'
'set cstyle 4'
'set cthick 12'; 'set ccolor 'color''; 'set cmark 0'; 'd seedts'
'set cstyle 1'; 'set ccolor 'color'' ;'set cmark 0'; 'd rms'

'set strsiz 0.2'
*'set string 1 l 12'; 'draw string 3 1.5  Area-Averaged Ensemble Spread for Precip'; 'draw string 3 1.0 lon='lonW',lon='lonE',lat='latS',lat='latN' '
'set string 'color' l 12'; 'draw string 3 'laby' 'year'0101 'exp''
'set cstyle 1'; 'set ccolor 1' ;'set cmark 0'; 'd rmsctrl'
'set string 1 l 12'; 'draw string 3 5.6 'year'0101 control'

color=color+1
laby=laby+0.4
year=year+4
allclose
endwhile
endwhile
'set string 1 l 12'; 'draw string 3 4.6  solid: RMSE, dashed: spread'; 'draw title SST lon='lonW',lon='lonE',lat='latS',lat='latN' '
*'printim GT30.SST.'year-4'.png'
