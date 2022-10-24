import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import pickle
import time
from sklearn.metrics import mean_squared_error, max_error, mean_absolute_error
matplotlib.use('TkAgg')


# Replicated from
# https://github.com/selva-lab-repo/TALLO/blob/main/Jucker%20et%20al.%202022/R%20code%20to%20replicate%20case%20studies.R

# Load data
with open('Tallo_data.pkl', 'rb') as file:
    Tallo_merge = pickle.load(file)





#Randomize data rows

print(Tallo_merge[1:10])
Tallo_merge = Tallo_merge.sample(frac=1).reset_index(drop=True)

print(Tallo_merge[1:10])

#Select input features according to case 3
#M<-lm(log(height_m)~log(stem_diameter_cm)+log(aridity_index)+rainfall_seasonality+
# maximum_temperature+mean_annual_temperature+mean_annual_temperature:log(aridity_index),Tallo_hd)
x_all = Tallo_merge[['stem_diameter_cm', 'aridity_index', 'rainfall_seasonality', 'maximum_temperature', 'mean_annual_temperature']]
x_all['aridity_index'] = np.log10(x_all['aridity_index'])
x_all['stem_diameter_cm'] = np.log10(x_all['stem_diameter_cm'])
x_all['AT_AI'] = x_all['mean_annual_temperature']/x_all['aridity_index']


#Select output feature
y_all = Tallo_merge['height_m']
y_all = np.log10(y_all)

print(x_all)
print(x_all.shape)
print(y_all)
print(y_all.shape)


# Split in train and test

num_samples = x_all.shape[0]
if num_samples != y_all.shape[0]:
    print('Warning: different number of input and output samples.')
x_train = x_all[0:int(np.ceil(0.8*num_samples))] #80% training
y_train = y_all[0:int(np.ceil(0.8*num_samples))] #80% training
x_val = x_all[int(np.ceil(0.8*num_samples)):int(np.ceil(0.9*num_samples))] #10% validation
y_val = y_all[int(np.ceil(0.8*num_samples)):int(np.ceil(0.9*num_samples))] #10% validation
x_test = x_all[int(np.ceil(0.9*num_samples)):int(num_samples)] #10% test
y_test = y_all[int(np.ceil(0.9*num_samples)):int(num_samples)] #10% test
#
#
# print('Show data')
# print('x_train', x_train)
# print('y_train', y_train)
# print('x_val', x_val)
# print('y_val', y_val)
# print('x_test', x_test)
# print('y_test', y_test)


# Train linear model

trainLM = 1
if trainLM:
    from sklearn import linear_model

    LM = linear_model.LinearRegression()
    print('Training linear regressor...')
    t0 = time.time()
    LM.fit(x_train, y_train)
    t1 = time.time()
    LM_time = t1 - t0
    print('Done training linear regressor...')
    LM_train = LM.predict(x_train)
    LM_val = LM.predict(x_val)
    LM_trainmse = mean_squared_error(y_train, LM_train)
    LM_trainmax = max_error(y_train, LM_train)
    LM_trainmae = mean_absolute_error(y_train, LM_train)
    LM_valmse = mean_squared_error(y_val, LM_val)
    LM_valmax = max_error(y_val, LM_val)
    LM_valmae = mean_absolute_error(y_val, LM_val)
    print('Training time: ', LM_time)
    print('Train MSE: ', LM_trainmse)
    print('Validation MSE: ', LM_valmse)
    print('Train MAE: ', LM_trainmae)
    print('Validation MAE: ', LM_valmae)
    print('Train max: ', LM_trainmax)
    print('Validation max: ', LM_valmax)

    # Save model
    LMfile = "LM.pkl"
    with open(LMfile, 'wb') as file:
        pickle.dump(LM, file)

# Train a random forest

trainRF = 1
if trainRF:
    from sklearn.ensemble import RandomForestRegressor

    RF = RandomForestRegressor()
    print('Training random forest regressor...')
    t0 = time.time()
    RF.fit(x_train, y_train)
    t1 = time.time()
    RF_time = t1 - t0
    print('Done training random forest regressor...')
    RF_train = RF.predict(x_train)
    RF_val = RF.predict(x_val)
    RF_trainmse = mean_squared_error(y_train, RF_train)
    RF_trainmax = max_error(y_train, RF_train)
    RF_trainmae = mean_absolute_error(y_train, RF_train)
    RF_valmse = mean_squared_error(y_val, RF_val)
    RF_valmax = max_error(y_val, RF_val)
    RF_valmae = mean_absolute_error(y_val, RF_val)

    print('Training time: ', RF_time)
    print('Train MSE: ', RF_trainmse)
    print('Validation MSE: ', RF_valmse)
    print('Train MAE: ', RF_trainmae)
    print('Validation MAE: ', RF_valmae)
    print('Train max: ', RF_trainmax)
    print('Validation max: ', RF_valmax)

    # Save surrogate
    RFfile = "RF.pkl"
    with open(RFfile, 'wb') as file:
        pickle.dump(RF, file)


