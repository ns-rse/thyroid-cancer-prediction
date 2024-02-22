## Filename : simulate_data.R
## Description : Generates dummy variables for the purpose of demonstrating modelling workflow
##
## Uses the fabricatr package https://declaredesign.org/r/fabricatr/index.html



## Load the saved data set
library(MASS)
library(tidyverse)
library(tidymodels)
library(fabricatr)
## Two options we can either source the cleaning file...
# source("r/master.R")
## Or we can load the file that is saved at the end and use that
df <- readRDS("data/r/clean.rds")

## Set a seed for random number generation. This ensures we get the same results each time the code is run.
set.seed(17010880)

## Set parameters
n_obs <- nrow(df)
gender_ratio <- 0.5
nodule_diameter_mean <- 24.82
nodule_diameter_sd <- 14.94
age_mean <- 54.37
age_sd <- 16.65
asa_score_boundary <- c(-Inf, -2, 6, 12, Inf)
smoking_boundary <- c(-Inf, 0, 1, Inf)
nodule_fna_thy_boundary <- c(-Inf, -4, 1, 6, 11, Inf)
scaling <- 5

dummy <- fabricatr::fabricate(
  N = n_obs,
  pathology = runif(n_obs),
  final_pathology = draw_binary(latent = pathology, link = "probit"),
  sex = runif(n_obs),
  gender = draw_binary(prob = gender_ratio, N = n_obs),
  ## asa_score = draw_ordered(),
  ## smoking_status = draw_ordered(),
  nodule_size = rnorm(n_obs,
    mean = nodule_diameter_mean,
    sd = nodule_diameter_sd
  ),
  age = round(rnorm(n_obs,
    mean = age_mean,
    sd = age_sd
  )),
  asa = scaling * rnorm(n_obs),
  asa_score = draw_ordered(
    x = asa,
    breaks = asa_score_boundary,
    break_labels = c("I", "II", "III", "IV")
  ),
  smoker = rnorm(n_obs),
  smoking_status = draw_ordered(
    x = smoker,
    breaks = smoking_boundary,
    break_labels = c("Non-Smoker", "Ex-smoker", "Current")
  ),
  nodule_fna = scaling * rnorm(n_obs),
  nodule_fna_thy = draw_ordered(
    x = nodule_fna,
    breaks = nodule_fna_thy_boundary,
    break_labels = c("Thy1", "Thy2", "Thy3", "Thy4", "Thy5")
  )
) |>
  dplyr::select(!c(pathology, sex, asa, smoker, nodule_fna)) |>
  ## Convert variables to factors
  dplyr::mutate(
    final_pathology = case_match(
      final_pathology,
      0 ~ "Benign",
      1 ~ "Malignant"
    ),
    final_pathology = as.factor(final_pathology),
    gender = case_match(
      gender,
      0 ~ "Male",
      1 ~ "Female"
    ),
    gender = as.factor(gender)
  )

var_labels <- c(
  ID = "ID",
  final_pathology = "Malignancy status",
  gender = "Gender",
  nodule_size = "Nodule Size (mm)",
  age = "Age (Years)",
  asa_score = "ASA Score",
  smoking_status = "Smoking Status",
  nodule_fna_thy = "FNA Thy Status"
)
Hmisc::label(dummy) <- as.list(var_labels[match(names(dummy), names(var_labels))])

# df_dummy <- cbind(df, dummy)
