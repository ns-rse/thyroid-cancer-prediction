## Filename : simulate_data.R
## Description : Generates dummy variables for the purpose of demonstrating modelling workflow
##
## The code here was guided by the article https://www.r-bloggers.com/2021/05/how-to-generate-correlated-data-in-r/



## Load the saved data set
library(dplyr)
library(fabricatr)
library(MASS)
library(tidyverse)
library(tidymodels)
library(ggdark)
library(knitr)
library(tidyr)

#' simulate_data
#'
#' @description A function that simulates artificial data.
#'
#' @param prop_malignant float Proportion of individuals who have malignant tumors.
#' @param gender_ratio float Gender ratio (default = 0.5).
#' @param nodule_diameter_mean float Mean nodule maximum diameter in mm (default `24.82`)
#' @param nodule_diameter_sd float Standard Deviation of nodule maximum diameter in mm (default `14.94`),
#' @param age_mean float Mean age in years (default `54.37`)
#' @param age_sd float Standard Deviation of age in years (default `16.65`),
#' @param asa_score_boundary vector ASA score is generated from a scaled standard normal distribution (see `scaling`),
#' these  are the boundaries for classifying as I/II/III/IV (default `c(-Inf, -2, 6, 12, Inf)`)
#' @param smoking_boundary vector Smoking classification is generated from an unscaled normal distribution (i.e. N(0,
#' 1)), #' these are the boundaries for classifying as Non-Smoker/Ex-Smoker/Current (default `c(-Inf, 0, 1, Inf)`).
#' @param nodule_fna_thy_boundary vector FNA Thyroid Nodule classification is generated from a scaled standard normal
#' distribution (see `scaling`), these are the boundaries for classifying as Thy1/Thy2/Thy3/Thy4/Thy5 (default `c(-Inf,
#' -4, #' 1, 6, 11, Inf)`)
#' @param scaling vector Factor by which random variables generated from a standard normal distribution (i.e. N(0, 1))
#' are #' scaled (default 5). If you change this parameter you will likely have to change the `asa_score_boundary` and
#' `nodule_fna_thy_boundary`.
#' @param seed int Seed to ensure results are reproducible (default `17010880`).
#'
#' @return DataFrame of simulated data
#'
#' @noRd
simulate_data <- function(N = 1000,
                          prop_malignant = 0.1,
                          gender_ratio = 0.5,
                          nodule_diameter_mean = 24.82,
                          nodule_diameter_sd = 14.94,
                          age_mean = 54.37,
                          age_sd = 16.65,
                          asa_score_boundary = c(-Inf, -2, 6, 12, Inf),
                          smoking_boundary = c(-Inf, 0, 1, Inf),
                          nodule_fna_thy_boundary = c(-Inf, -4, 1, 6, 11, Inf),
                          scaling = 5,
                          seed = 17010880) {
  ## Set a seed for random number generation. This ensures we get the same results each time the code is run.
  set.seed(seed)
  df <- fabricatr::fabricate(
    N = N,
    pathology = runif(N),
    final_pathology = draw_binary(latent = pathology, link = "identity"),
    sex = runif(N),
    gender = draw_binary(prob = gender_ratio, N = N),
    nodule_size = rnorm(N,
      mean = nodule_diameter_mean,
      sd = nodule_diameter_sd
    ),
    age = round(rnorm(N,
      mean = age_mean,
      sd = age_sd
    )),
    asa = scaling * rnorm(N),
    asa_score = draw_ordered(
      x = asa,
      breaks = asa_score_boundary,
      break_labels = c("I", "II", "III", "IV")
    ),
    smoker = rnorm(N),
    smoking_status = draw_ordered(
      x = smoker,
      breaks = smoking_boundary,
      break_labels = c("Non-Smoker", "Ex-smoker", "Current")
    ),
    nodule_fna = scaling * rnorm(N),
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
  Hmisc::label(df) <- as.list(var_labels[match(names(df), names(var_labels))])
  return(df)
}


##########################################################################
## Old code written before discovering the fabricatr package            ##
##########################################################################

## Set a seed for random number generation. This ensures we get the same results each time the code is run.
## set.seed(17010880)

## Create a varianc co-variance matrix
## sigma <- rbind(
##   c(1.1265924, 0.6387496, -0.2630270, 0.2875068),
##   c(0.6387496, 1.2053968, 0.8055271, -0.2540865),
##   c(0.2630270, 0.8055271, 1.1482047, -0.4735176),
##   c(0.2875068, -0.2540865, -0.4735176, 1.0012329)
## )
## det(sigma)

## Generate the mean vector
## mu <- c(44, 10, 6, 3)

## Generate the multivariate normal distribution
## dummy <- as.data.frame(MASS::mvrnorm(n = nrow(df), mu = mu, Sigma = sigma))

## Generate binary outcome variable with noise
## dummy <- dummy |>
##   mutate(
##     final_pathology_dummy = ifelse(V4 > median(V4),
##       sample(c(0, 1), n(), replace = TRUE, p = c(0.25, 0.75)),
##       sample(c(0, 1), n(), replace = TRUE, p = c(0.75, 0.25))
##     ),
##     final_pathology_dummy = case_when(
##       V4 <= median(V4) ~ sample(c("Bengin", "Malignant"),
##         n(),
##         replace = TRUE,
##         p = c(0.25, 0.75)),
##       TRUE ~ sample(c("Bengin", "Malignant"),
##         n(),
##         replace = TRUE,
##         p = c(0.75, 0.25))),
##     dummy_cat_1 = case_when(
##       V3 < quantile(V3, 0.25) ~ sample(c("a", "b", "c", "d"),
##         n(),
##         replace = TRUE,
##         p = c(0.7, 0.1, 0.1, 0.1)
##       ),
##       V3 < quantile(V3, 0.50) ~ sample(c("a", "b", "c", "d"),
##         n(),
##         replace = TRUE,
##         p = c(0.1, 0.7, 0.1, 0.1)
##       ),
##       V3 < quantile(V3, 0.75) ~ sample(c("a", "b", "c", "d"),
##         n(),
##         replace = TRUE,
##         p = c(0.1, 0.1, 0.7, 0.1)
##       ),
##       TRUE ~ sample(c("a", "b", "c", "d"),
##         n(),
##         replace = TRUE,
##         p = c(0.1, 0.1, 0.7, 0.1)
##       )
##     ),
##     dummy_cat_2 = case_when(
##       V2 < quantile(V2, 0.15) ~ sample(c("I", "II", "III", "IV"),
##         n(),
##         replace = TRUE,
##         p = c(0.8, 0.1, 0.05, 0.05)
##       ),
##       V2 < quantile(V2, 0.65) ~ sample(c("I", "II", "III", "IV"),
##         n(),
##         replace = TRUE,
##         p = c(0.1, 0.8, 0.05, 0.05)
##       ),
##       V2 < quantile(V2, 0.85) ~ sample(c("I", "II", "III", "IV"),
##         n(),
##         replace = TRUE,
##         p = c(0.1, 0.05, 0.8, 0.05)
##       ),
##       TRUE ~ sample(c("I", "II", "III", "IV"),
##         n(),
##         replace = TRUE,
##         p = c(0.1, 0.05, 0.05, 0.8)
##       )
##     )
##   )
## GGally::ggpairs(dummy)

## df_dummy <- cbind(df, dummy)
