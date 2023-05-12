#!/bin/bash

#PBS -q cpu
#PBS -l select=1:ncpus=1:mem=20GB
#PBS -o output/
#PBS -e output/

module load scientific/wrf/4.3.3-gnu

# change to working dir
cd $PBS_O_WORKDIR

# edit namelist.wps
sed -i "s|WPS_GEOG_PATH|'${WPS_HOME}/WPS_GEOG'|" namelist.wps
sed -i "s|GEOGRID_PATH|'${WPS_HOME}/geogrid'|" namelist.wps
sed -i "s|METGRID_PATH|'${WPS_HOME}/metgrid'|" namelist.wps

# wps
ln -sf $WPS_HOME/ungrib/Variable_Tables/Vtable.GFS Vtable
link_grib.csh matthew/fnl_
ungrib.exe
geogrid.exe
metgrid.exe
