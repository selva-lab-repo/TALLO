import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import pickle
matplotlib.use('TkAgg')

with open('Tallo_data.pkl', 'rb') as file:
    Tallo_merge = pickle.load(file)

makeplots = 0
if makeplots == 1:

    Tallo_merge.plot(x='stem_diameter_cm', y='height_m', style='o', logx=True, logy=True)
    plt.ylabel('Height')
    plt.xlabel('Stem diameter')
    #plt.title(biome_division)
    plt.show()

    Tallo_merge.plot(x='stem_diameter_cm', y='crown_radius_m', style='o', logx=True, logy=True)
    plt.ylabel('Crown radius')
    plt.xlabel('Stem diameter')
    #plt.title(biome_division)
    plt.show()

    Tallo_merge.plot(x='mean_annual_temperature', y='mean_annual_rainfall', style='o', logx=False, logy=False)
    plt.xlabel('Mean annual temperature')
    plt.ylabel('Mean annual rainfall')
    #plt.title(biome_division)
    plt.show()


# Check Table 1

print('Creating Table 1')

Table1 = pd.DataFrame()
for biome in Tallo_merge['biome'].unique():
    print(biome)
    numtrees = Tallo_merge[Tallo_merge['biome']==biome].shape[0]
    print(numtrees)


# Create figures per biome

makeplots = 1
if makeplots == 1:
    for biome_division in Tallo_merge['biome_division'].unique():

        Tallo_merge[Tallo_merge['biome_division']==biome_division].plot(x='height_m', y='stem_diameter_cm', style='o', logx=True, logy=True)
        plt.xlabel('Height')
        plt.ylabel('Stem diameter')
        plt.title(biome_division)
        plt.show()


makeplots = 0
if makeplots == 1:
    for biome_division in Tallo_merge['biome_division'].unique():

        Tallo_merge[Tallo_merge['biome_division']==biome_division].plot(x='crown_radius_m', y='stem_diameter_cm', style='o', logx=True, logy=True)
        plt.xlabel('Crown radius')
        plt.ylabel('Stem diameter')
        plt.title(biome_division)
        plt.show()

makeplots = 0
if makeplots == 1:
    for biome_division in Tallo_merge['biome_division'].unique():

        Tallo_merge[Tallo_merge['biome_division']==biome_division].plot(x='crown_radius_m', y='height_m', style='o', logx=True, logy=True)
        plt.xlabel('Crown radius')
        plt.ylabel('Height')
        plt.title(biome_division)
        plt.show()

