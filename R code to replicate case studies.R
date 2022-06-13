
########################################################################################################################
########################################################################################################################
#####                                                                                                              #####
#####  Citation: Jucker et al. (2022). Tallo - a global tree allometry and crown architecture database.            #####                                        
#####            Global Change Biology                                                                             #####
#####                                                                                                              #####
#####  This R code replicates the three case studies presented in Jucker et al. (2022). Please cite the            #####
#####  original paper when using this code in your work.                                                           #####
#####                                                                                                              #####
########################################################################################################################
########################################################################################################################

# Load libraries ----------------------------------------------------------

library(dplyr)
library(tidyr)
library(lme4)
library(merTools)
library(MuMIn)

# Case study 1 ------------------------------------------------------------

## Load Tallo database and merge with associated environmental data
setwd("C:/")
Tallo<-read.csv("Tallo.csv",header=T, na.strings=c("NA"))
Tallo_env<-read.csv("Tallo_environment.csv",header=T, na.strings=c("NA"))
Tallo<-merge(Tallo,Tallo_env)

## Remove outliers (set values to NA and remove any trees with NA values for both height and crown radius)
Tallo$height_m[Tallo$height_outlier=="Y"]<-NA
Tallo$crown_radius_m[Tallo$crown_radius_outlier=="Y"]<-NA
Tallo<-filter(Tallo, !is.na(height_m)|!is.na(crown_radius_m))

#### H:D scaling

## Subset data and assign tree from tropical rain forests with no taxonomic information as angiosperms
Tallo_hd<-filter(Tallo,!is.na(height_m))
Tallo_hd$division<-ifelse(is.na(Tallo_hd$division)&Tallo_hd$biome=="Tropical rain forest","Angiosperm",Tallo_hd$division)
Tallo_hd<-filter(Tallo,!is.na(division))
Tallo_hd$biome_division<-as.factor(paste(Tallo_hd$biome,Tallo_hd$division,sep="_"))
table(Tallo_hd$biome_division)

## Fit model
M<-lmer(log(height_m)~log(stem_diameter_cm)+(log(stem_diameter_cm)|biome_division),data=Tallo_hd)
summary(M)
r.squaredGLMM(M)
coef(M)

## Calculate CIs for slopes
slope_ci_h <- REsim(M, n.sims = 1000)
slope_ci_h<-filter(slope_ci_h,term!="(Intercept)")
slope_ci_h$slope_mean<-NA
slope_ci_h$slope_2.5<-NA
slope_ci_h$slope_97.5<-NA
slope_ci_h$slope_10<-NA
slope_ci_h$slope_90<-NA
slope_random_draw<-rnorm(1000,coef(summary(M))[2,1],coef(summary(M))[2,2])

for (i in 1:dim(slope_ci_h)[1]){
  
  ## Mean slope
  slope_ci_h$slope_mean[i]<-mean(slope_random_draw+rnorm(1000,slope_ci_h$mean[i],slope_ci_h$sd[i]))
  ## 2.5% slope
  slope_ci_h$slope_2.5[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_h$mean[i],slope_ci_h$sd[i]),0.025)
  ## 97.5% slope
  slope_ci_h$slope_97.5[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_h$mean[i],slope_ci_h$sd[i]),0.975)
  ## 10% slope
  slope_ci_h$slope_10[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_h$mean[i],slope_ci_h$sd[i]),0.1)
  ## 90% slope
  slope_ci_h$slope_90[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_h$mean[i],slope_ci_h$sd[i]),0.9)
  
}

## Assign biome and division names
names(slope_ci_h)[2]<-"biome_division"
slope_ci_h$division<-gsub(".*_","",slope_ci_h$biome_division)
slope_ci_h$biome<-substr(slope_ci_h$biome_division, 1, regexpr("\\_", slope_ci_h$biome_division)-1)

## Add mean aridity index value
aridity_data<-Tallo_hd %>%
  dplyr::group_by(biome_division) %>%
  dplyr::summarise(aridity_index_m = mean(aridity_index))
slope_ci_h<-merge(slope_ci_h,aridity_data)

## Correlation between slope and aridity
cor.test(slope_ci_h$slope_mean,slope_ci_h$aridity_index_m)

#### CR:D scaling

## Subset data and assign tree from tropical rain forests with no taxonomic information as angiosperms
Tallo_cr<-filter(Tallo,!is.na(crown_radius_m))
Tallo_cr$division<-ifelse(is.na(Tallo_cr$division)&Tallo_cr$biome=="Tropical rain forest","Angiosperm",Tallo_cr$division)
Tallo_cr<-filter(Tallo,!is.na(division))
Tallo_cr$biome_division<-as.factor(paste(Tallo_cr$biome,Tallo_cr$division,sep="_"))
table(Tallo_cr$biome_division)

## Fit model
M<-lmer(log(crown_radius_m)~log(stem_diameter_cm)+(log(stem_diameter_cm)|biome_division),data=Tallo_cr)
summary(M)
r.squaredGLMM(M)
coef(M)

## Calculate CIs for slopes
slope_ci_cr <- REsim(M, n.sims = 1000)
slope_ci_cr<-filter(slope_ci_cr,term!="(Intercept)")
slope_ci_cr$slope_mean<-NA
slope_ci_cr$slope_2.5<-NA
slope_ci_cr$slope_97.5<-NA
slope_ci_cr$slope_10<-NA
slope_ci_cr$slope_90<-NA
slope_random_draw<-rnorm(1000,coef(summary(M))[2,1],coef(summary(M))[2,2])

for (i in 1:dim(slope_ci_cr)[1]){
  
  ## Mean slope
  slope_ci_cr$slope_mean[i]<-mean(slope_random_draw+rnorm(1000,slope_ci_cr$mean[i],slope_ci_cr$sd[i]))
  ## 2.5% slope
  slope_ci_cr$slope_2.5[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_cr$mean[i],slope_ci_cr$sd[i]),0.025)
  ## 97.5% slope
  slope_ci_cr$slope_97.5[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_cr$mean[i],slope_ci_cr$sd[i]),0.975)
  ## 10% slope
  slope_ci_cr$slope_10[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_cr$mean[i],slope_ci_cr$sd[i]),0.1)
  ## 90% slope
  slope_ci_cr$slope_90[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_cr$mean[i],slope_ci_cr$sd[i]),0.9)
  
}

## Assign biome and division names
names(slope_ci_cr)[2]<-"biome_division"
slope_ci_cr$division<-gsub(".*_","",slope_ci_cr$biome_division)
slope_ci_cr$biome<-substr(slope_ci_cr$biome_division, 1, regexpr("\\_", slope_ci_cr$biome_division)-1)

## Add mean aridity index value
slope_ci_cr<-merge(slope_ci_cr,aridity_data)

## Correlation between slope and aridity
cor.test(slope_ci_cr$slope_mean,slope_ci_cr$aridity_index_m)

#### CR:H scaling

## Subset data and assign tree from tropical rain forests with no taxonomic information as angiosperms
Tallo_crh<-filter(Tallo,!is.na(crown_radius_m)&!is.na(height_m))
Tallo_crh$division<-ifelse(is.na(Tallo_crh$division)&Tallo_crh$biome=="Tropical rain forest","Angiosperm",Tallo_crh$division)
Tallo_crh<-filter(Tallo,!is.na(division))
Tallo_crh$biome_division<-as.factor(paste(Tallo_crh$biome,Tallo_crh$division,sep="_"))
table(Tallo_crh$biome_division)

## Fit model
M<-lmer(log(crown_radius_m)~log(height_m)+(log(height_m)|biome_division),data=Tallo_crh)
summary(M)
r.squaredGLMM(M)
coef(M)

## Calculate CIs for slopes
slope_ci_crh <- REsim(M, n.sims = 1000)
slope_ci_crh<-filter(slope_ci_crh,term!="(Intercept)")
slope_ci_crh$slope_mean<-NA
slope_ci_crh$slope_2.5<-NA
slope_ci_crh$slope_97.5<-NA
slope_ci_crh$slope_10<-NA
slope_ci_crh$slope_90<-NA
slope_random_draw<-rnorm(1000,coef(summary(M))[2,1],coef(summary(M))[2,2])

for (i in 1:dim(slope_ci_crh)[1]){
  
  ## Mean slope
  slope_ci_crh$slope_mean[i]<-mean(slope_random_draw+rnorm(1000,slope_ci_crh$mean[i],slope_ci_crh$sd[i]))
  ## 2.5% slope
  slope_ci_crh$slope_2.5[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_crh$mean[i],slope_ci_crh$sd[i]),0.025)
  ## 97.5% slope
  slope_ci_crh$slope_97.5[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_crh$mean[i],slope_ci_crh$sd[i]),0.975)
  ## 10% slope
  slope_ci_crh$slope_10[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_crh$mean[i],slope_ci_crh$sd[i]),0.1)
  ## 90% slope
  slope_ci_crh$slope_90[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci_crh$mean[i],slope_ci_crh$sd[i]),0.9)
  
}

## Assign biome and division names
names(slope_ci_crh)[2]<-"biome_division"
slope_ci_crh$division<-gsub(".*_","",slope_ci_crh$biome_division)
slope_ci_crh$biome<-substr(slope_ci_crh$biome_division, 1, regexpr("\\_", slope_ci_crh$biome_division)-1)

## Add mean aridity index value
slope_ci_crh<-merge(slope_ci_crh,aridity_data)

## Correlation between slope and aridity
cor.test(slope_ci_crh$slope_mean,slope_ci_crh$aridity_index_m)

# Case study 2 ------------------------------------------------------------

## Load Tallo database and merge with associated environmental data
setwd("C:/")
Tallo<-read.csv("Tallo.csv",header=T, na.strings=c("NA"))
Tallo_env<-read.csv("Tallo_environment.csv",header=T, na.strings=c("NA"))
Tallo<-merge(Tallo,Tallo_env)

## Remove outliers (set values to NA and remove any trees with NA values for both height and crown radius)
Tallo$height_m[Tallo$height_outlier=="Y"]<-NA
Tallo$crown_radius_m[Tallo$crown_radius_outlier=="Y"]<-NA
Tallo<-filter(Tallo, !is.na(height_m)|!is.na(crown_radius_m))

## Filter Tallo and create a unique site x species identifier
Tallo_hd<-filter(Tallo,!is.na(species)&!is.na(height_m))
Tallo_hd$sp_site<-paste(round(Tallo_hd$latitude,2),round(Tallo_hd$longitude,2),Tallo_hd$species,sep="_")
Tallo_hd$sp_site<-factor(Tallo_hd$sp_site)

## Identify site x species combinations with >=10 trees
sp_site_table<-as.data.frame(table(Tallo_hd$sp_site))
names(sp_site_table)<-c("sp_site","n_tree_site")
sp_site_table<-filter(sp_site_table,n_tree_site>=10)

## Remove trees from sites that have <10 of a given species
Tallo_hd<-merge(Tallo_hd,sp_site_table[1])
Tallo_hd$site<-paste(round(Tallo_hd$latitude,2),round(Tallo_hd$longitude,2),sep="_")
Tallo_hd$site<-factor(Tallo_hd$site)

## Summarise by species and calculate relative change in aridity across sites
species_list<-Tallo_hd %>%
  dplyr::group_by(species) %>%
  dplyr::summarise(d_max = max(stem_diameter_cm),
                   d_range = max(stem_diameter_cm)-min(stem_diameter_cm),
                   n_trees = length(stem_diameter_cm),
                   aridity_sp_mean = mean(aridity_index),
                   aridity_change = min(aridity_index)/max(aridity_index),
                   n_sites  = length(unique(site))) %>%
  drop_na()

## Filter species list
species_list<-species_list[species_list$d_range>=20,]
species_list<-species_list[species_list$n_sites>=2,]
species_list<-species_list[species_list$aridity_change<=0.80,]

## Remove trees from non-target species and add mean species aridity values to data
Tallo_hd<-merge(Tallo_hd,species_list[c(1,5)])
length(unique(Tallo_hd$species))

## Group-mean center the aridity value of each tree by subtracting its aridity value from the species' mean
Tallo_hd$aridity_gc<-Tallo_hd$aridity_index-Tallo_hd$aridity_sp_mean

## Fit model (predictors scaled to compare model coefficents)
M_arid_s<-lmer(log(height_m)~scale(log(Tallo_hd$stem_diameter_cm))+scale(Tallo_hd$aridity_gc)+scale(Tallo_hd$aridity_sp_mean)+
                 (scale(log(Tallo_hd$stem_diameter_cm))+scale(Tallo_hd$aridity_gc)|species),Tallo_hd)
summary(M_arid_s)

## Fit model (unscaled predictors to generate predictions) 
M_arid<-lmer(log(height_m)~log(stem_diameter_cm)+aridity_gc+aridity_sp_mean+
               (log(stem_diameter_cm)+aridity_gc|species),Tallo_hd)

#### Generate predictions for each species

## Prediction data
new.data<-Tallo_hd %>%
  dplyr::group_by(species) %>%
  dplyr::summarise(stem_diameter_cm = 30,
                   aridity_sp_mean = median(aridity_index),
                   aridity_gc_m    = median(aridity_index) - median(aridity_index),
                   aridity_gc_l    = quantile(aridity_index,prob=0.10) - median(aridity_index),
                   aridity_gc_h    = quantile(aridity_index,prob=0.90) - median(aridity_index))

## Add model coefficents to data
M_coefs<-as.data.frame(coef(M_arid)$species)
M_coefs<-M_coefs[-c(1,4)]
names(M_coefs)<-c("slope_diameter","slope_aridity")
M_coefs$species<-row.names(M_coefs)        
new.data<-merge(new.data,M_coefs)

## Calculate 95% confidence intervals for random slopes
slope_ci <- REsim(M_arid, n.sims = 1000)
slope_ci<-filter(slope_ci,term=="aridity_gc")
slope_ci$slope_aridity_2.5<-NA
slope_ci$slope_aridity_97.5<-NA
slope_random_draw<-rnorm(1000,coef(summary(M_arid))[3,1],coef(summary(M_arid))[3,2])

for (i in 1:dim(slope_ci)[1]){
  
  ## 2.5% slope
  slope_ci$slope_aridity_2.5[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci$mean[i],slope_ci$sd[i]),0.025)
  ## 97.5% slope
  slope_ci$slope_aridity_97.5[i]<-quantile(slope_random_draw+rnorm(1000,slope_ci$mean[i],slope_ci$sd[i]),0.975)
  
}

names(slope_ci)[2]<-"species"
new.data<-merge(new.data,slope_ci[c(2,7:8)])

#### Height predictions 

## Mean aridity
names(new.data)[4]<-"aridity_gc"
new.data$height_aridity_m<-exp(predict(M_arid,new.data))
names(new.data)[4]<-"aridity_gc_m"

## Low aridity 
names(new.data)[5]<-"aridity_gc"
new.data$height_aridity_l<-exp(predict(M_arid,new.data))
names(new.data)[5]<-"aridity_gc_l"

## High aridity 
names(new.data)[6]<-"aridity_gc"
new.data$height_aridity_h<-exp(predict(M_arid,new.data))
names(new.data)[6]<-"aridity_gc_h"

## Add division, family and genus names
phylo_structure<-merge(new.data[1],Tallo_hd[c(1,6,5,4)])
phylo_structure<-unique(phylo_structure)
new.data<-merge(phylo_structure,new.data)
table(new.data$division)
new.data$Pch<-ifelse(new.data$division=="Angiosperm",16,21)

## Classify species based on response to aridity
new.data$aridity_effect<-ifelse(new.data$slope_aridity_97.5<0,"Negative",
                                ifelse(new.data$slope_aridity<0&new.data$slope_aridity_97.5>0,"Negative_ns",
                                       ifelse(new.data$slope_aridity>0&new.data$slope_aridity_2.5<0,"Positive_ns","Positive")))
table(new.data$aridity_effect,new.data$division)
pos<-filter(new.data,aridity_effect=="Positive")
neg<-filter(new.data,aridity_effect=="Negative")
neutral<-filter(new.data,aridity_effect!="Negative"&aridity_effect!="Positive")

## Correlation between a species' predicted height at D=30cm and its mean aridity index value
cor.test(new.data$height_aridity_m,new.data$aridity_sp_mean)

## Correlation between a species' height response to aridity (random slope for aridity_gc) and its mean aridity index value
cor.test(new.data$slope_aridity,new.data$aridity_sp_mean)

# Case study 3 ------------------------------------------------------------

## Load environmental data
setwd("C:/")
Tallo_env<-read.csv("Tallo_environment.csv",header=T, na.strings=c("NA"))
current_climate<-read.csv("current_climate.csv",header=T, na.strings=c("NA"))
future_climate<-read.csv("future_climate_ssp245.csv",header=T, na.strings=c("NA"))

## Load Tallo
Tallo<-read.csv("Tallo.csv",header=T, na.strings=c("NA"))
Tallo<-merge(Tallo,Tallo_env)

## Remove outliers (set values to NA and remove any trees with NA values for both height and crown radius)
Tallo$height_m[Tallo$height_outlier=="Y"]<-NA
Tallo$crown_radius_m[Tallo$crown_radius_outlier=="Y"]<-NA
Tallo<-filter(Tallo, !is.na(height_m)|!is.na(crown_radius_m))

## Subset data
Tallo_hd<-filter(Tallo,!is.na(height_m))
dim(Tallo_hd)[1]

## Set size threshold for prediction (biome specific)
D_threshold<-Tallo_hd %>%
  dplyr::group_by(biome) %>%
  dplyr::summarise(stem_diameter_cm = round(quantile(stem_diameter_cm,0.99),0))
future_climate<-merge(future_climate,D_threshold)
current_climate<-merge(current_climate,D_threshold)

## Fit model
M<-lm(log(height_m)~log(stem_diameter_cm)+log(aridity_index)+rainfall_seasonality+
        maximum_temperature+mean_annual_temperature+mean_annual_temperature:log(aridity_index),Tallo_hd)

## Predict current height (including Baskerville correction)
baskerville_cor<-exp(sigma(M)^2/2)
current_climate$height_m<-exp(predict(M,current_climate))*baskerville_cor 
hist(current_climate$height_m)
mean(current_climate$height_m);quantile(current_climate$height_m,c(0,0.025,0.25,0.50,0.75,0.975,1))

## Predict future height
future_climate$height_m<-exp(predict(M,future_climate))*baskerville_cor 
hist(future_climate$height_m)
mean(future_climate$height_m);quantile(future_climate$height_m,c(0,0.025,0.25,0.50,0.75,0.975,1))

## Absolute change in height
future_climate$h_change<-future_climate$height_m-current_climate$height_m
hist(future_climate$h_change)
mean(future_climate$h_change);quantile(future_climate$h_change,c(0,0.025,0.25,0.50,0.75,0.975,1))

## Relative change in height
future_climate$h_change_rel<-(future_climate$height_m-current_climate$height_m)/current_climate$height_m*100
hist(future_climate$h_change_rel)
mean(future_climate$h_change_rel);quantile(future_climate$h_change_rel,c(0,0.025,0.25,0.50,0.75,0.975,1))

## Relative and absolute height change by biome and biogegraphic realm
h_change_biome<-future_climate %>%
  dplyr::group_by(biome) %>%
  dplyr::summarise(h_change_rel_m = round(mean(h_change_rel),1),
                   h_change_rel_25 = round(quantile(h_change_rel,0.25),1),
                   h_change_rel_75 = round(quantile(h_change_rel,0.75),1),
                   h_change_m = round(mean(h_change),1),
                   h_change_25 = round(quantile(h_change,0.25),1),
                   h_change_75 = round(quantile(h_change,0.75),1))

h_change_biome_realm<-future_climate %>%
  dplyr::group_by(biome,realm) %>%
  dplyr::summarise(h_change_rel_m = round(mean(h_change_rel),1),
                   h_change_rel_25 = round(quantile(h_change_rel,0.25),1),
                   h_change_rel_75 = round(quantile(h_change_rel,0.75),1),
                   h_change_m = round(mean(h_change),1),
                   h_change_25 = round(quantile(h_change,0.25),1),
                   h_change_75 = round(quantile(h_change,0.75),1))
