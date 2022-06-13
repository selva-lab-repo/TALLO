 <img src="https://github.com/selva-lab-repo/TALLO/blob/48d7cd593391e0695ca06b61ed364878bb4f771f/Ancillary/Tallo%20logo.jpg" align="left" width=250/> TALLO - a global tree allometry and crown architecture database
======================================================================================================
![license](https://img.shields.io/badge/Licence-GPL--3-blue.svg) 

This repository contains source data for the Tallo database, a global database for measurements of tree allometry and crown architecture. See also the forthcoming publication: *Jucker et al. (2022). Tallo - a global tree allometry and crown architecture database. Global Change Biology (in press)*. 

It contains two separate data sets:

### DB 

The main, unmodified database, and metadata files. 


- **Tallo.csv**: the Tallo database itself (zipped)
- **Tallo_metadata.csv**: a metadata file describing the fields of the Tallo.csv file
- **Reference_look_up_table.csv**: a look-up table matching reference ID codes in the Tallo.csv file to the original source of the data
    
### Jucker et al. 2022

The database, as used in the associated publication. 


- **R code to replicate case studies.R**: the R code that replicates the case studies in Jucker et al. (2022) GCB
- **Tallo_environment.csv**: environmental data layers for each tree in the Tallo.csv file needed to replicate the case studies in Jucker et al. (2022) GCB (zipped)
- **Tallo_environment_metadata.csv**: a metadata file describing the fields of the Tallo_environment.csv
- **current_climate.csv**: current-day climate data layers at 5-arc minute spatial resolution needed to replicate case study 3 in Jucker et al. (2022) GCB (zipped)
- **future_climate_ssp245.csv**: projected climate data layers at 5-arc minute spatial resolution needed to replicate case study 3 in Jucker et al. (2022) GCB (zipped)
