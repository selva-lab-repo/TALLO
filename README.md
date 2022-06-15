 <img src="https://github.com/selva-lab-repo/TALLO/blob/48d7cd593391e0695ca06b61ed364878bb4f771f/Ancillary/Tallo%20logo.jpg" align="left" width=250/> TALLO - a global tree allometry and crown architecture database
======================================================================================================
![license](https://img.shields.io/badge/Licence-GPL--3-blue.svg) 

This is the repository of the Tallo database, a global collection of georeferenced and taxonomically standardized records of individual trees for which stem diameter, height and/or crown radius have been measured. For a full description of the database, see: *Jucker et al. (2022). Tallo - a global tree allometry and crown architecture database. Global Change Biology, doi:10.1111/GCB.16302* (https://onlinelibrary.wiley.com/doi/abs/10.1111/gcb.16302). If using the Tallo database in your work please cite the original publication listed above.

The repository contains two separate data sets:

### DB

The Tallo database itself, along with its associatedand metadata files:

- **Tallo.csv**: the Tallo database (zipped)
- **Tallo_metadata.csv**: a metadata file describing the fields of the Tallo.csv file
- **Reference_look_up_table.csv**: a look-up table matching reference ID codes in the Tallo.csv file to the original data sources
    

### Jucker et al. (2022)

Associated data files and R code used in the publication accompanying the release of the Tallo database:

- **R code to replicate case studies.R**: the R code that replicates the case studies in Jucker et al. (2022) GCB
- **Tallo_environment.csv**: environmental data layers for each tree in the Tallo.csv file needed to replicate the case studies in Jucker et al. (2022) GCB (zipped)
- **Tallo_environment_metadata.csv**: a metadata file describing the fields of the Tallo_environment.csv file
- **current_climate.csv**: current-day climate data layers at 5-arc minute spatial resolution needed to replicate case study 3 in Jucker et al. (2022) GCB (zipped)
- **future_climate_ssp245.csv**: projected future climate data layers at 5-arc minute spatial resolution needed to replicate case study 3 in Jucker et al. (2022) GCB (zipped)
