import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import pickle
matplotlib.use('TkAgg')



# Replicated from
# https://github.com/selva-lab-repo/TALLO/blob/main/Jucker%20et%20al.%202022/R%20code%20to%20replicate%20case%20studies.R



## Load Tallo database and merge with associated environmental data

Tallo = pd.read_csv("DB/Tallo.csv", keep_default_na=False)#,na_values='NA')
Tallo_env = pd.read_csv("Jucker et al. 2022/Tallo_environment.csv/Tallo_environment.csv", keep_default_na=False)#,na_values='NA')
print('Tallo')
print(Tallo.head())
print(Tallo.shape)
print(Tallo.columns)
print('Tallo_env')
print(Tallo_env.head())
print(Tallo_env.columns)
print(Tallo_env.shape)

Tallo_merge = Tallo.merge(Tallo_env)
del Tallo
del Tallo_env

print('Merged Tallo')
print(Tallo_merge.head())
print(Tallo_merge.columns)
print(Tallo_merge.shape)


## Remove outliers (set values to NA and remove any trees with NA values for both height and crown radius)

#print(Tallo_merge.height_outlier)
#print(Tallo_merge['height_outlier'])

#print(Tallo_merge['height_outlier']=='Y')

remove_outliers = 1

if remove_outliers==1:

    print('Removing height outliers')
    Tallo_merge = Tallo_merge[Tallo_merge['height_outlier']!='Y']
    print(Tallo_merge.shape)

    print('Removing crown radius outliers')
    Tallo_merge = Tallo_merge[Tallo_merge['crown_radius_outlier']!='Y']
    print(Tallo_merge.shape)


remove_nans = 1

if remove_nans == 1:

    print('Removing NaNs')
    Tallo_merge = Tallo_merge[Tallo_merge['crown_radius_m']!='NA']
    print(Tallo_merge.shape)
    Tallo_merge = Tallo_merge[Tallo_merge['height_m']!='NA']
    print(Tallo_merge.shape)
    print('Removed outliers')


print(Tallo_merge.head())
print(Tallo_merge.columns)
print(Tallo_merge.shape)



#### H:D scaling

## Subset data and assign tree from tropical rain forests with no taxonomic information as angiosperms
print('Assign tree from tropical rain forests with no taxonomic information as angiosperms')
Tallo_merge.loc[(Tallo_merge['division']=='NA') & (Tallo_merge['biome']=="Tropical rain forest"),'division'] = "Angiosperm"
Tallo_merge = Tallo_merge[Tallo_merge['crown_radius_m']!='NA']
Tallo_merge = Tallo_merge[Tallo_merge['height_m']!='NA']
Tallo_merge = Tallo_merge[Tallo_merge['division']!='NA']
print(Tallo_merge.shape)

Tallo_merge['biome_division'] = Tallo_merge['biome'] + '_' + Tallo_merge['division']
#print(Tallo_merge['biome_division'])

#plt.figure();
#bp = Tallo_merge.boxplot(by='stem_diameter_cm')

#plt.show(block=True)
#plt.interactive(False)

# Convert to float
Tallo_merge['latitude'] = Tallo_merge['latitude'].astype(float)
Tallo_merge['longitude'] = Tallo_merge['longitude'].astype(float)
Tallo_merge['stem_diameter_cm'] = Tallo_merge['stem_diameter_cm'].astype(float)
Tallo_merge['height_m'] = Tallo_merge['height_m'].astype(float)
Tallo_merge['crown_radius_m'] = Tallo_merge['crown_radius_m'].astype(float)
Tallo_merge['mean_annual_temperature'] = Tallo_merge['mean_annual_temperature'].astype(float)
Tallo_merge['mean_annual_rainfall'] = Tallo_merge['mean_annual_rainfall'].astype(float)
Tallo_merge['rainfall_seasonality'] = Tallo_merge['rainfall_seasonality'].astype(float)
Tallo_merge['aridity_index'] = Tallo_merge['aridity_index'].astype(float)
Tallo_merge['maximum_temperature'] = Tallo_merge['maximum_temperature'].astype(float)

# Save file to .pkl
with open('Tallo_data.pkl', 'wb') as file:
    pickle.dump(Tallo_merge, file)