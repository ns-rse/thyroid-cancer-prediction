## Filename    : master.R
## Description : Master file that controls running of all subsequent scripts.
library(dplyr)
library(forcats)
library(Hmisc)
library(lubridate)
library(tidymodels)
library(tidyverse)
library(vip)

## Set directories based on current location
base_dir <- getwd()
data_dir <- paste(base_dir, "data", sep = "/")
csv_dir <- paste(data_dir, "csv", sep = "/")
r_dir <- paste(data_dir, "r", sep = "/")
r_scripts <- paste(base_dir, "r", sep = "/")

## Clean the data
source(paste(r_scripts, "clean.R", sep = "/"))


## Simulate data
source(paste(r_scripts, "simulate_data.R", sep = "/"))

## Run Statistical models
source(paste(r_scripts, "tidymodel.R", sep = "/"))
